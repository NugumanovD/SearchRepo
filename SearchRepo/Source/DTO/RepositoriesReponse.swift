//
//  RepositoriesReponse.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation

struct RepositoryReponse: Codable {
  let totalCount: Int?
  let incompleteResults: Bool?
  let repositories: [Repository]?
  
  enum CodingKeys: String, CodingKey {
    
    case totalCount = "total_count"
    case incompleteResults = "incomplete_results"
    case repositories = "items"
    
  }
}

// MARK: - RepositoryElement
struct Repository: Codable {
  let id: Int?
  let fullName: String?
  let stargazersCount: Int?
  let owner: Owner?
  let language: String?
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case fullName = "full_name"
    case stargazersCount = "stargazers_count"
    case owner
    case language = "language"
    
  }
}

extension Repository {
  
  func convertToRepositoryConfiguration() -> RepositoryConfiguration {
    .init(
      id: id,
      title: fullName,
      stargazersCount: stargazersCount,
      language: language,
      pageURL: owner?.htmlURL ?? "https://github.com",
      avatarURLString: owner?.avatarURL
    )
  }
  
}


// MARK: - OwnerClass
struct Owner: Codable {
  let id: Int?
  let avatarURL: String?
  let htmlURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case avatarURL = "avatar_url"
    case htmlURL = "html_url"
  }
}
