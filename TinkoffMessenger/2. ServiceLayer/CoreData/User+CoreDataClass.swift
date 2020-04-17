//
//  User+CoreDataClass.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 04.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
  convenience init(avatar: Data, name: String, description: String) {
    self.init(entity: CoreDataManager.instance.getEnity(for: "User"), insertInto: CoreDataManager.instance.managedObjectContext)
    
    self.name = name
    self.descr = description
    self.avatar = avatar
  }

}
