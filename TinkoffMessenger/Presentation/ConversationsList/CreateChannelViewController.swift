//
//  CreateChannelViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 20.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class CreateChannelViewController: UIViewController {  
  @IBOutlet weak var newChannelName: UITextField!
  
  private let firebaseService: FirebaseProtocol = FirebaseService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
  }
  
  @IBAction func doneAction() {
    endEditing()
    if newChannelName.text == nil || newChannelName.text == "" {
      let alert = UIAlertController(title: "WARNING", message: "Can't create channel with empty name.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        alert.dismiss(animated: true, completion: nil)
      }))
      self.present(alert, animated: true, completion: nil)
    } else {
      guard let name = newChannelName.text else {
        self.dismiss(animated: true, completion: nil)
        return
      }
      let reference = firebaseService.channelsReference()
      reference.addDocument(data: Channel(identifier: "123", name: name, lastMessage: "nothing").toDict)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
}
