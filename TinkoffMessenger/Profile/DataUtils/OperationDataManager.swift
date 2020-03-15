//
//  OperationDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class OperationDataManager {
  let profileVC: ProfileViewController
  let updateOperation: UpdateOperation
  let allSaveHandleOperation: AllSaveHandleOperation
  let queue = OperationQueue()
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.updateOperation = UpdateOperation(for: profileVC)
    self.allSaveHandleOperation = AllSaveHandleOperation(for: profileVC)
  }
  
  func allSaveHandle() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.profileVC.activityIndicator.startAnimating()
    }
    
    allSaveHandleOperation.completionBlock = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.activityIndicator.stopAnimating()
        self.profileVC.endEditing()
        if self.allSaveHandleOperation.successFlag {
          self.profileVC.createSuccessAlert()
        } else {
          self.profileVC.createErrorAlert(isOperation: true)
        }
      }
    }
    queue.addOperation(allSaveHandleOperation)
  }
  
  func updateProfileData() {
    updateOperation.completionBlock = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.activityIndicator.stopAnimating()
      }
    }
    queue.addOperation(updateOperation)
  }
  
}
