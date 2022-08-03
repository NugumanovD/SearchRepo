//
//  SignInService.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Alamofire
import Foundation
import RxSwift

enum SignInServiceConstants {
  
  static let getAuthPageUrl = "https://github.com/login/oauth/authorize"
  static let signInURL = "https://github.com/login/oauth/access_token"
  static let scheme = "com.nugumanov.SearchRepo"
  static let clientID = {YOUR CLIENT_ID}
  static let clientSecret = {YOUR CLIENT_SECRET}
  
}

let scheme = SignInServiceConstants.scheme

final class SignInService {
  
  enum SignInConfigurationRequest: URLRequestBuilder {
    
    case getAuthPageUrl
    case getAuthorizationToken(String)
    
    var path: String {
      switch self {
      case .getAuthPageUrl:
        return SignInServiceConstants.getAuthPageUrl
        
      case .getAuthorizationToken:
        return SignInServiceConstants.signInURL
      }
    }
    
    var headers: HTTPHeaders? {
      baseHeader
    }
    
    var parameters: Parameters? {
      switch self {
      case .getAuthPageUrl:
        return [
          "client_id": SignInServiceConstants.clientID,
          "redirect_uri": "\(scheme)://authentication",
          "state": "state",
          "scope": ["repo", "user"].joined(separator: " ")
        ]
        
      case let .getAuthorizationToken(code):
        return [
          "client_id": SignInServiceConstants.clientID,
          "client_secret": SignInServiceConstants.clientSecret,
          "code": code,
          "redirect_uri": "\(scheme)://authentication"
        ]
      }
    }
    
    var method: HTTPMethod {
      switch self {
      case .getAuthPageUrl:
        return .get
        
      case .getAuthorizationToken:
        return .post
      }
    }
    
  }

  private let requestManager: RequestManager
  
  init(requestManager: RequestManager) {
    self.requestManager = requestManager
  }
  
  func getAuthPageUrl() -> URL? {
    let service: SignInConfigurationRequest = .getAuthPageUrl
    do {
      let request = try? service.asURLRequest()
      
      return request?.url
    }
  }
  
  func getAuthorizationToken(by code: String) -> Observable<TokenResponse> {
    let service: SignInConfigurationRequest = .getAuthorizationToken(code)
    return requestManager.perform(service: service, decodeType: TokenResponse.self)
  }
  
}
