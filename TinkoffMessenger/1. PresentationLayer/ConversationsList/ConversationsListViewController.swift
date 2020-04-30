//
//  ConversationsListViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
  
  lazy var model = ConversationsListModel(for: self)
  
  @IBOutlet weak var tableView: UITableView!
  let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: Bundle.main)
  let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
  let createChannelStoryboard = UIStoryboard(name: "CreateChannel", bundle: Bundle.main)
  
  var channels = [ConversationCellStruct]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let conversationCellId = String(describing: ConversationCell.self)
    tableView.register(UINib(nibName: conversationCellId, bundle: nil), forCellReuseIdentifier: conversationCellId)
    tableView.dataSource = self
    tableView.delegate = self
    navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    tableView.rowHeight = 70
    
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    
    model.addSnapshotListner()
    
  }
  
  //  go to profile vc
  @IBAction func profileButtonAction(_ sender: Any) {
    let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    profileNavigationController.modalPresentationStyle = .fullScreen
    present(profileNavigationController, animated: true)
  }
  
  @IBAction func createChannelAction(_ sender: Any) {
    let createChannelNavigationController = createChannelStoryboard.instantiateViewController(withIdentifier: "CreateChannelNavigationController")
    createChannelNavigationController.modalPresentationStyle = .fullScreen
    present(createChannelNavigationController, animated: true)
  }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    channels.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = String(describing: ConversationCell.self)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationCell else {
      return UITableViewCell()
    }
    cell.configure(with: channels[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    model.deleteChat(withID: channels[indexPath.row].identifier)
  }
  
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let conversationVCId = String(describing: ConversationViewController.self)
    let conversationViewController = conversationStoryboard.instantiateViewController(withIdentifier: conversationVCId) as? ConversationViewController
    guard let destination = conversationViewController else {
      print(#function)
      return
    }
    
    var chosenChanel: ConversationCellStruct?

    chosenChanel = channels[indexPath.row]
    guard let curChannel = chosenChanel else {
      print("nil chosenChanel in \(#function)")
      return
    }
    destination.title = curChannel.name
    let lastMessage = curChannel.message ?? "nothing"
    destination.channel = Channel(identifier: curChannel.identifier, name: curChannel.name, lastMessage: lastMessage, lastActivity: Date())
    self.navigationController?.pushViewController(destination, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
  }
}
