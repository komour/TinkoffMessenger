//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var choosePhotoButton: UIButton!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var gcdButton: UIButton!
  @IBOutlet weak var operationButton: UIButton!
  
  private let dataManager = DataManager()
  private var imagePicker: ImagePickerManager?
  
  var didSetAvatar = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker = ImagePickerManager(for: self)
    
    editButton.layer.borderWidth = 1
    editButton.layer.borderColor = UIColor.black.cgColor
    
    nameTextField.font = nameLabel.font
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    
    addKeyboardNotifications()
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
    
    nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    descriptionTextView.delegate = self
    
    updateProfileData()
  }
  
  deinit {
    removeKeyboardNotifications()
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
  
  override func viewDidLayoutSubviews() {
    let cornerRadius = choosePhotoButton.bounds.size.width / 2
    let edgeInset = choosePhotoButton.bounds.size.width / 4
    
    avatarImageView.layer.cornerRadius = cornerRadius
    choosePhotoButton.layer.cornerRadius = cornerRadius
    
    choosePhotoButton.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    
    editButton.layer.cornerRadius = editButton.bounds.size.width / 25
  }
  
  private func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    guard let keyboardFrame: NSValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      print("something went wrong in \(#function)")
      return
    }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
  }
  
  @objc private func keyboardWillHide() {
    self.scrollView.contentOffset = CGPoint.zero
  }
  
  @IBAction func choosePhotoAction() {
    guard let imagePicker = imagePicker else {
      print("nil imagePicker in \(#function)")
      return
    }
    imagePicker.pickImage({ [weak self] image in
      self?.avatarImageView.image = image
      self?.didSetAvatar = true
      self?.handleSaveButtons()
    })
  }
  
  // MARK: - All editing logic
  
  @IBAction func exitButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func editAction() {
    switchEditingMode()
    didSetAvatar = false
    nameTextField.text = nameLabel.text
    descriptionTextView.text = descriptionLabel.text
    handleSaveButtons()
  }
  
  @IBAction func operationAction() {
    activityIndicator.startAnimating()
    var successFlag = true
    if needToSaveAvatar() {
      if let newAvatar = avatarImageView.image {
        successFlag = successFlag && dataManager.saveAvatar(avatar: newAvatar)
      } else {
        successFlag = false
      }
    }
    if needToSaveName() {
      if let newName = nameTextField.text {
        successFlag = successFlag && dataManager.saveName(nameText: newName)
      } else {
        successFlag = false
      }
    }
    if needToSaveDescription() {
      if let newDescription = descriptionTextView.text {
        successFlag = successFlag && dataManager.saveDescription(descriptionText: newDescription)
      } else {
        successFlag = false
      }
    }
    
    if successFlag {
      endEditing()
      createSuccessAlert()
      updateProfileData()
      activityIndicator.stopAnimating()
    } else {
      endEditing()
      createErrorAlert(isOperation: true)
      activityIndicator.stopAnimating()
    }
  }
  
  @IBAction func gcdAction() {
    activityIndicator.startAnimating()
    var successFlag = true
    if needToSaveAvatar() {
      if let newAvatar = avatarImageView.image {
        successFlag = successFlag && dataManager.saveAvatar(avatar: newAvatar)
      } else {
        successFlag = false
      }
    }
    if needToSaveName() {
      if let newName = nameTextField.text {
        successFlag = successFlag && dataManager.saveName(nameText: newName)
      } else {
        successFlag = false
      }
    }
    if needToSaveDescription() {
      if let newDescription = descriptionTextView.text {
        successFlag = successFlag && dataManager.saveDescription(descriptionText: newDescription)
      } else {
        successFlag = false
      }
    }
    
    if successFlag {
      endEditing()
      createSuccessAlert()
      updateProfileData()
      activityIndicator.stopAnimating()
    } else {
      endEditing()
      createErrorAlert(isOperation: false)
      activityIndicator.stopAnimating()
    }
  }
  
  @IBAction func cancelEditMode() {
    switchEditingMode()
    endEditing()
  }
  
  func needToSaveAvatar() -> Bool {
    if let oldAvatar = dataManager.readAvatar(), let newAvatar = avatarImageView.image, oldAvatar.isEqual(to: newAvatar) {
      return false
    }
    return true
  }
  
  func needToSaveName() -> Bool {
    if let oldName = dataManager.readName(), let newName = nameTextField.text, newName == oldName {
      return false
    }
    return true
  }
  
  func needToSaveDescription() -> Bool {
    if let oldDescription = dataManager.readDescription(), let newDescription = descriptionTextView.text, newDescription == oldDescription {
      return false
    }
    return true
  }
  
  func updateProfileData() {
    if let oldAvatar = dataManager.readAvatar() {
      avatarImageView.image = oldAvatar
    }
    if let oldName = dataManager.readName() {
      nameLabel.text = oldName
    }
    if let oldDescription = dataManager.readDescription() {
      descriptionLabel.text = oldDescription
    }
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    handleSaveButtons()
  }
  
  private func hasChanges() -> Bool {
    if let newName = nameTextField.text, newName != nameLabel.text {
      return true
    } else if let newDescription = descriptionTextView.text, newDescription != descriptionLabel.text {
      return true
    } else if didSetAvatar {
      return true
    }
    return false
  }
  
  private func handleSaveButtons() {
    if hasChanges() {
      gcdButton.isEnabled = true
      operationButton.isEnabled = true
    } else {
      gcdButton.isEnabled = false
      operationButton.isEnabled = false
    }
  }
  
  private func switchEditingMode() {
    choosePhotoButton.isHidden = !choosePhotoButton.isHidden
    nameLabel.isHidden = !nameLabel.isHidden
    descriptionLabel.isHidden = !descriptionLabel.isHidden
    nameTextField.isHidden = !nameTextField.isHidden
    descriptionTextView.isHidden = !descriptionTextView.isHidden
    stackView.isHidden = !stackView.isHidden
    editButton.isHidden = !editButton.isHidden
  }
  
  // MARK: - Success/Error alerts
  
  func createSuccessAlert() {
    let alert = UIAlertController(title: "Success!", message: "Data has been successfully changed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      self?.switchEditingMode()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func createErrorAlert(isOperation: Bool) {
    let alert = UIAlertController(title: "Error!", message: "An error has occurred while saving the new data.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
      if isOperation { self?.operationAction() } else { self?.gcdAction() }
      alert.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      self?.switchEditingMode()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    handleSaveButtons()
  }
}
