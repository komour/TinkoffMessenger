//
//  User.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

struct User {
  let avatar: Data
  let name: String
  let description: String
  
  init(avatar: Data, name: String, description: String) {
    self.avatar = avatar
    self.name = name
    self.description = description
  }
}
