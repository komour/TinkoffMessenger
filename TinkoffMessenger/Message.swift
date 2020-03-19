//
//  Message.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

struct Message {
  let content: String
  let created: Date
  let senderId: String
  let senderName: String
  
  var toDict: [String: Any] {
    return ["content": content,
            "created": Timestamp(date: created),
            "senderID": senderId,
            "senderName": senderName]
  }
}
