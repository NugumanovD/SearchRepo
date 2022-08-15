//
//  KeychainManager.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class KeychainManager {
  
  enum Keys {
    static let accessToken = "accessToken"
  }
  
  static let shared = KeychainManager()
  private init() {}
  
  func getAuthToken() -> String? {
    let token = load(key: Keys.accessToken)?.toString
    
    return token
  }
  
  func setAuthToken(value: String?) {
    if let newValue = value, let valueData = "token \(newValue)".data(using: .utf8) {
      save(key: Keys.accessToken, data: valueData)
    }
  }
  
  func removeAll() {
    deleteAllData()
  }
  
  func tokenValueObserver() -> Observable<String?> {
    return Observable.create { observe in
      observe.onNext(self.getAuthToken())
      observe.onCompleted()
      
      return Disposables.create()
    }
  }
  
}

// MARK: - Base keychain metods
private extension KeychainManager {
  
  @discardableResult
  func save(key: String, data: Data) -> OSStatus {
    let query = [
      kSecClass as String: kSecClassGenericPassword as String,
      kSecAttrAccount as String: key,
      kSecValueData as String: data ] as [String: Any]
    
    SecItemDelete(query as CFDictionary)
    
    return SecItemAdd(query as CFDictionary, nil)
  }
  
  func load(key: String) -> Data? {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue!,
      kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
    
    var dataTypeRef: AnyObject?
    
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == noErr {
      return dataTypeRef as? Data
    } else {
      return nil
    }
  }
  
  func deleteAllData() {
    let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
    for itemClass in secItemClasses {
      let spec: NSDictionary = [kSecClass: itemClass]
      SecItemDelete(spec)
    }
  }
  
}
