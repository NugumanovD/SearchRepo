//
//  OwnerEntity+CoreDataProperties.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 02.08.2022.
//
//

import Foundation
import CoreData


extension OwnerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OwnerEntity> {
        return NSFetchRequest<OwnerEntity>(entityName: "OwnerEntity")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var htmlURL: String?
    @NSManaged public var id: Int64
    @NSManaged public var repository: RepositoryEntity?
  
  func convertToOwner() -> Owner {
    Owner(
      id: Int(id),
      avatarURL: avatarURL ?? "",
      htmlURL: htmlURL ?? ""
    )
  }

}

extension OwnerEntity: Identifiable {

}
