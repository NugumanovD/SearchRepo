//
//  CoreDataManager.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 01.08.2022.
//

import Foundation
import CoreData

final class CoreDataManager {
  
  private let modelName: String
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Unable to Find Data Model")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to Load Data Model")
    }
    
    return managedObjectModel
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    return persistentStoreCoordinator
  }()
  
  private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    return managedObjectContext
  }()
  
  public init(modelName: String) {
    self.modelName = modelName
    
    setupCoreDataStack()
  }
  
  func saveChanges() {
    mainManagedObjectContext.performAndWait {
      do {
        if self.mainManagedObjectContext.hasChanges {
          try self.mainManagedObjectContext.save()
        }
      } catch {
        print("Unable to Save Changes of Main Managed Object Context")
        print("\(error), \(error.localizedDescription)")
      }
    }
  }

  func find(id: Int) throws -> RepositoryEntity? {
    let request: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id = %i", Int64(id))
    request.returnsObjectsAsFaults = false
    
    return try mainManagedObjectContext.fetch(request).first
  }
  
  private func setupCoreDataStack() {
    guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
      fatalError("Unable to Set Up Core Data Stack")
    }
    
    DispatchQueue.global().async {
      self.addPersistentStore(to: persistentStoreCoordinator)
    }
  }
  
  private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
    let fileManager = FileManager.default
    let storeName = "\(self.modelName).sqlite"
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
    
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption : true,
        NSInferMappingModelAutomaticallyOption : true
      ]
      
      try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: persistentStoreURL,
                                                        options: options)
    } catch {
      fatalError("Unable to Add Persistent Store")
    }
  }
}

