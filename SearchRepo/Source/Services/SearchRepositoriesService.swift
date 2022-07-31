//
//  SearchRepositoriesService.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation
import Alamofire
import RxSwift

enum SortRepositoryResponse: String {
  
  case byStars = "stars"
  case byName = "name"
  
}

final class SearchRepositoriesService {
  
  enum SearchRepositoriesRequest: URLRequestBuilder {
    
    case findRepositories(String, SortRepositoryResponse, Int, Int)
    
    var path: String {
      switch self {
      case .findRepositories(_, _, _, _):
        return "https://api.github.com/search/repositories"
      }
    }
    
    var headers: HTTPHeaders? {
      switch self {
      case .findRepositories(_, _, _, _):
        var headers = baseHeader
        headers.add(.accept("application/vnd.github+json"))
        // TODO: ??
        headers.add(.authorization("token \(String(describing: KeychainManager.shared.getAuthToken()))"))
        
        return headers
      }
    }
    
    var parameters: Parameters? {
      switch self {
      case .findRepositories(let searchPath, let sortRepositoryResponse, let chunkAmount, let page):
        return [
          "q": searchPath,
          "page": page,
          "per_page": chunkAmount,
          "sort": sortRepositoryResponse.rawValue
        ]
      }
    }
    
    var method: HTTPMethod {
      switch self {
      case .findRepositories:
        return .get
      }
    }
    
  }
  
  private let requestManager: RequestManager
  
  init(requestManager: RequestManager) {
    self.requestManager = requestManager
  }
  
  func findRepositories(searchPath path: String, sort: SortRepositoryResponse, chuckAmount: Int, page: Int) -> Observable<RepositoryReponse> {
    let service: SearchRepositoriesRequest = .findRepositories(path, sort, chuckAmount, page)
    
    return requestManager.perform(service: service, decodeType: RepositoryReponse.self)
  }
  
}
