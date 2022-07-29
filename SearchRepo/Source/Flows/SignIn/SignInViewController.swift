//
//  SignInViewController.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import UIKit
import SnapKit
import RxSwift

final class SignInViewController: UIViewController {
  
  var viewModel: SignInViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    title = "Sign In"
  }
  
}
