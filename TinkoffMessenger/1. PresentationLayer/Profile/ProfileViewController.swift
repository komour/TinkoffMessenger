//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  lazy var model = ProfileModel(for: self)

  @IBOutlet public weak var avatarImageView: UIImageView!
  @IBOutlet weak var choosePhotoButton: UIButton!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var cancelEditButton: UIButton!
    
  var didSetAvatar = false {
    didSet {
      model.handleSaveButtons()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    editButton.layer.borderWidth = 1
    editButton.layer.borderColor = UIColor.lightGray.cgColor
    
    descriptionTextView.layer.borderWidth = 1
    descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    
    nameTextField.layer.borderWidth = 1
    nameTextField.layer.borderColor = UIColor.lightGray.cgColor
    
    nameTextField.font = nameLabel.font
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    
    addKeyboardNotifications()
    model.addEndEditingGesture()
    
    nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    descriptionTextView.delegate = self
    
    model.fetchDataOrCreateEntity()
  }
  
  deinit {
    removeKeyboardNotifications()
  }
  
  func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func removeKeyboardNotifications() {
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
    scrollView.contentOffset = CGPoint.zero
  }
  
  @objc func endEditing() {
    view.endEditing(true)
  }
  
  override func viewDidLayoutSubviews() {
    let cornerRadius = choosePhotoButton.bounds.size.width / 2
    let edgeInset = choosePhotoButton.bounds.size.width / 4
    
    avatarImageView.layer.cornerRadius = cornerRadius
    choosePhotoButton.layer.cornerRadius = cornerRadius
    
    choosePhotoButton.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    
    editButton.layer.cornerRadius = editButton.bounds.size.width / 25
    nameTextField.layer.cornerRadius = 12
    descriptionTextView.layer.cornerRadius = 12
  }
  
  @IBAction func choosePhotoAction() {
    model.choosePhoto()
  }
  
  @IBAction func exitButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func editAction() {
    model.switchEditingMode()
    cancelEditButton.isEnabled = true
    didSetAvatar = false
    nameTextField.text = nameLabel.text
    descriptionTextView.text = descriptionLabel.text
    model.handleSaveButtons()
  }
  
  @IBAction func saveAction() {
    endEditing()
    saveButton.isEnabled = false
    cancelEditButton.isEnabled = false
    model.saveChanges()
    model.createSuccessAlert()
  }
  
  @IBAction func cancelEditMode() {
    model.fetchDataOrCreateEntity()
    model.switchEditingMode()
    endEditing()
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    model.handleSaveButtons()
  }
  
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    model.handleSaveButtons()
  }
}
