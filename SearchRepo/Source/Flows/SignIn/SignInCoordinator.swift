//
//  SignInCoordinator.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import RxSwift

class SignInCoordinator: BaseCoordinator {
    
  private let disposeBag = DisposeBag()
  
  override func start() {
    let model = SignInModel()
    let viewModel = SignInViewModel(model: model)
    let viewContoller = SignInViewController()
    viewContoller.viewModel = viewModel
    
    navigationController.viewControllers = [viewContoller]
  }
  
}
