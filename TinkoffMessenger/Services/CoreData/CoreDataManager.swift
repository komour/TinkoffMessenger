//  CoreDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 30.03.2020.
//  Copyright © 2020 komarov. All rights reserved.

import UIKit
import CoreData

class CoreDataManager: CoreDataManagerProtocol {
  
  static let instance = CoreDataManager()
  
  func createEntity() {
    guard let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: self.managedObjectContext) else {
      print("nil entityDescription in \(#function)")
      fatalError()
    }
    let managedObject = NSManagedObject(entity: entityDescription, insertInto: self.managedObjectContext)
    if let image = UIImage(named: "defaultAvatar") {
      if let data = image.pngData() {
        managedObject.setValue(data, forKey: "avatar")
      }
    }
    saveContext()
  }
  
  func saveChanges(user: User) {
    if let managedObject = fetchLastResult() {
      managedObject.setValue(user.name, forKey: "name")
      managedObject.setValue(user.description, forKey: "descr")
      managedObject.setValue(user.avatar, forKey: "avatar")
      saveContext()
    } else {
      print("nil last result in \(#function)")
    }
  }
  
  func getUser() -> User? {
    var user: User?
    if let result = fetchLastResult() {
      guard let name = result.value(forKey: "name") as? String,
        let description = result.value(forKey: "descr") as? String,
        let avatar = result.value(forKey: "avatar") as? Data
        else {
          print(#function)
          fatalError()
      }
      user = User(avatar: avatar, name: name, description: description)
    } else {
      print("nil last result in \(#function)")
      user = nil
    }
    return user
  }
  
  func fetchLastResult() -> NSManagedObject? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
          guard let results = try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else {
            print(#function)
            fatalError()
          }
          return results[results.count - 1]
        } catch {
          print(error)
          return nil
        }
  }
  
  lazy var getDocumentsDirectory: NSURL = {
    guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("nil documents directory in \(#function)")
      fatalError()
    }
    return directory as NSURL
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: "TinkoffMessenger", withExtension: "momd") else {
      print("nil modelURL in \(#function)")
      fatalError()
    }
    guard let momd = NSManagedObjectModel(contentsOf: modelURL) else {
      print("nil momd in \(#function)")
      fatalError()
    }
    return momd
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.getDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "ru.ifmo.rain.komarov", code: 1337, userInfo: dict)
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TinkoffChat")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
}
