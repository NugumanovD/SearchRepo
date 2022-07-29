//
//  SignInViewModel.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel {
    
  var signInAction: PublishSubject<Void> {
    model.signInAction
  }
  
  let model: SignInModel
  
  init(model: SignInModel) {
    self.model = model
    
    
  }
  
}
