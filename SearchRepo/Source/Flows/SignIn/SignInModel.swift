//
//  SignInModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import RxSwift

final class SignInModel {
  
  let signInAction = PublishSubject<Void>()
  
  private let signInService: SignInService
  private let coordinator: SignInCoordinatorProvider
  private let userSession: UserSessionService
  private let deepLinkHandler: DeepLinkHandler
  private let disposeBag = DisposeBag()
  
  init(
    signInService: SignInService,
    coordinator: SignInCoordinatorProvider,
    userSesion: UserSessionService,
    deepLinkHandler: DeepLinkHandler
  ) {
    self.signInService = signInService
    self.coordinator = coordinator
    self.userSession = userSesion
    self.deepLinkHandler = deepLinkHandler
    
    setupBindings()
  }
  
  private func setupBindings() {
    signInAction.subscribe { [weak self] _ in
      guard let url = self?.signInService.getAuthPageUrl() else {
        return
      }
      self?.coordinator.openURL(url: url)
    }
    .disposed(by: disposeBag)
    
    deepLinkHandler.authorizationCode
      .flatMap(signInService.getAuthorizationToken)
      .map { $0.accessToken }
      .subscribe { [weak self] accessToken in
        guard let accessToken = accessToken.element else {
          return
        }
        self?.userSession.didSignInAction.onNext(accessToken)
      }
      .disposed(by: disposeBag)
    
  }
  
}
