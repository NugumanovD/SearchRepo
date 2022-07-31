//
//  SignInService.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Alamofire
import Foundation
import RxSwift

let scheme = "com.nugumanov.SearchRepo"

final class SignInService {
  
  enum SignInConfigurationRequest: URLRequestBuilder {
    
    case getAuthPageUrl
    case getAuthorizationToken(String)
    
    var path: String {
      switch self {
      case .getAuthPageUrl:
        // TODO: Movie to string store
        return "https://github.com/login/oauth/authorize"
        
      case .getAuthorizationToken:
        // TODO: Movie to string store
        return "https://github.com/login/oauth/access_token"
      }
    }
    
    var headers: HTTPHeaders? {
      baseHeader
    }
    
    var parameters: Parameters? {
      switch self {
      case .getAuthPageUrl:
        return [
          // TODO: Movie to string store
          "client_id": "652035a8fdca5f5bf68d",
          "redirect_uri": "\(scheme)://authentication",
          "state": "state",
          "scope": ["repo", "user"].joined(separator: " ")
        ]
        
      case let .getAuthorizationToken(code):
        return [
          // TODO: Movie to string store
          "client_id": "652035a8fdca5f5bf68d",
          "client_secret": "63f1120f662985267684926fe96a253071b9c5e7",
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
