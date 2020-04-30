//
//  ChannelsSorter.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 30.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

class ChannelsSorter: IChannelsSorter {
  func sort(_ channels: [ConversationCellStruct]) -> [ConversationCellStruct] {
    return channels.sorted(by: sortingClosure)
  }
  
  lazy var sortingClosure = { (a0: ConversationCellStruct, a1: ConversationCellStruct) -> Bool in
//    every channel always has actual date (regardless of whether it has messages inside or not)
    if a0.isOnline == a1.isOnline {
      return a0.date > a1.date
    } else {
      return a0.isOnline
    }
  }
}
