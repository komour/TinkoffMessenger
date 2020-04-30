//
//  IChannelsSorter.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 30.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

protocol IChannelsSorter {
  func sort(_ channels: [ConversationCellStruct]) -> [ConversationCellStruct]
}
