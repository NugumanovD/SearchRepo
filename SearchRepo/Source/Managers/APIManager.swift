//
//  APIManager.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import Alamofire
import RxSwift

enum ResponseError: Error {
    case serverNotResponding
    case noInternetConnection
    case accessDenied
    case custom(String?, [String]?)
}

final class APIManager: RequestManager {
  
  private var session: Session
  private var avalibelStatusCodes = [200, 201, 422]
  private var refreshTokenManager = RefreshTokenManager()
  
  init() {
    let rootQueue = DispatchQueue(label: "apiManagerQueue")
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 2
    queue.underlyingQueue = rootQueue
    let delegate = SessionDelegate()
    let configuration = URLSessionConfiguration.af.default
    let urlSession = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    session = Session(session: urlSession, delegate: delegate, rootQueue: rootQueue)
  }
  
  func perform<T: URLRequestBuilder, U: Decodable>(service: T, decodeType: U.Type) -> Observable<U> {
    
    return Observable.create { observer -> Disposable in
      self.session.request(service)
        .validate(statusCode: self.avalibelStatusCodes)
        .responseDecodable(of: U.self) { [weak self] response in
          switch response.result {
            
          case .success(let result):
            observer.onNext(result)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(self!.errorHandling(error: error))
          }
        }
      
      return Disposables.create {
        self.session.cancelAllRequests()
      }
    }
  }
  
  func errorHandling(error: AFError) -> ResponseError {
      if error.responseCode == 401 {
          return .accessDenied
      }
      return .serverNotResponding
  }
  
}

class RefreshTokenManager: RequestInterceptor {}
