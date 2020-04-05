//
//  ConversationViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
  
  //  unique ID
  let myId = UIDevice.current.identifierForVendor?.uuidString ?? "123"
  
  @IBOutlet weak var newMessageTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  private let firebaseService: FirebaseProtocol = FirebaseService()
  private var messages = [MessageCellModel]()
  private let toolbarHeight: CGFloat = 25
  
  var channel: Channel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil),
                       forCellReuseIdentifier: String(describing: MessageCell.self))
    tableView.dataSource = self
    
    tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
    tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)
    
    addKeyboardNotifications()
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
    
    guard let channelIdentifier = channel?.identifier else { return }
    let reference = firebaseService.messagesReference(channelIdentifier: channelIdentifier)
    reference.addSnapshotListener { [weak self] (querySnapshot, err) in
      guard let self = self else { return }
      self.messages.removeAll()
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        guard let querySnapshot = querySnapshot else { return }
        for document in querySnapshot.documents {
          let name = document.data()["senderName"] as? String ?? "nil senderName"
          let content = document.data()["content"] as? String ?? "nil content"
          let senderID = document.data()["senderID"] as? String ?? "nil senderID"
          let created = self.firebaseService.getDateFromTimestamp(receivedTimestamp: document.data()["created"])
          let isIncoming = senderID != self.myId
          self.messages.append(MessageCellModel(text: content, isIncoming: isIncoming, date: created, sender: name))
          
        }
      }
      self.messages.sort(by: {(a0: MessageCellModel, a1: MessageCellModel) -> Bool in
        return a0.date > a1.date
      })
      self.tableView.reloadData()
    }
  }
  
  deinit {
    removeKeyboardNotifications()
  }
  
  private func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    guard let keyboardFrame: NSValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      print("something went wrong in \(#function)")
      return
    }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
  }
  
  @objc private func keyboardWillHide() {
    self.scrollView.contentOffset = CGPoint.zero
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
  
  @IBAction func sendAction() {
    if let newMessage = newMessageTextField.text {
      if newMessage == "" { return }
      let createdDate = Date()
      let senderName = CoreDataManager.instance.getUser()?.name ?? "admin"
      guard let channelIdentifier = channel?.identifier else { return }
      let reference = firebaseService.messagesReference(channelIdentifier: channelIdentifier)
      reference.addDocument(data: Message(content: newMessage,
                                          created: createdDate,
                                          senderId: myId,
                                          senderName: senderName).toDict)
      newMessageTextField.text = ""
    }
  }
  
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if messages.isEmpty {
      return 0
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageCell.self), for: indexPath) as? MessageCell else {
      return UITableViewCell()
    }
    cell.configure(with: messages[indexPath.row])
    cell.selectionStyle = .none
    cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    return cell
  }

}
