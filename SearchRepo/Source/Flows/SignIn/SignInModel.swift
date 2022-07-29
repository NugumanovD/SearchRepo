//
//  SignInModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import RxSwift
import RxCocoa

final class SignInModel {
  
  let signInAction = PublishSubject<Void>()
  
  private let disposeBag = DisposeBag()
  
  init() {
    setupBindings()
  }
  
  private func setupBindings() {
    signInAction.subscribe { _ in }
    .disposed(by: disposeBag)
  }
  
}
