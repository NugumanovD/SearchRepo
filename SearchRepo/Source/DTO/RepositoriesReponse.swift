//
//  RepositoriesReponse.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation
import CoreData

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
class Repository: Codable {
  let id: Int
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


extension Repository {
  
  func toRepositoryConfiguration(with context: NSManagedObjectContext) -> RepositoryConfiguration {
    RepositoryConfiguration(
      id: id,
      title: fullName,
      stargazersCount: stargazersCount,
      language: language,
      pageURLString: owner?.htmlURL ?? "https://github.com",
      avatarURLString: owner?.avatarURL,
      viewed: isViewed(with: context)
    )
  }
  
  func isViewed(with context: NSManagedObjectContext) -> Bool {
    let request = createFetchRequest(for: id)
    
    let viewed = try? context.fetch(request).first
    
    return viewed?.viewed ?? false
  }
  
  @discardableResult
  func convertToViewedEntity(with context: NSManagedObjectContext) -> RepositoryEntity {
    let entity = find(id: id, with: context) ?? RepositoryEntity(context: context)
    entity.id = Int64(id)
    entity.viewed = true
    
    return entity
  }
  
  func find(id: Int, with context: NSManagedObjectContext) -> RepositoryEntity? {
    let request = createFetchRequest(for: id)
    
    return try? context.fetch(request).first
  }
  
  
  private func createFetchRequest(for id: Int) -> NSFetchRequest<RepositoryEntity> {
    let request: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id = %i", Int64(id))
    request.returnsObjectsAsFaults = false
    
    return request
  }
  
}
