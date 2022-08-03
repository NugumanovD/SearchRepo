//
//  SignInViewController.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
  
  var viewModel: SignInViewModel!
  
  private let disposeBag = DisposeBag()
  
  private lazy var logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "gitHubLogo")
    
    return imageView
  }()
  
  private lazy var signInButton: UIButton = {
    let button = UIButton()
    button.setTitle("Sign In via GitHub", for: .normal)
    
    button.layer.cornerRadius = 10
    button.backgroundColor = .black
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupBindings()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    title = "Sign In"
    setupLayoutLogoView()
    setupLayoutSignButton()
  }
  
  private func setupLayoutLogoView() {
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints {
      $0.height.width.equalTo(200.0)
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  private func setupLayoutSignButton() {
    view.addSubview(signInButton)
    signInButton.snp.makeConstraints {
      $0.leading.equalTo(logoImageView.snp.leading)
      $0.trailing.equalTo(logoImageView.snp.trailing)
      $0.height.equalTo(50.0)
      $0.top.equalTo(logoImageView.snp.bottom).offset(12.0)
    }
  }
  
  private func setupBindings() {
    signInButton.rx.tap.bind(to: viewModel.signInAction).disposed(by: disposeBag)
  }
  
}
