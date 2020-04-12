//
//  ConversationCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  func configure(with model: ConversationCellModel) {
    let dateFormatter = DateFormatter()
    if model.date.isToday() {
      dateFormatter.dateFormat = "HH:mm"
    } else {
      dateFormatter.dateFormat = "dd MMM"
    }
    
    nameLabel.text = model.name
    dateLabel.text = dateFormatter.string(from: model.date)
    if let lastMessage = model.message {
      if lastMessage == "No messages yet" {
        messageLabel.font = messageLabel.font.italic
      } else {
        messageLabel.font = messageLabel.font.without(.traitItalic)
      }
      messageLabel.text = lastMessage
      if model.hasUnreadMessages {
        messageLabel.font = messageLabel.font.with(.traitBold)
      } else {
        messageLabel.font = messageLabel.font.without(.traitBold)
      }
    } else {
      messageLabel.text = "No messages yet"
      messageLabel.font = messageLabel.font.italic
      messageLabel.font = messageLabel.font.without(.traitBold)
    }
    
    if model.isOnline {
      self.backgroundColor = UIColor(named: "cream")
    } else {
      self.backgroundColor = UIColor.white
    }
  }
}
