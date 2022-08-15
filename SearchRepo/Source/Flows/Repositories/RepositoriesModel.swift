//
//  RepositoriesModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import RxSwift
import RxRelay
import Foundation
import CoreData

enum AlertControllerString {
  
  static let title = "Warning"
  static let message = "Unfortunately, the number of requests is limited. Try to execute the request after 30 seconds"
  static let buttonTitle = "Ok"
  
}

fileprivate enum SourceRepositories {
  
  case load
  case preload
  
}

final class RepositoriesModel {
  
  let searchInput = BehaviorRelay<String?>(value: nil)
  let presentableRepositories = BehaviorRelay<[RepositoryConfiguration]>(value: [])
  let loadNextPageAction = PublishSubject<Void>()
  let logOutAction = PublishSubject<Void>()
  let selectedCellAction = PublishSubject<RepositoryConfiguration>()
  let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
  let alertButtonAction = PublishSubject<Void>()
  let onShowError = PublishSubject<AlertControllerModel>()
  
  private let repositories = BehaviorRelay<[Repository]>(value: [])
  private let loadRepositories = BehaviorRelay<[Repository]>(value: [])
  private let preloadRepositories = BehaviorRelay<[Repository]>(value: [])
  private var isPaginationRequestStillResume = BehaviorRelay<Bool>(value: false)
  private var currentPage = AtomicInteger(value: 0)
  private let chuckAmount = 15
  private var isCatchError = false
  private let coordinator: TabBarCoordinator
  private let repositoriesService: SearchRepositoriesServiceProvider
  private let userSession: UserSessionServiceProvider
  private let coreDataManager: CoreDataManager
  private let disposeBag = DisposeBag()
  
  init(
    repositoriesService: SearchRepositoriesServiceProvider,
    coordinator: TabBarCoordinator,
    userSession: UserSessionServiceProvider,
    coreDataManager: CoreDataManager
  ) {
    self.repositoriesService = repositoriesService
    self.coordinator = coordinator
    self.userSession = userSession
    self.coreDataManager = coreDataManager
    
    setupBindings()
    observeNotitfications()
  }
  
  private func observeNotitfications() {
    let _ = NotificationCenter.default
      .addObserver(for: NSManagedObjectContextChanges.self, object: self.coreDataManager.mainManagedObjectContext, queue: nil) { (changes) in
        var entity = RepositoryEntity()
        
        if let insertedObject = changes.insertedObjects.first(where: { $0 is RepositoryEntity }),
           let repositoryEntityObject = insertedObject as? RepositoryEntity {
          entity = repositoryEntityObject
        }
        
        if let index = self.repositories.value.firstIndex(where: { $0.id == entity.id }) {
          var repositoriesValue = self.repositories.value
          repositoriesValue[index] = entity.convertToRepository()
          self.repositories.accept(self.repositories.value)
        }
      }
  }
  
  private func setupBindings() {
    searchInput
      .skip(1)
      .compactMap { $0 }
      .doOnNext { [weak self] searchText in
        guard let self = self else { return }
        self.currentPage.value = 0
        self.loadRepositories(searchText: searchText, needToAppend: false)
    }.disposed(by: disposeBag)
    
    loadNextPageAction
      .doOnNext { [weak self] in
        guard let self = self, !self.repositories.value.isEmpty else { return }
        
        self.loadRepositories(searchText: self.searchInput.value, needToAppend: true)
      }
      .disposed(by: disposeBag)
    
    selectedCellAction
      .compactMap { $0 }
      .doOnNext { [weak self] repository in
        guard let self = self else { return }
        self.markAsViewedIfNeeded(with: repository.id)
        self.coordinator.openURL(url: repository.pageURL)
      }
      .disposed(by: disposeBag)
    
    logOutAction.bind(to: userSession.didSignOutAction).disposed(by: disposeBag)
    
    repositories
      .map { [weak self] in
        guard let self = self else { return [RepositoryConfiguration]() }

        return self.mergeWithStorageRepositories(sortedValues: $0)
          .map { $0.toRepositoryConfiguration() }
      }
      .bind(to: presentableRepositories)
      .disposed(by: disposeBag)
    
    Observable.zip(loadRepositories, preloadRepositories) { loadRepositories, preloadRepositories in
      loadRepositories + preloadRepositories
    }
    /// Due to the limited number of requests, a delay has been set
    .delay(.milliseconds(1500), scheduler: MainScheduler.instance)
    .doOnNext({ [weak self] mergedRepositories in
      guard let self = self else { return }
      
      let sortedValues = mergedRepositories.sorted(by: { $0.stargazersCount > $1.stargazersCount })
      
      self.repositories.accept(sortedValues)
      self.isLoadingSpinnerAvaliable.onNext(false)
      self.isPaginationRequestStillResume.accept(false)
    })
    .disposed(by: disposeBag)
    
    alertButtonAction.doOnNext { [weak self] _ in
      guard let self = self else { return }
      
      self.isCatchError = false
      self.isLoadingSpinnerAvaliable.onNext(false)
      self.isPaginationRequestStillResume.accept(false)
    }
    .disposed(by: disposeBag)
  }
  
