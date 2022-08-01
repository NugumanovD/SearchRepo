//
//  SignInCoordinator.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import RxSwift
import UIKit

protocol SignInCoordinatorProvider {
  
  func openURL(url: URL)
  
}

class SignInCoordinator: BaseCoordinator {
    
  private let userSession: UserSessionService
  private let deeplinkHandler: DeepLinkHandler
  private let disposeBag = DisposeBag()
  
  init(userSession: UserSessionService, deeplinkHandler: DeepLinkHandler) {
    self.userSession = userSession
    self.deeplinkHandler = deeplinkHandler
  }
  
  override func start() {
    let apiManager = APIManager.shared
    let signInService = SignInService(requestManager: apiManager)
    let model = SignInModel(
      signInService: signInService,
      coordinator: self,
      userSesion: userSession,
      deepLinkHandler: deeplinkHandler
    )
    let viewModel = SignInViewModel(model: model)
    let viewContoller = SignInViewController()
    viewContoller.viewModel = viewModel
    
    navigationController.viewControllers = [viewContoller]
  }
  
}

extension SignInCoordinator: SignInCoordinatorProvider {
  
  func openURL(url: URL) {
    UIApplication.shared.open(url)
  }
  
}
