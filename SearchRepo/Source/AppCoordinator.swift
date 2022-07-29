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
  
  override func start() {
    navigationController.navigationBar.isHidden = true
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    showRepositories()
  }
  
}

private extension AppCoordinator {
  
  func showSignInFlow() {
    let coordinator = SignInCoordinator()
    coordinator.navigationController = navigationController
    start(coordinator: coordinator)
  }
  
  func showRepositories() {
    let coordinator = TabBarCoordinator()
    coordinator.navigationController = navigationController
    start(coordinator: coordinator)
  }
}
