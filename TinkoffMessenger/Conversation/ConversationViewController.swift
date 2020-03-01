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
    
    static var newTitle: String?
    
    private lazy var messages: [MessageCellModel] = {
        return (0...Int.random(in: 10...100)).map { _ in
            MessageCellModel(text: randomString(length: Int.random(in: 10...500)))
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: incomingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: incomingMessageCell.self))
        tableView.register(UINib(nibName: String(describing: outgoingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: outgoingMessageCell.self))
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let title = ConversationViewController.newTitle else {
            print("nil newTitle in \(#function)")
            return
        }
        navigationItem.title = title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConversationViewController.newTitle = nil
    }
}

// MARK: UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Bool.random() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: outgoingMessageCell.self), for: indexPath) as? outgoingMessageCell else {
                return UITableViewCell()
            }
            cell.configure(with: messages[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: incomingMessageCell.self), for: indexPath) as? incomingMessageCell else {
                return UITableViewCell()
            }
            cell.configure(with: messages[indexPath.row])
            return cell
        }
    }
    
    
}
