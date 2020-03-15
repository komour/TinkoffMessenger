//
//  ReadWriteOperation.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class AllSaveHandleOperation: Operation {
  var successFlag = true
  
  let dataManager: DataManager
  let profileVC: ProfileViewController
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
    self.dataManager = DataManager(for: profileVC)
    super.init()
  }
  
  override func main() {
    guard !isCancelled else { return }
    allSaveHandle()
  }
  
  // MARK: - main method with all edit logic
  
  func allSaveHandle() {
    successFlag = true
    if dataManager.needToSaveAvatar() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newAvatar = self.profileVC.avatarImageView.image {
          self.successFlag = self.successFlag && self.dataManager.saveAvatar(avatar: newAvatar)
        } else {
          self.successFlag = false
        }
      }
    }
    if dataManager.needToSaveName() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newName = self.profileVC.nameTextField.text {
          self.successFlag = self.successFlag && self.dataManager.saveText(text: newName, to: self.dataManager.nameFile)
        } else {
          self.successFlag = false
        }
      }
    }
    if dataManager.needToSaveDescription() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newDescription = self.profileVC.descriptionTextView.text {
          self.successFlag = self.successFlag && self.dataManager.saveText(text: newDescription, to: self.dataManager.descriptionFile)
        } else {
          self.successFlag = false
        }
      }
    }
    
    if successFlag {
      dataManager.updateProfileData()
    }
  }
}
