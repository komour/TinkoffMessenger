//
//  ProfileModel.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 13.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ProfileModel {
  
  let viewController: ProfileViewController?
  private var imagePicker: ImagePickerManager?
  
  init(for viewController: ProfileViewController) {
    self.viewController = viewController
    imagePicker = ImagePickerManager(for: viewController)
  }
  
  func choosePhoto() {
    guard let vc = viewController else { return }
    guard let imagePicker = imagePicker else {
      print("nil imagePicker in \(#function)")
      return
    }
    imagePicker.pickImage({ image in
      vc.avatarImageView.image = image
      vc.didSetAvatar = true
      self.handleSaveButtons()
    })
  }
  
  func handleSaveButtons() {
    guard let vc = viewController else { return }
    if hasChanges() {
      vc.saveButton.isEnabled = true
    } else {
      vc.saveButton.isEnabled = false
    }
  }
  
  private func hasChanges() -> Bool {
    guard let vc = viewController else { return false }
    if let newName = vc.nameTextField.text, newName != vc.nameLabel.text {
      return true
    } else if let newDescription = vc.descriptionTextView.text, newDescription != vc.descriptionLabel.text {
      return true
    } else if vc.didSetAvatar {
      return true
    }
    return false
  }
  
  func switchEditingMode() {
    guard let vc = viewController else { return }
    vc.choosePhotoButton.isHidden = !vc.choosePhotoButton.isHidden
    vc.nameLabel.isHidden = !vc.nameLabel.isHidden
    vc.descriptionLabel.isHidden = !vc.descriptionLabel.isHidden
    vc.nameTextField.isHidden = !vc.nameTextField.isHidden
    vc.descriptionTextView.isHidden = !vc.descriptionTextView.isHidden
    vc.stackView.isHidden = !vc.stackView.isHidden
    vc.editButton.isHidden = !vc.editButton.isHidden
  }
  
  func addEndEditingGesture() {
    guard let vc = viewController else { return }
    let tapEndEditing = UITapGestureRecognizer(target: vc, action: #selector(vc.endEditing))
    vc.view.addGestureRecognizer(tapEndEditing)
  }
  
  func fetchDataOrCreateEntity() {
    if UserDefaults.standard.bool(forKey: "firstLaunch") != false {
      UserDefaults.standard.set(false, forKey: "firstLaunch")
      CoreDataManager.instance.createEntity()
    } else {
      fetchProfileData()
    }
  }
  
  func fetchProfileData() {
    guard let vc = viewController else { return }

    let user = CoreDataManager.instance.getUser()
    if let user = user {
      vc.nameLabel.text = user.name
      vc.descriptionLabel.text = user.descr
      if let data = user.avatar {
        vc.avatarImageView.image = UIImage(data: data)
      }
    }
  }
  
  func saveChanges() {
    guard let vc = viewController else { return }

    guard let name = vc.nameTextField.text,
      let description = vc.descriptionTextView.text,
      let avatarData = vc.avatarImageView.image?.pngData() else {
        print(#function)
        return
    }
    let user = User(avatar: avatarData, name: name, description: description)
    CoreDataManager.instance.saveChanges(user: user)
  }
  
  // MARK: - Success/Error alerts
  
  func createSuccessAlert() {
    guard let vc = viewController else { return }
    let alert = UIAlertController(title: "Success!", message: "Data has been successfully changed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      guard let self = self else { return }
      self.switchEditingMode()
      self.fetchProfileData()
    }))
    vc.present(alert, animated: true, completion: nil)
  }
  
  func createErrorAlert() {
    guard let vc = viewController else { return }
    let alert = UIAlertController(title: "Error!", message: "An error has occurred while saving the new data.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
      vc.saveAction()
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      guard let self = self else { return }
      self.switchEditingMode()
    }))
    vc.present(alert, animated: true, completion: nil)
  }
  
}
