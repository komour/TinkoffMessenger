//
//  CreateChannelModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class CreateChannelModel {
  
  let viewController: CreateChannelViewController?
  
  private let firebaseService: FirebaseProtocol = FirebaseService()
  
  init (for viewController: CreateChannelViewController) {
    self.viewController = viewController
  }
  
  func doneAction() {
    guard let vc = self.viewController else { return }
    if vc.newChannelName.text == nil || vc.newChannelName.text == "" {
      let alert = UIAlertController(title: "WARNING", message: "Can't create channel with empty name.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
      }))
      vc.present(alert, animated: true, completion: nil)
    } else {
      guard let name = vc.newChannelName.text else {
        vc.dismiss(animated: true, completion: nil)
        return
      }
      let reference = firebaseService.channelsReference()
      reference.addDocument(data: Channel(identifier: "123", name: name, lastMessage: "nothing", lastActivity: Date()).toDict)
      vc.dismiss(animated: true, completion: nil)
    }
  }
  
}
