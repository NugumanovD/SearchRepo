//
//  RepositoriesViewModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import RxSwift
import Foundation
import RxRelay

final class RepositoriesViewModel {
  
  var model: RepositoriesModel
  var items = BehaviorRelay<[RepositoryConfiguration]>(value: [])
  
  var selectedCellAction: PublishSubject<RepositoryConfiguration> {
    model.selectedCellAction
  }
  
  var alertButtonAction: PublishSubject<Void> {
    model.alertButtonAction
  }
  
  var onShowError: PublishSubject<AlertControllerModel> {
    model.onShowError
  }
  
  var searchInput: BehaviorRelay<String?> {
    model.searchInput
  }
  
  var logOutAction: PublishSubject<Void> {
    model.logOutAction
  }
  
  var loadNextPageAction: PublishSubject<Void> {
    model.loadNextPageAction
  }
  
  var isLoadingSpinnerAvaliable: PublishSubject<Bool> {
    model.isLoadingSpinnerAvaliable
  }
  
  private let disposeBag = DisposeBag()
  
  init(model: RepositoriesModel) {
    self.model = model
    
    setupBindings()
  }
  
  private func setupBindings() {
    model.presentableRepositories.bind(to: items).disposed(by: disposeBag)
  }
  
}

struct RepositoryConfiguration {
  
  var id: Int
  var title: String?
  var stargazersCount: Int?
  var language: String?
  var pageURLString: String?
  var avatarURLString: String?
  var viewed: Bool
  
  var avatarURL: URL {
    URL(string: avatarURLString ?? "http://www.github.com")!
  }
  
  var pageURL: URL {
    URL(string: pageURLString ?? "http://www.github.com")!
  }
  
}
