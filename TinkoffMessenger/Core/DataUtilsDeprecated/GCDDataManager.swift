//
//  GCDDataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class GCDDataManager {
  
  weak var profileVC: ProfileViewController?
  let dataManager: DataManager
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.dataManager = DataManager(for: profileVC)
  }
  
  // MARK: - main method with all edit logic
  
  func allSaveHandle() {
    guard let profileVC = profileVC else {
      print("nil profileVC in \(#function)")
      return
    }
    let queue = DispatchQueue.global(qos: .utility)
    queue.async { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        profileVC.activityIndicator.startAnimating()
      }
      var successFlag = true
      if self.dataManager.needToSaveAvatar() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newAvatar = profileVC.avatarImageView.image {
            successFlag = successFlag && self.dataManager.saveAvatar(avatar: newAvatar)
          } else {
            successFlag = false
          }
        }
      }
      if self.dataManager.needToSaveName() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newName = profileVC.nameTextField.text {
            successFlag = successFlag && self.dataManager.saveText(text: newName, to: self.dataManager.nameFile)
          } else {
            successFlag = false
          }
        }
      }
      if self.dataManager.needToSaveDescription() {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          if let newDescription = profileVC.descriptionTextView.text {
            successFlag = successFlag && self.dataManager.saveText(text: newDescription, to: self.dataManager.descriptionFile)
          } else {
            successFlag = false
          }
        }
      }
      
      if successFlag {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          profileVC.endEditing()
          profileVC.createSuccessAlert()
          self.dataManager.updateProfileData()
          profileVC.activityIndicator.stopAnimating()
        }
      } else {
        DispatchQueue.main.async {
          profileVC.endEditing()
          profileVC.createErrorAlert()
          profileVC.activityIndicator.stopAnimating()
        }
      }
    }
  }
}
