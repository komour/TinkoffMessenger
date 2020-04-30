//
//  ConversationCellModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

public struct ConversationCellStruct: Equatable {
  let name: String
  let message: String?
  let date: Date
  let isOnline: Bool
  let hasUnreadMessages: Bool
  let identifier: String
}

class ConversationCellModel {
  
  let viewController: ConversationCell?
  
  init(for viewController: ConversationCell) {
    self.viewController = viewController
  }
  
  func configure(with curStruct: ConversationCellStruct) {
    guard let vc = viewController else { return }
    let dateFormatter = DateFormatter()
    if curStruct.date.isToday() {
      dateFormatter.dateFormat = "HH:mm"
    } else {
      dateFormatter.dateFormat = "dd MMM"
    }
    
    vc.nameLabel.text = curStruct.name
    vc.dateLabel.text = dateFormatter.string(from: curStruct.date)
    if let lastMessage = curStruct.message {
      if lastMessage == "No messages yet" {
        vc.messageLabel.font = vc.messageLabel.font.italic
      } else {
        vc.messageLabel.font = vc.messageLabel.font.without(.traitItalic)
      }
      vc.messageLabel.text = lastMessage
      if curStruct.hasUnreadMessages {
        vc.messageLabel.font = vc.messageLabel.font.with(.traitBold)
      } else {
        vc.messageLabel.font = vc.messageLabel.font.without(.traitBold)
      }
    } else {
      vc.messageLabel.text = "No messages yet"
      vc.messageLabel.font = vc.messageLabel.font.italic
      vc.messageLabel.font = vc.messageLabel.font.without(.traitBold)
    }
    
    if curStruct.isOnline {
      vc.backgroundColor = UIColor(named: "cream")
    } else {
      vc.backgroundColor = UIColor.white
    }
  }
}
