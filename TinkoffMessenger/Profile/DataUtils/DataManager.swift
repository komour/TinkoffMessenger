//
//  DataManagerHelper.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

// MARK: - Helper class for GCD and Operation data managers

class DataManager {
  
  let profileVC: ProfileViewController
  let nameFile = "name.txt"
  let descriptionFile = "description.txt"
  let avatarFile = "avatar.jpg"
  
  init(for profileVC: ProfileViewController) {
    self.profileVC = profileVC
  }
  
  // MARK: - helper methods
  
  func getDocumentDirectory() -> URL? {
    if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      return directory
    }
    return nil
  }
  
  func needToSaveAvatar() -> Bool {
    var newAvatar: UIImage?
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      newAvatar = self.profileVC.avatarImageView.image
    }
    if let oldAvatar = readAvatar(), let newAvatar = newAvatar, oldAvatar.isEqual(to: newAvatar) {
      return false
    }
    return true
  }
  
  func needToSaveName() -> Bool {
    var newName: String?
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      newName = self.profileVC.nameTextField.text
    }
    if let oldName = readText(from: nameFile), let newName = newName, newName == oldName {
      return false
    }
    return true
  }
  
  func needToSaveDescription() -> Bool {
    var newDescription: String?
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      newDescription = self.profileVC.nameTextField.text
    }
    if let oldDescription = readText(from: descriptionFile), let newDescription = newDescription, newDescription == oldDescription {
      return false
    }
    return true
  }
  
  // MARK: - Read/Write methods
  
  func readAvatar() -> UIImage? {
    guard let directory = self.getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return nil
    }
    let imageFileURL = directory.appendingPathComponent(self.avatarFile)
    return UIImage(contentsOfFile: imageFileURL.path)
  }
  
  func saveAvatar(avatar: UIImage) -> Bool {
    guard let directory = self.getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return false
    }
    let imageFileUrl = directory.appendingPathComponent(self.avatarFile)
    if let data = avatar.jpegData(compressionQuality: 1.0) {
      do {
        try data.write(to: imageFileUrl)
        return true
      } catch {
        print("Smth went wrong in \(#function)")
        return false
      }
    } else {
      print("nil jpegData in \(#function)")
      return false
    }
  }
  
  func readText(from fileName: String) -> String? {
    guard let directory = self.getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return nil
    }
    let fileURL = directory.appendingPathComponent(fileName)
    do { let text = try String(contentsOf: fileURL, encoding: .utf8)
      return text
    } catch {
      print("nothing to read from \(fileName) in \(#function)")
      return nil
    }
  }
  
  func saveText(text: String, to file: String) -> Bool {
    guard let directory = self.getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return false
    }
    let nameFileUrl = directory.appendingPathComponent(file)
    do {
      try text.write(to: nameFileUrl, atomically: false, encoding: .utf8)
      return true
    } catch {
      print("Smth went wrong in \(#function)")
      return false
    }
  }
  
  // MARK: - Update profile name, description and avatar
  
  func updateProfileData() {
    if let oldAvatar = readAvatar() {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.avatarImageView.image = oldAvatar
      }
    }
    if let oldName = readText(from: nameFile) {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.nameLabel.text = oldName
      }
    }
    if let oldDescription = readText(from: descriptionFile) {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.profileVC.descriptionLabel.text = oldDescription
      }
    }
  }
  
}
