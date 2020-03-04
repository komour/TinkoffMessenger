//
//  ConversationViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var newMessageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBottomConstraint: NSLayoutConstraint!
    
    //  random data
    static var messages: [MessageCellModel] = (0...Int.random(in: 10...100)).map { _ in
        MessageCellModel(text: randomString(length: Int.random(in: 10...300)), isIncoming: Bool.random())
    }
//  temporary crutch for mock data
    var hasMessages = false
    
    private let toolbarHeight: CGFloat = 25
    private let textFieldBottomConstraintDefault: CGFloat = 4
    private let sendBottomConstraintDefault: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MessageCell.self))
        tableView.dataSource = self
        tableView.reloadData()
        
        if hasMessages {
            tableView.scrollToBottom()
        }
        
        setupToolBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print(#function)
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        DispatchQueue.main.async {
            self.textFieldBottomConstraint.constant += keyboardHeight + self.toolbarHeight - 10
            self.sendBottomConstraint.constant += keyboardHeight + self.toolbarHeight - 10
            UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.textFieldBottomConstraint.constant = self.textFieldBottomConstraintDefault
            self.sendBottomConstraint.constant = self.sendBottomConstraintDefault
            UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: toolbarHeight)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done
            , target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        newMessageTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func sendAction() {
        if let newMessage = newMessageTextField.text {
            if newMessage == "" { return }
            ConversationViewController.messages.append(MessageCellModel(text: newMessage, isIncoming: false))
            tableView.reloadData()
            newMessageTextField.text = ""
        }
    }
    
}

// MARK: UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationViewController.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//      temporary crutch for chats with no messages
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
