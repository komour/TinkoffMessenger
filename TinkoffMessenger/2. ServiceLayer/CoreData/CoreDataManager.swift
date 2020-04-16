//  CoreDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 30.03.2020.
//  Copyright © 2020 komarov. All rights reserved.

import UIKit
import CoreData

class CoreDataManager: CoreDataManagerProtocol {
  
  private init() {}
  
  static let instance = CoreDataManager()
  
  func createEntity() {
    if let image = UIImage(named: "defaultAvatar") {
      if let data = image.pngData() {
        _ = User(avatar: data, name: "User name", description: "User description")
        saveContext()
        return
      }
    }
    fatalError("nil default image")
  }
  
  func getEnity(for name: String) -> NSEntityDescription {
    guard let entyty = NSEntityDescription.entity(forEntityName: name, in: self.managedObjectContext) else {
      fatalError("nil entityDescription in \(#function)")
    }
    return entyty
  }
  
  func saveChanges(user: User) {
    if let managedObject = getUser() {
      managedObject.setValue(user.name, forKey: "name")
      managedObject.setValue(user.descr, forKey: "descr")
      managedObject.setValue(user.avatar, forKey: "avatar")
      saveContext()
    } else {
      print("nil last result in \(#function)")
    }
  }
  
  func getUser() -> User? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    do {
      guard let results = try self.managedObjectContext.fetch(fetchRequest) as? [User],
      let lastResult = results.last else {
          return nil
      }
      return lastResult
    } catch {
      print(error)
      return nil
    }
  }
  
  lazy var getDocumentsDirectory: NSURL = {
    guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("nil documents directory in \(#function)")
    }
    return directory as NSURL
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: "TinkoffMessenger", withExtension: "momd") else {
      fatalError("nil modelURL in \(#function)")
    }
    guard let momd = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("nil momd in \(#function)")
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
