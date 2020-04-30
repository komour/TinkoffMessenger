//
//  ConversationsListModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationsListModel {
  
  let viewController: ConversationsListViewController?
  let channelsSorter: IChannelsSorter = ChannelsSorter()
  
  private let firebaseService: FirebaseProtocol = FirebaseService()
  
  init(for viewController: ConversationsListViewController) {
    self.viewController = viewController
  }
  
  func addSnapshotListner() {
    guard let vc = viewController else { return }
    let reference = firebaseService.channelsReference()
    reference.addSnapshotListener { [weak self] (querySnapshot, err) in
      guard let self = self else { return }
      var tempChannels = [ConversationCellStruct]()
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        let tenMinutesAgo = Date().addingTimeInterval(-10.0 * 60.0)
        guard let querySnapshot = querySnapshot else { return }
        for document in querySnapshot.documents {
          let name = document.data()["name"] as? String ?? "nil name"
          let lastMessage = document.data()["lastMessage"] as? String
          let channelActivityDate = self.firebaseService.getDateFromTimestamp(receivedTimestamp: document.data()["lastActivity"])
          if tenMinutesAgo <= channelActivityDate {
            tempChannels.append(ConversationCellStruct(name: name,
                                                            message: lastMessage,
                                                            date: channelActivityDate,
                                                            isOnline: true,
                                                            hasUnreadMessages: false,
                                                            identifier: document.documentID))
          } else {
            tempChannels.append(
              ConversationCellStruct(name: name,
                                     message: lastMessage,
                                     date: channelActivityDate,
                                     isOnline: false,
                                     hasUnreadMessages: false,
                                     identifier: document.documentID))
          }
          
        }
      }
      vc.channels = self.channelsSorter.sort(tempChannels)
      vc.tableView.reloadData()
    }
  }
  
  func deleteChat(withID: String) {
    let reference = firebaseService.channelsReference()
    _ = reference.document(withID).delete { err in
      if let err = err {
        print("Error removing document: \(err)")
      }
    }
  }
  
}
