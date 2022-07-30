//
//  ObservableType+Function.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import RxSwift

extension ObservableType {
  
  func doOnNext(_ onNext: ((Self.Element) -> Swift.Void)?) -> Disposable {
    return subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
  }
  
}
