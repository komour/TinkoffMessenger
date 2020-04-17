//
//  ConversationModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationModel {
  
  let viewController: ConversationViewController?
  
  init(for viewController: ConversationViewController) {
    self.viewController = viewController
  }
  
  let uniqueId = UIDevice.current.identifierForVendor?.uuidString ?? "123"
  
  private let firebaseService: FirebaseProtocol = FirebaseService()

  @objc func endEditing() {
    guard let vc = viewController else { return }
    vc.view.endEditing(true)
  }
  
  func addEndEditingGesture() {
    guard let vc = viewController else { return }
    let tapEndEditing = UITapGestureRecognizer(target: vc, action: #selector(endEditing))
    vc.view.addGestureRecognizer(tapEndEditing)
  }
  
  func addSnapshotListner() {
    guard let vc = viewController else { return }
    
    guard let channelIdentifier = vc.channel?.identifier else { return }
    let reference = firebaseService.messagesReference(channelIdentifier: channelIdentifier)
    reference.addSnapshotListener { [weak self] (querySnapshot, err) in
      guard let self = self else { return }
      vc.messages.removeAll()
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        guard let querySnapshot = querySnapshot else { return }
        for document in querySnapshot.documents {
          let name = document.data()["senderName"] as? String ?? "nil senderName"
          let content = document.data()["content"] as? String ?? "nil content"
          let senderID = document.data()["senderID"] as? String ?? "nil senderID"
          let created = self.firebaseService.getDateFromTimestamp(receivedTimestamp: document.data()["created"])
          let isIncoming = senderID != self.uniqueId
          vc.messages.append(MessageCellStruct(text: content, isIncoming: isIncoming, date: created, sender: name))
        }
      }
      vc.messages.sort(by: {(a0: MessageCellStruct, a1: MessageCellStruct) -> Bool in
        return a0.date > a1.date
      })
      vc.tableView.reloadData()
    }
  }
  
  func sendAction() {
    guard let vc = viewController else { return }
    if let newMessage = vc.newMessageTextField.text {
      if newMessage == "" { return }
      let createdDate = Date()
      let senderName = CoreDataManager.instance.getUser()?.name ?? "admin"
      guard let channelIdentifier = vc.channel?.identifier else { return }
      let reference = firebaseService.messagesReference(channelIdentifier: channelIdentifier)
      reference.addDocument(data: Message(content: newMessage,
                                          created: createdDate,
                                          senderId: uniqueId,
                                          senderName: senderName).toDict)
      vc.newMessageTextField.text = ""
    }
  }
  
}
