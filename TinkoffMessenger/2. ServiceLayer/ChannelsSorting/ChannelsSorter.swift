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
    
//    would be enough if every channel always had actual date (regardless of whether it had messages inside)
//    also enough for testing
//    if a0.isOnline == a1.isOnline {
//      return a0.date > a1.date
//    } else {
//      return a0.isOnline
//    }
    
    if a0.isOnline == a1.isOnline {
      if a0.message != nil {
        if a1.message != nil {
          return a0.date > a1.date
        } else {
          return true
        }
      } else {
        if a1.message != nil {
          return false
        } else {
          return a0.date == a1.date ? a0.name < a1.name : a0.date > a1.date //just `a0.date > a1.date` in ideal world
        }
      }
    } else {
      return a0.isOnline
    }
  }
}
