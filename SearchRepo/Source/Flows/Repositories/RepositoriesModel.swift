//
//  RepositoriesModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import RxSwift
import RxRelay
import Foundation

enum State {
  
  case initial
  case loading
  case onSuccess
  case onError
  
}

final class RepositoriesModel {
  
  let searchInput = BehaviorRelay<String>(value: "")
  let repositories = BehaviorRelay<[Repository]>(value: [])
  let loadNextPageAction = PublishSubject<Void>()
  let logOutAction = PublishSubject<Void>()
  let selectedCellAction = PublishSubject<String>()
  let state = BehaviorRelay<State>(value: .initial)
  
  private var currentPage = 1
  
  private let coordinator: TabBarCoordinator
  private let repositoriesService: SearchRepositoriesService
  private let userSession: UserSessionService
  private let disposeBag = DisposeBag()
  
  init(
    repositoriesService: SearchRepositoriesService,
    coordinator: TabBarCoordinator,
    userSession: UserSessionService
  ) {
    self.repositoriesService = repositoriesService
    self.coordinator = coordinator
    self.userSession = userSession
    
    setupBindings()
  }
  
  private func setupBindings() {
    searchInput
      .filter { !$0.isEmpty }
      .distinctUntilChanged().debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .doOnNext { [weak self] searchPath in
        self?.currentPage = 1
      self?.loadRepositories(searchPath: searchPath)
    }.disposed(by: disposeBag)
    
    loadNextPageAction.skip(1)
      .doOnNext { [weak self] in
        if self?.state.value == .loading { return }
        self?.currentPage += 1
        self?.loadRepositories()
      }
      .disposed(by: disposeBag)
    
    selectedCellAction
      .compactMap { stringURL -> URL? in
      return URL(string: stringURL)
    }.doOnNext { [weak self] url in
      self?.coordinator.openURL(url: url)
    }.disposed(by: disposeBag)
    
    logOutAction.bind(to: userSession.didSignOutAction).disposed(by: disposeBag)
  }
  
  private func loadRepositories(searchPath path: String? = nil, currentPage: Int = 0) {
    let searchPath = path ?? searchInput.value
    state.accept(.loading)
    repositoriesService.findRepositories(searchPath: searchPath, sort: .byStars, chuckAmount: 15, page: currentPage)
      .compactMap { $0.repositories }
      .subscribe { [weak self] repositories in
        guard let self = self else { return }
        self.state.accept(.onSuccess)
        if self.currentPage == 1 {
          self.repositories.accept(repositories)
        } else {
          let currentRepositories = self.repositories.value
          self.repositories.accept(currentRepositories + repositories)
        }
      } onError: { [weak self] error in
        // TODO: - Show Aleert
        self?.state.accept(.onError)
        print(error.localizedDescription)
      }.disposed(by: disposeBag)
  }
  
}
