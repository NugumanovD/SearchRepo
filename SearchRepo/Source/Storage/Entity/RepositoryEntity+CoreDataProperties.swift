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

    @NSManaged public var id: Int64
    @NSManaged public var viewed: Bool

}

extension RepositoryEntity : Identifiable {

}
