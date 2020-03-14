//
//  ConversationCellModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

struct ConversationCellModel {
  let name: String
  let message: String?
  let date: Date
  let isOnline: Bool
  let hasUnreadMessages: Bool
}
