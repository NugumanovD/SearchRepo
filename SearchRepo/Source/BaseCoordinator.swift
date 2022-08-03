//
//  BaseCoordinator.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import UIKit

protocol Coordinator: AnyObject {
  
  var navigationController: UINavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  
  func start()
  func start(coordinator: Coordinator)
  func didFinish(coordinator: Coordinator)
  
}

class BaseCoordinator: Coordinator {
  
  var childCoordinators: [Coordinator] = []
  var parentCoordinator: Coordinator?
  var navigationController = UINavigationController()
  
  func start() {
    fatalError("Start method must be implemented")
  }
  
  func start(coordinator: Coordinator) {
    childCoordinators += [coordinator]
    coordinator.parentCoordinator = self
    coordinator.start()
  }
  
  func didFinish(coordinator: Coordinator) {
    if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }
  
}
