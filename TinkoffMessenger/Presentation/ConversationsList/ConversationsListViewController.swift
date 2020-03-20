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

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    let conversationCellId = String(describing: ConversationCell.self)
    tableView.register(UINib(nibName: conversationCellId, bundle: nil), forCellReuseIdentifier: conversationCellId)
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
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
  // MARK: - Temporary test dataset
  
  private lazy var onlinePersons: [ConversationCellModel] = (0...Int.random(in: 10...15)).map { _ in
    ConversationCellModel(name: randomString(length: .random(in: 3...42)),
                          message: randomMessage(length: .random(in: 0...200)),
                          date: randomDate(),
                          isOnline: true,
                          hasUnreadMessages: Bool.random())
  }.sorted(by: {
    if $0.message != nil {
      if $1.message != nil {
        return $1.date < $0.date
      } else {
        return true
      }
    } else {
      if $1.message != nil {
        return false
      } else {
        return $1.date < $0.date
      }
    }
  }) //the newest chats at the top and chats with nil messages at the bottom
  
  private lazy var offlinePersons: [ConversationCellModel] = (0...Int.random(in: 10...15)).map { _ in
    ConversationCellModel(
      name: randomString(length: .random(in: 3...42)),
      message: String?(randomString(length: .random(in: 0...200))),
      date: randomDate(),
      isOnline: false,
      hasUnreadMessages: Bool.random()
    )
  }.sorted(by: { $1.date < $0.date })
  
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return onlinePersons.count
    default:
      return offlinePersons.count
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
      cell.configure(with: onlinePersons[indexPath.row])
    default:
      cell.configure(with: offlinePersons[indexPath.row])
    }
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //      get conversationViewController as destination
    let conversationVCId = String(describing: ConversationViewController.self)
    let conversationViewController = conversationStoryboard.instantiateViewController(withIdentifier: conversationVCId) as? ConversationViewController
    guard let destination = conversationViewController else {
      print(#function)
      return
    }
    
    //      get the title of the current chat
    //      and check whether it has messages (temporary crutches for mock data)
    var currentName: String?
    if indexPath.section == 0 {
      currentName = onlinePersons[indexPath.row].name
      destination.hasMessages = onlinePersons[indexPath.row].message != nil
    } else {
      destination.hasMessages = offlinePersons[indexPath.row].message != nil
      currentName = offlinePersons[indexPath.row].name
    }
    guard let curName = currentName else {
      print("nil current name in \(#function)")
      return
    }
    
    //      set new titile and navigate to conversationVC
    destination.title = curName
//    reference.addSnapshotListener { snapshot, _ in
//      print(snapshot?.documents[0].data() ?? "keke")
//      if let channelId = snapshot?.documents[0].documentID {
//        print("Yass")
//        destination.channel = Channel(identifier: channelId, name: "kekeke", lastMessage: "kjk")
//      }
//    }
    
//    self.navigationController?.pushViewController(destination, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(30.0)
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

// MARK: - utils to create test dataset

extension ConversationsListViewController {
  
  func randomMessage(length: Int) -> String? {
    switch Bool.random() {
    case true:
      return nil
    default:
      return randomString(length: length)
    }
  }
  
  //random date from 28 Feb to 06 Mar
  func randomDate() -> Date {
    Date(timeIntervalSinceReferenceDate: Double.random(in: 604600000...605210000))
  }
  /* timeIntervalSinceReferenceDate dates:
   * 604800000: 02 Mar
   * 604900000: 03 Mar
   * 604990000: 04 Mar
   * 605090000: 05 Mar
   * 605190000: 06 Mar
   * 605290000: 07 Mar
   * 605390000: 08 Mar
   * 605410000: 09 Mar
   * 605490000: 10 Mar
   */
}
