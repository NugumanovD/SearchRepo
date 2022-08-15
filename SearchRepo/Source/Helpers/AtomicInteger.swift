//
//  AtomicInteger.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 01.08.2022.
//

import Foundation

final class AtomicInteger {
  
  private let lock = DispatchSemaphore(value: 1)
  private var _value: Int
  
  init(value initialValue: Int = 0) {
    _value = initialValue
  }
  
  var value: Int {
    get {
      lock.wait()
      defer { lock.signal() }
      return _value
    }
    set {
      lock.wait()
      defer { lock.signal() }
      _value = newValue
    }
  }
  
  func decrementAndGet() -> Int {
    lock.wait()
    defer { lock.signal() }
    _value -= 1
    return _value
  }
  
  func incrementAndGet() -> Int {
    lock.wait()
    defer { lock.signal() }
    _value += 1
    return _value
  }
}
