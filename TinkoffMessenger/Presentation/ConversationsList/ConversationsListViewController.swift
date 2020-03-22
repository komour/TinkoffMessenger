//
//  ConversationsListViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: Bundle.main)
  let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
  
  private lazy var db = Firestore.firestore()
  private lazy var reference = db.collection("channels")
  private var onlineChannels = [ConversationCellModel]()
  private var offlineChannels = [ConversationCellModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let conversationCellId = String(describing: ConversationCell.self)
    tableView.register(UINib(nibName: conversationCellId, bundle: nil), forCellReuseIdentifier: conversationCellId)
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    
    reference.addSnapshotListener { [weak self] (querySnapshot, err) in
      guard let self = self else { return }
      self.onlineChannels.removeAll()
      self.offlineChannels.removeAll()
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        let tenMinutesAgo = Date().addingTimeInterval(-10.0 * 60.0)
        guard let querySnapshot = querySnapshot else { return }
        for document in querySnapshot.documents {
          let name = document.data()["name"] as? String ?? "nil name"
          let lastMessage = document.data()["lastMessage"] as? String
          let lastActivity = document.data()["lastActivity"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 10.0))
          let channelActivityDate = lastActivity.dateValue()
          if tenMinutesAgo <= channelActivityDate {
            self.onlineChannels.append(ConversationCellModel(name: name,
                                                             message: lastMessage,
                                                             date: channelActivityDate,
                                                             isOnline: true,
                                                             hasUnreadMessages: false,
                                                             identifier: document.documentID))
          } else {
            self.offlineChannels.append(
              ConversationCellModel(name: name,
                                    message: lastMessage,
                                    date: channelActivityDate,
                                    isOnline: false,
                                    hasUnreadMessages: false,
                                    identifier: document.documentID))
          }
          
        }
      }
      self.onlineChannels.sort(by: self.sortingClosure)
      self.offlineChannels.sort(by: self.sortingClosure)
      self.tableView.reloadData()
    }
  }
  
  //  go to profile vc
  @IBAction func profileButtonAction(_ sender: Any) {
    let profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    profileNavigationController.modalPresentationStyle = .fullScreen
    present(profileNavigationController, animated: true)
  }
  
  @IBAction func createChannelAction(_ sender: Any) {
    let conversationsListStoryboard = self.storyboard
    guard let conversationsListStoryboard1 = conversationsListStoryboard else {
      print("koka")
      return
    }
    let createChannelNavigationController = conversationsListStoryboard1.instantiateViewController(withIdentifier: "CreateChannelNavigationController")
    createChannelNavigationController.modalPresentationStyle = .fullScreen
    present(createChannelNavigationController, animated: true)
  }
  
  lazy var sortingClosure = { (a0: ConversationCellModel, a1: ConversationCellModel) -> Bool in
    if a0.message != nil {
      if a1.message != nil {
        return a1.date < a0.date
      } else {
        return true
      }
    } else {
      if a1.message != nil {
        return false
      } else {
        return a0.name < a1.name
      }
    }
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
    
    var chosenChanel: ConversationCellModel?
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
    destination.hasMessages = curChannel.message != nil
    let lastMessage = curChannel.message ?? "nothing"
    destination.channel = Channel(identifier: curChannel.identifier, name: curChannel.name, lastMessage: lastMessage)
    self.navigationController?.pushViewController(destination, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(20.0)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let label = UILabel()
    
    view.addSubview(label)
    label.bindEdgesToSuperview()
    
    label.backgroundColor = UIColor(named: "lemon")
    label.font = UIFont.systemFont(ofSize: 17)
    label.font = label.font.with(.traitBold)
    label.textColor = UIColor.black
    label.textAlignment = .center
    
    switch section {
    case 0:
      label.text =  "Online"
    default:
      label.text =  "History"
    }
    
    return view
  }
  
}

extension ConversationsListViewController {
  
  func loadChannels() {
    onlineChannels.removeAll()
    offlineChannels.removeAll()
    reference.getDocuments { [weak self] (querySnapshot, err) in
      guard let self = self else { return }
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        let tenMinutesAgo = Date().addingTimeInterval(-10.0 * 60.0)
        guard let querySnapshot = querySnapshot else { return }
        for document in querySnapshot.documents {
          let name = document.data()["name"] as? String ?? "nil name"
          let lastMessage = document.data()["lastMessage"] as? String
          let lastActivity = document.data()["lastActivity"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 10.0))
          let channelActivityDate = lastActivity.dateValue()
          if tenMinutesAgo <= channelActivityDate {
            self.onlineChannels.append(ConversationCellModel(name: name,
                                                             message: lastMessage,
                                                             date: channelActivityDate,
                                                             isOnline: true,
                                                             hasUnreadMessages: false,
                                                             identifier: document.documentID))
          } else {
            self.offlineChannels.append(
              ConversationCellModel(name: name,
                                    message: lastMessage,
                                    date: channelActivityDate,
                                    isOnline: false,
                                    hasUnreadMessages: false,
                                    identifier: document.documentID))
          }
          
        }
      }
      self.onlineChannels.sort(by: self.sortingClosure)
      self.offlineChannels.sort(by: self.sortingClosure)
      self.tableView.reloadData()
    }
  }
}
