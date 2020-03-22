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
  weak var profileVC: ProfileViewController?
  
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
    guard let profileVC = profileVC else {
      print("nil profileVC in \(#function)")
      return
    }
    successFlag = true
    if dataManager.needToSaveAvatar() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newAvatar = profileVC.avatarImageView.image {
          self.successFlag = self.successFlag && self.dataManager.saveAvatar(avatar: newAvatar)
        } else {
          self.successFlag = false
        }
      }
    }
    if dataManager.needToSaveName() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newName = profileVC.nameTextField.text {
          self.successFlag = self.successFlag && self.dataManager.saveText(text: newName, to: self.dataManager.nameFile)
        } else {
          self.successFlag = false
        }
      }
    }
    if dataManager.needToSaveDescription() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let newDescription = profileVC.descriptionTextView.text {
          self.successFlag = self.successFlag && self.dataManager.saveText(text: newDescription, to: self.dataManager.descriptionFile)
        } else {
          self.successFlag = false
        }
      }
    }
    sleep(1)
    if successFlag {
      dataManager.updateProfileData()
    }
  }
}