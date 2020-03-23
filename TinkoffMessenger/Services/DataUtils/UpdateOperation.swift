//
//  UpdateOperation.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class UpdateOperation: Operation {
  
  let dataManager: DataManager
  weak var profileVC: ProfileViewController?
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.dataManager = DataManager(for: profileVC)
    super.init()
  }
  
  override func main() {
    guard let profileVC = profileVC else {
      print("nil profileVC in \(#function)")
      return
    }
    guard !isCancelled else { return }
    DispatchQueue.main.async {
      profileVC.activityIndicator.startAnimating()
    }
    dataManager.updateProfileData()
  }
}
