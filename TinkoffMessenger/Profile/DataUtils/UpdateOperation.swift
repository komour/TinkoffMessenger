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
  let profileVC: ProfileViewController
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.dataManager = DataManager(for: profileVC)
    super.init()
  }
  
  override func main() {
    guard !isCancelled else { return }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.profileVC.activityIndicator.startAnimating()
    }
    dataManager.updateProfileData()
  }
}
