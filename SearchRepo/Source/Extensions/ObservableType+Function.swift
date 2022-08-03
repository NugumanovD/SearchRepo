//
//  ObservableType+Function.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import RxSwift
import RxRelay

extension ObservableType {
  
  func doOnNext(_ onNext: ((Self.Element) -> Swift.Void)?) -> Disposable {
    return subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
  }
  
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
  
  func acceptThanAppend(_ element: Element.Element) {
    accept(value + [element])
  }
  
}