  private func mergeWithStorageRepositories(sortedValues: [Repository]) -> [Repository] {
    guard let storageRepositories = self.coreDataManager.fetchAllRepositories(),
          !storageRepositories.isEmpty
    else { return sortedValues }
    
    var mergedArray: [Repository] = []
    
    for item in sortedValues {
      var tempRepositories = item
      if storageRepositories.contains(where: { Int($0.id) == item.id }) {
        tempRepositories.isViewed = true
      }
      mergedArray.append(tempRepositories)
    }
    
    return mergedArray
  }
  
  private func markAsViewedIfNeeded(with id: Int) {
    if let _ = try? coreDataManager.find(id: id) {
      return
    }
    
    if let repository = repositories.value.first(where: { $0.id == id }) {
      let context = coreDataManager.mainManagedObjectContext
      repository.convertToRepositoryEntity(with: context)
      coreDataManager.saveChanges()
    }
  }
  
  private func loadRepositories(searchText: String?, needToAppend: Bool) {
    if isPaginationRequestStillResume.value || isCatchError { return }
    
    DispatchQueue.global(qos: .background).async {
      self.fetchRepositories(searchText: searchText, typeOfSource: .load, needToAppend: needToAppend)
    }
    /// Due to the limited number of requests, a delay has been set
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.5, execute: {
      self.fetchRepositories(searchText: searchText, typeOfSource: .preload, needToAppend: needToAppend)
    })
  }
  
  private func incrementCurrentPage() {
    currentPage.value += 1
  }
  
  private func applyResponse(_ needToAppend: Bool, source: BehaviorRelay<[Repository]>, response: [Repository]) {
    if needToAppend {
      source.accept(source.value + response)
    } else {
      source.accept(response)
    }
  }
  
  private func fetchRepositories(searchText text: String? = nil, typeOfSource: SourceRepositories, needToAppend: Bool = false) {
    let searchPath = text ?? searchInput.value ?? ""
    
    isPaginationRequestStillResume.accept(true)
    isLoadingSpinnerAvaliable.onNext(true)
    
    if currentPage.value == 1 {
      self.isLoadingSpinnerAvaliable.onNext(false)
    }
    
    incrementCurrentPage()
    repositoriesService.findRepositories(searchPath: searchPath, sort: .byStars, chuckAmount: chuckAmount, page: self.currentPage.value)
      .compactMap { $0.repositories }
      .map { $0 }
      .subscribe { [weak self] repositories in
        guard let self = self else { return }
        
        if typeOfSource == .load {
          self.applyResponse(needToAppend, source: self.loadRepositories, response: repositories)
        } else {
          self.applyResponse(needToAppend, source: self.preloadRepositories, response: repositories)
        }
      } onError: { [weak self] error in
        guard let self = self else { return }
        
        if let error = error as? ResponseError {
          self.handleError(error)
        }
      }.disposed(by: disposeBag)
  }
  
  private func handleError(_ error: ResponseError) {
    print(error.localizedDescription)
    isCatchError = true
    onShowError.onNext(
      .init(
        title: AlertControllerString.title,
        message: AlertControllerString.message,
        buttonTitle: AlertControllerString.buttonTitle
      )
    )
  }
  
}
