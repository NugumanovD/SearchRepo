//
//  DeepLinkHandler.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation
import RxSwift

final class DeepLinkHandler {
  
  var authorizationCode = PublishSubject<String>()
  
  private let disposeBad = DisposeBag()
  
  func handle(_ url: URL) {
    guard
      let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
      let params = components.queryItems else {
      
      return
    }

    if let code = params.first(where: { $0.name == "code"})?.value {
      authorizationCode.onNext(code)
    }
  }
  
}
