//
//  CoreDataManagerProtocol.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
  func createEntity()
  
  func saveChanges(user: User)
  func getUser() -> User?
  
  var getDocumentsDirectory: NSURL { get }
  var managedObjectModel: NSManagedObjectModel { get }
  var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
  var managedObjectContext: NSManagedObjectContext { get }
  var persistentContainer: NSPersistentContainer { get }
  
  func saveContext ()
}
