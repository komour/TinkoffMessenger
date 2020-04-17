//
//  ConversationViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
  
  lazy var model = ConversationModel(for: self)
  
  @IBOutlet weak var newMessageTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var messages = [MessageCellStruct]()
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
    addEndEditingGesture() 
    model.addSnapshotListner()
    
  }
  
  deinit {
    removeKeyboardNotifications()
  }
  
  func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func removeKeyboardNotifications() {
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
    scrollView.contentOffset = CGPoint.zero
  }
  
  @IBAction func sendAction() {
    model.sendAction()
  }
  
  @objc func endEditing() {
    view.endEditing(true)
  }
  
  func addEndEditingGesture() {
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
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
