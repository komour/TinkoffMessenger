//
//  SortChannelTests.swift
//  TinkoffMessengerTests
//
//  Created by Always Strive And Prosper on 30.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import XCTest
@testable import TinkoffMessenger

class SortChannelsTests: XCTestCase {
  
  let channelsSorter: IChannelsSorter = ChannelsSorter()
  
  func testSortByDate() {
    let someDate = Date()
    let ch1 = ConversationCellStruct(name: "", message: "", date: someDate, isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch2 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(-100), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch3 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(100), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch4 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(99), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch5 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(-1), isOnline: false, hasUnreadMessages: true, identifier: "")
    
    let expectedResult = [ch3, ch4, ch1, ch5, ch2]
    let unsorted = [ch1, ch2, ch3, ch4, ch5]
    let result = channelsSorter.sort(unsorted)
    
    XCTAssertEqual(result, expectedResult)
  }
  
  func testSortByOnline() {
    let someDate = Date()
    let ch1 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(777), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch2 = ConversationCellStruct(name: "", message: "", date: someDate, isOnline: true, hasUnreadMessages: true, identifier: "")
    
    let expectedResult = [ch2, ch1]
    let unsorted = [ch1, ch2]
    
    let result = channelsSorter.sort(unsorted)
    
    XCTAssertEqual(result, expectedResult)
  }
  
  func testSortByDateAndOnline() {
    let someDate = Date()
    let ch1 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(777), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch2 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(1), isOnline: true, hasUnreadMessages: true, identifier: "")
    let ch3 = ConversationCellStruct(name: "", message: "", date: someDate, isOnline: true, hasUnreadMessages: true, identifier: "")
    let ch4 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(-1), isOnline: false, hasUnreadMessages: true, identifier: "")
    let ch5 = ConversationCellStruct(name: "", message: "", date: someDate.addingTimeInterval(2), isOnline: true, hasUnreadMessages: true, identifier: "")
    
    let expectedResult = [ch5, ch2, ch3, ch1, ch4]
    let unsorted = [ch1, ch2, ch3, ch4, ch5]
    
    let result = channelsSorter.sort(unsorted)
    
    XCTAssertEqual(result, expectedResult)
  }
  
}
