//
//  HistoryViewModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class HistoryViewModel {
  
  var model: HistoryModel
  
  var items = BehaviorRelay<[RepositoryConfiguration]>(value: [])
  
  private let disposeBag = DisposeBag()
  
  init(model: HistoryModel) {
    self.model = model
    
    initializeBindings()
  }
  
  private func initializeBindings() {
    model.presentableRepositories.bind(to: items).disposed(by: disposeBag)
  }
    
  
}
