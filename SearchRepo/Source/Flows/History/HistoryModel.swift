//
//  HistoryModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

final class HistoryModel {
  
  let presentableRepositories = BehaviorRelay<[RepositoryConfiguration]>(value: [])
  
  private let coreDataManager: CoreDataManager
  private let disposeBag = DisposeBag()
  
  init(coreDataManager: CoreDataManager) {
    self.coreDataManager = coreDataManager
    
    initializeBindings()
    observeNotitfications()
  }
  
  private func initializeBindings() {
    fetchAllRepositories()
      .compactMap { $0 }
      .doOnNext { repository in
      self.presentableRepositories.accept(repository)
    }.disposed(by: disposeBag)
  }

  private func observeNotitfications() {
    let _ = NotificationCenter.default
      .addObserver(for: NSManagedObjectContextChanges.self, object: self.coreDataManager.mainManagedObjectContext, queue: nil) { (changes) in
        var entity = RepositoryEntity()
        
        if let repositoryEntityObject = changes.insertedObjects.first as? RepositoryEntity {
          entity = repositoryEntityObject
        } else if let ownerObject = changes.insertedObjects.first as? OwnerEntity,
                  let repository = ownerObject.repository {
          entity = repository
        }
        
        self.presentableRepositories.acceptThanAppend(entity.toRepositoryConfiguration())
      }
  }
  
  private func fetchAllRepositories() -> Observable<[RepositoryConfiguration]?> {
    return Observable<[RepositoryConfiguration]?>.create { [weak self] observer in
      
      let repositories = self?.coreDataManager.fetchAllRepositories()?
        .map { $0.convertToRepository() }
        .map { $0.toRepositoryConfiguration() }
      observer.onNext(repositories)
      observer.onCompleted()
      
      return Disposables.create()
    }
  }
  
}
