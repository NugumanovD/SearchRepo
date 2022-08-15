//
//  UserSessionService.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

enum SessionState {
  
  case authorize
  case nonAuthorize
  
}

protocol UserSessionServiceProvider {
  
  var didSignOutAction: PublishSubject<Void> { get }
  
}

final class UserSessionService {
  
  var state = ReplaySubject<SessionState>.create(bufferSize: 1)
  
  var didSignInAction = PublishSubject<String>()
  var didSignOutAction = PublishSubject<Void>()
  
  private let keychainManager = KeychainManager.shared
  private let disposeBad = DisposeBag()
  
  init() {
    state.onNext(userSessionState())
    initializeBindings()
  }
  
  private func initializeBindings() {
    didSignInAction.doOnNext { [weak self] token in
      self?.keychainManager.setAuthToken(value: token)
      self?.state.onNext(.authorize)
    }.disposed(by: disposeBad)
    
    didSignOutAction.doOnNext { [weak self] _ in
      self?.keychainManager.removeAll()
      self?.state.onNext(.nonAuthorize)
    }.disposed(by: disposeBad)
  }
  
  private func userSessionState() -> SessionState {
    keychainManager.getAuthToken() != nil ? .authorize : .nonAuthorize
  }
  
}

extension UserSessionService: UserSessionServiceProvider {}
