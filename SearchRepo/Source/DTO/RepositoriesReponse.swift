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
struct Repository: Codable {
  let id: Int
  let fullName: String?
  let stargazersCount: Int
  let owner: Owner?
  let language: String?
  var isViewed = false
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case fullName = "full_name"
    case stargazersCount = "stargazers_count"
    case owner
    case language = "language"
    
  }
}

extension Repository: Hashable {
  
  static func == (lhs: Repository, rhs: Repository) -> Bool {
    lhs.id == rhs.id
  }
  
}

// MARK: - OwnerClass
struct Owner: Codable {
  let id: Int
  let avatarURL: String
  let htmlURL: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case avatarURL = "avatar_url"
    case htmlURL = "html_url"
  }
}

extension Owner: Hashable {
  
  static func == (lhs: Owner, rhs: Owner) -> Bool {
    lhs.id == rhs.id
  }
  
}

extension Owner {
  
  func toOwnerEntity(with context: NSManagedObjectContext) -> OwnerEntity {
    let entity = find(id: id, with: context) ?? OwnerEntity(context: context)
    entity.id = Int64(id)
    entity.avatarURL = avatarURL
    entity.htmlURL = htmlURL
    
    return entity
  }
  
  func find(id: Int, with context: NSManagedObjectContext) -> OwnerEntity? {
    let request = createFetchRequest(for: id)
    
    return try? context.fetch(request).first
  }
  
  private func createFetchRequest(for id: Int) -> NSFetchRequest<OwnerEntity> {
    let request: NSFetchRequest<OwnerEntity> = OwnerEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id = %i", Int64(id))
    request.returnsObjectsAsFaults = false
    
    return request
  }
}

extension Repository {
  
  func toRepositoryConfiguration() -> RepositoryConfiguration {
    RepositoryConfiguration(
      id: id,
      title: fullName,
      stargazersCount: stargazersCount,
      language: language,
      pageURLString: owner?.htmlURL ?? "https://github.com",
      avatarURLString: owner?.avatarURL,
      viewed: isViewed
    )
  }
  
  @discardableResult
  func convertToRepositoryEntity(with context: NSManagedObjectContext) -> RepositoryEntity {
    let entity = find(id: id, with: context) ?? RepositoryEntity(context: context)
    entity.id = Int64(id)
    entity.viewed = true
    entity.fullName = fullName
    entity.language = language
    entity.stargazersCount = Int64(stargazersCount)
    entity.ownerEntity = owner?.toOwnerEntity(with: context)
    
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
