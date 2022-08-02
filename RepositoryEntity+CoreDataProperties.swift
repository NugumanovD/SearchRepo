//
//  RepositoryEntity+CoreDataProperties.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 02.08.2022.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var id: Int64
    @NSManaged public var language: String?
    @NSManaged public var stargazersCount: Int64
    @NSManaged public var viewed: Bool
    @NSManaged public var ownerEntity: OwnerEntity?
  
  func convertToRepository() -> Repository {
    Repository(
      id: Int(id),
      fullName: fullName,
      stargazersCount: Int(stargazersCount),
      owner: ownerEntity?.convertToOwner(),
      language: language
    )
  }

}

extension RepositoryEntity : Identifiable {

}
