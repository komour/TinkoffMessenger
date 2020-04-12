//
//  User+CoreDataProperties.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 04.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//
//

import Foundation
import CoreData

extension User {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }
  
  @NSManaged public var avatar: Data?
  @NSManaged public var descr: String?
  @NSManaged public var name: String?  
}
