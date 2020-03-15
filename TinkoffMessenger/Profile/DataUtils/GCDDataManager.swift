//
//  GCDDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class GCDDataManager {
  
  let profileVC: ProfileViewController
  let dataManager: DataManager
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.dataManager = DataManager(for: profileVC)
  }
  
  // MARK: - main method with all edit logic
  
  func allSaveHandle() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.activityIndicator.startAnimating()
      }
      var successFlag = true
      if self.dataManager.needToSaveAvatar() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newAvatar = self.profileVC.avatarImageView.image {
            successFlag = successFlag && self.dataManager.saveAvatar(avatar: newAvatar)
          } else {
            successFlag = false
          }
        }
      }
      if self.dataManager.needToSaveName() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newName = self.profileVC.nameTextField.text {
            successFlag = successFlag && self.dataManager.saveText(text: newName, to: self.dataManager.nameFile)
          } else {
            successFlag = false
          }
        }
      }
      if self.dataManager.needToSaveDescription() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newDescription = self.profileVC.descriptionTextView.text {
            successFlag = successFlag && self.dataManager.saveText(text: newDescription, to: self.dataManager.descriptionFile)
          } else {
            successFlag = false
          }
        }
      }
      
      if successFlag {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.profileVC.endEditing()
          self.profileVC.createSuccessAlert()
          self.dataManager.updateProfileData()
          self.profileVC.activityIndicator.stopAnimating()
        }
      } else {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.profileVC.endEditing()
          self.profileVC.createErrorAlert(isOperation: false)
          self.profileVC.activityIndicator.stopAnimating()
        }
      }
    }
  }
}
