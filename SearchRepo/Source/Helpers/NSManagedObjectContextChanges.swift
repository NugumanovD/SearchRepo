//
//  NSManagedObjectContextChanges.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 03.08.2022.
//

import CoreData

extension NotificationCenter {
  
  func addObserver<T: NotificationRepresentable>(for representableType: T.Type, object obj: Any?, queue: OperationQueue?, using block: @escaping (T) -> Swift.Void) -> NSObjectProtocol {
    return addObserver(forName: T.name, object: obj, queue: queue) { (notification) in
      
      let notificationRepresenter = T(notification: notification)
      block(notificationRepresenter)
    }
  }
}

protocol NotificationRepresentable {
  
  static var name: Notification.Name { get }
  
  init(notification: Notification)
}

final class NSManagedObjectContextChanges: NotificationRepresentable {
  static let name = Notification.Name.NSManagedObjectContextObjectsDidChange
  
  let managedObjectContext: NSManagedObjectContext
  let insertedObjects: Set<NSManagedObject>
  let updatedObjects: Set<NSManagedObject>
  let refreshedObjects: Set<NSManagedObject>
  let deletedObjects: Set<NSManagedObject>
  
  init(notification: Notification) {
    managedObjectContext = notification.object as! NSManagedObjectContext
    
    insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
    updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
    refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject> ?? []
    deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []
  }
}
