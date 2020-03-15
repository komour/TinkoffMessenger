//
//  DataManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class DataManager {
  let nameFile = "name.txt"
  let descriptionFile = "description.txt"
  let avatarFile = "avatar.jpg"
  
  func readAvatar() -> UIImage? {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return nil
    }
    let imageFileURL = directory.appendingPathComponent(avatarFile)
    return UIImage(contentsOfFile: imageFileURL.path)
  }
  
  func saveAvatar(avatar: UIImage) -> Bool {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return false
    }
    let imageFileUrl = directory.appendingPathComponent(avatarFile)
    if let data = avatar.jpegData(compressionQuality: 1.0) {
      do {
        try data.write(to: imageFileUrl)
        return true
      } catch {
        print("Smth went wrong in \(#function)")
        return false
      }
    }
    print("nil avatar data in \(#function)")
    return false
  }
  
  func readName() -> String? {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return nil
    }
    let nameFileUrl = directory.appendingPathComponent(nameFile)
    do { let nameText = try String(contentsOf: nameFileUrl, encoding: .utf8)
      return nameText
    } catch {
      print("nothing to read in \(#function)")
      return nil
    }
  }
  
  func saveName(nameText: String) -> Bool {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return false
    }
    let nameFileUrl = directory.appendingPathComponent(nameFile)
    do {
      try nameText.write(to: nameFileUrl, atomically: false, encoding: .utf8)
      return true
    } catch {
      print("Smth went wrong in \(#function)")
      return false
    }
    
  }
  
  func readDescription() -> String? {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return nil
    }
    let descriptionFileUrl = directory.appendingPathComponent(descriptionFile)
    do { let descriptionText = try String(contentsOf: descriptionFileUrl, encoding: .utf8)
      return descriptionText
    } catch {
      print("nothing to read in \(#function)")
      return nil
    }
  }
  
  func saveDescription(descriptionText: String) -> Bool {
    guard let directory = getDocumentDirectory() else {
      print("nil directory in \(#function)")
      return false
    }
    let descriptionFileUrl = directory.appendingPathComponent(descriptionFile)
    do { try descriptionText.write(to: descriptionFileUrl, atomically: false, encoding: .utf8)
      return true
    } catch {
      print("Smth went wrong in \(#function)")
      return false
    }
  }
  
  func getDocumentDirectory() -> URL? {
    if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      return directory
    }
    return nil
  }
}
