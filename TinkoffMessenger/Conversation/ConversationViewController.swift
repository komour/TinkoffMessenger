//
//  ConversationViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//  random data
    static var messages: [MessageCellModel] = (0...Int.random(in: 10...100)).map { _ in
        MessageCellModel(text: randomString(length: Int.random(in: 10...300)), isIncoming: Bool.random())
    }
//  temporary crutch for mock data
    var hasMessages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MessageCell.self))
        tableView.dataSource = self
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
        return cell
    }
    
    
}
