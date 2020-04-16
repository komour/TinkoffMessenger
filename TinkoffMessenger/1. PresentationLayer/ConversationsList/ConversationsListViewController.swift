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
  
  var onlineChannels = [ConversationCellStruct]()
  var offlineChannels = [ConversationCellStruct]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let conversationCellId = String(describing: ConversationCell.self)
    tableView.register(UINib(nibName: conversationCellId, bundle: nil), forCellReuseIdentifier: conversationCellId)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    self.tableView.rowHeight = 70
    
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
    switch section {
    case 0:
      return onlineChannels.count
    default:
      return offlineChannels.count
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = String(describing: ConversationCell.self)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationCell else {
      return UITableViewCell()
    }
    switch indexPath.section {
    case 0:
      cell.configure(with: onlineChannels[indexPath.row])
    default:
      cell.configure(with: offlineChannels[indexPath.row])
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      model.deleteChat(withID: onlineChannels[indexPath.row].identifier)
    default:
      model.deleteChat(withID: offlineChannels[indexPath.row].identifier)
    }
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
    if indexPath.section == 0 {
      chosenChanel = onlineChannels[indexPath.row]
    } else {
      chosenChanel = offlineChannels[indexPath.row]
    }
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(20.0)
  }
  
//  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 80
//  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let label = UILabel()
    
    view.addSubview(label)
    label.bindEdgesToSuperview()
    
    label.backgroundColor = UIColor(named: "brightYellow")
    label.font = UIFont.systemFont(ofSize: 17)
    label.font = label.font.with(.traitBold)
    label.textColor = UIColor.black
    label.textAlignment = .center
    let sectionIsEmpty = self.tableView(tableView, numberOfRowsInSection: section) == 0
    switch section {
    case 0:
      label.text =  "Online"
    default:
      label.text =  "History"
    }
    if !sectionIsEmpty {
      return view
    } else {
      return nil
    }
  }
}
