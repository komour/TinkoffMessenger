//
//  Channel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 20.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

struct Channel {
  let identifier: String
  let name: String
  let lastMessage: String
  
  var toDict: [String: Any] {
    return ["name": name]
  }
}
