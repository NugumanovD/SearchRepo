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

struct SearchRepositoriesAPIConfiguration {
  
  let searchPath: String
  let sortRepositoryResponse: SortRepositoryResponse
  let chunkAmount: Int
  let page: Int
  let accessToken: String?
  
}

protocol SearchRepositoriesServiceProvider {
  
  func findRepositories(searchPath path: String, sort: SortRepositoryResponse, chuckAmount: Int, page: Int) -> Observable<RepositoryReponse>
  
}

final class SearchRepositoriesService {
  
  enum SearchRepositoriesRequest: URLRequestBuilder {
    
    case findRepositories(SearchRepositoriesAPIConfiguration)
    
    var path: String {
      switch self {
      case .findRepositories:
        return "https://api.github.com/search/repositories"
      }
    }
    
    var headers: HTTPHeaders? {
      switch self {
      case let .findRepositories(configuration):
        var headers = baseHeader
        headers.add(.accept("application/vnd.github+json"))
        headers.add(.authorization(configuration.accessToken ?? ""))
        
        return headers
      }
    }
    
    var parameters: Parameters? {
      switch self {
      case let .findRepositories(configuration):
        return [
          "q": configuration.searchPath,
          "page": configuration.page,
          "per_page": configuration.chunkAmount,
          "sort": configuration.sortRepositoryResponse.rawValue
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
    let configuration = SearchRepositoriesAPIConfiguration(
      searchPath: path,
      sortRepositoryResponse: sort,
      chunkAmount: chuckAmount,
      page: page,
      accessToken: KeychainManager.shared.getAuthToken()
    )
    let service: SearchRepositoriesRequest = .findRepositories(configuration)
    
    return requestManager.perform(service: service, decodeType: RepositoryReponse.self)
  }
  
}

extension SearchRepositoriesService: SearchRepositoriesServiceProvider {}
