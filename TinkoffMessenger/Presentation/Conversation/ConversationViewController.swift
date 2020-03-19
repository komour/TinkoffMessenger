//
//  ConversationViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
  
  @IBOutlet weak var newMessageTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  //random data
  static var messages: [MessageCellModel] = (0...Int.random(in: 10...100)).map { _ in
    MessageCellModel(text: randomString(length: Int.random(in: 10...300)), isIncoming: Bool.random())
  }
  //temporary crutch for mock data
  var hasMessages = false
  
  private let toolbarHeight: CGFloat = 25
  
  var channel: Channel?
  private lazy var db = Firestore.firestore()
  private lazy var reference: CollectionReference = {
    guard let channelIdentifier = channel?.identifier else { print("zulul"); fatalError() }
    return db.collection("channels").document(channelIdentifier).collection("messages")
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil),
                       forCellReuseIdentifier: String(describing: MessageCell.self))
    tableView.dataSource = self
    tableView.reloadData()
    if hasMessages {
      tableView.scrollToBottom()
    }
    
    addKeyboardNotifications()
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
    
    reference.addSnapshotListener { snapshot, _ in
      print(snapshot?.documents[0] ?? "kukak")
      
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
      ConversationViewController.messages.append(MessageCellModel(text: newMessage, isIncoming: false))
      tableView.reloadData()
      newMessageTextField.text = ""
      tableView.scrollToBottomAnimated()
    }
  }
  
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ConversationViewController.messages.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    //temporary crutch for chats with no messages
    if hasMessages {
      return 1
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageCell.self), for: indexPath) as? MessageCell else {
      return UITableViewCell()
    }
    cell.configure(with: ConversationViewController.messages[indexPath.row])
    cell.selectionStyle = .none
    return cell
  }
}
