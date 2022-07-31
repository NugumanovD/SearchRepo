//
//  AppCoordinator.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator {
  
  lazy var window = UIWindow(frame: UIScreen.main.bounds)
  /// An object of this class is created in the AppDelegate, uses implicit initialization of the AppCoordinator class
  var deepLinkHandler: DeepLinkHandler!
  
  private let userSession = UserSessionService()
  private let disposeBag = DisposeBag()
  
  override func start() {
    navigationController.navigationBar.isHidden = true
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    initializeBindings()
    
  }
  
  func initializeBindings() {
    
    userSession.state.asObserver().doOnNext { [weak self] state in
      print(state)
      guard let self = self else { return }

      switch state {
      case .authorize:
        self.showRepositories()

      case .nonAuthorize:
        self.showSignInFlow()
      }
    }.disposed(by: disposeBag)
  }
  
}

private extension AppCoordinator {
  
  func showSignInFlow() {
    let coordinator = SignInCoordinator(userSession: userSession, deeplinkHandler: deepLinkHandler)
    coordinator.navigationController = navigationController
    start(coordinator: coordinator)
  }
  
  func showRepositories() {
    let coordinator = TabBarCoordinator(userSession: userSession)
    coordinator.navigationController = navigationController
    start(coordinator: coordinator)
  }
  
}
