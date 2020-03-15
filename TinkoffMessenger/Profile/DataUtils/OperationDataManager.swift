//
//  OperationDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class OperationDataManager {
  weak var profileVC: ProfileViewController?
  let updateOperation: UpdateOperation
  var allSaveHandleOperation: AllSaveHandleOperation
  let queue = OperationQueue()
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.updateOperation = UpdateOperation(for: profileVC)
    self.allSaveHandleOperation = AllSaveHandleOperation(for: profileVC)
  }
  
  func allSaveHandle() {
    guard let profileVC = profileVC else {
      print("nil profileVC in \(#function)")
      return
    }
    DispatchQueue.main.async {
      profileVC.activityIndicator.startAnimating()
    }
    allSaveHandleOperation = AllSaveHandleOperation(for: profileVC)
    allSaveHandleOperation.completionBlock = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        profileVC.activityIndicator.stopAnimating()
        profileVC.endEditing()
        if self.allSaveHandleOperation.successFlag {
          profileVC.createSuccessAlert()
        } else {
          profileVC.createErrorAlert(isOperation: true)
        }
      }
    }
    queue.addOperation(allSaveHandleOperation)
  }
  
  func updateProfileData() {
    guard let profileVC = profileVC else {
      print("nil profileVC in \(#function)")
      return
    }
    updateOperation.completionBlock = {
      DispatchQueue.main.async {
        profileVC.activityIndicator.stopAnimating()
      }
    }
    queue.addOperation(updateOperation)
  }
  
}
