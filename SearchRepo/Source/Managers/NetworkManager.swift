//
//  NetworkManager.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Alamofire
import RxSwift
import Foundation

protocol URLRequestBuilder: URLRequestConvertible {
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension URLRequestBuilder {
  
  var baseHeader: HTTPHeaders {
    var headers = HTTPHeaders.init()
    headers.add(.accept("application/json"))
    return headers
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try path.asURL()
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.headers = baseHeader
    
    switch method {
    case .get:
      request = try URLEncoding.default.encode(request, with: parameters)
    case.post:
      request = try URLEncoding.default.encode(request, with: parameters)
    default:
      break
    }
    return request
  }
}

protocol RequestManager {
  
  func perform<T: URLRequestBuilder, U: Decodable>(service: T, decodeType: U.Type) -> Observable<U>
  
}

extension RequestManager {
  
  func perform<T: URLRequestBuilder, U: Decodable>(service: T, decodeType: U.Type) -> Observable<U> {
    perform(service: service, decodeType: decodeType)
  }
  
}
