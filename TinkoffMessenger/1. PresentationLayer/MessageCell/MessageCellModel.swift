//
//  MessageCellModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

public struct MessageCellStruct {
  let text: String
  let isIncoming: Bool
  let date: Date
  let sender: String
}

class MessageCellModel {
  
  let viewController: MessageCell?
  
  init(for viewController: MessageCell) {
    self.viewController = viewController
  }
  
  func getDateFormatter(with curStruct: MessageCellStruct) -> DateFormatter {
    let dateFormatter = DateFormatter()
    if curStruct.date.isToday() {
      dateFormatter.dateFormat = "HH:mm"
    } else {
      dateFormatter.dateFormat = "dd MMM"
    }
    return dateFormatter
  }
  
  func adjustWithIncomingType(isIncoming: Bool) {
    guard let vc = viewController else { return }
    DispatchQueue.main.async {
      if isIncoming {
        vc.messageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.45)
        vc.trailingConstraint.isActive = false
        vc.leadingConstraint.isActive = true
      } else {
        vc.messageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.55)
        vc.leadingConstraint.isActive = false
        vc.trailingConstraint.isActive = true
      }
    }
  }
  
}
