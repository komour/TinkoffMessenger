//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var choosePhotoButtonOutlet: UIButton!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var imagePicker: ImagePickerManager?
  
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
  }
  
  private func switchEditingMode() {
    nameLabel.isHidden = !nameLabel.isHidden
    descriptionLabel.isHidden = !descriptionLabel.isHidden
    nameTextField.isHidden = !nameTextField.isHidden
    descriptionTextView.isHidden = !descriptionTextView.isHidden
    stackView.isHidden = !stackView.isHidden
    editButton.isHidden = !editButton.isHidden
  }
  
  deinit {
    removeKeyboardNotifications()
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
  
  override func viewDidLayoutSubviews() {
    let cornerRadius = choosePhotoButtonOutlet.bounds.size.width / 2
    let edgeInset = choosePhotoButtonOutlet.bounds.size.width / 4
    
    avatarImage.layer.cornerRadius = cornerRadius
    choosePhotoButtonOutlet.layer.cornerRadius = cornerRadius
    
    choosePhotoButtonOutlet.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
    
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
    imagePicker.pickImage({ image in
      self.avatarImage.image = image
    })
  }
  
  @IBAction func exitButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func editAction() {
    switchEditingMode()
    
    nameTextField.text = nameLabel.text
    descriptionTextView.text = descriptionLabel.text
  }
  
  @IBAction func operationAction() {
    nameLabel.text = nameTextField.text
    descriptionLabel.text = descriptionTextView.text
    activityIndicator.startAnimating()
    saveDataWithOperation()
  }
  
  @IBAction func gcdAction() {
    nameLabel.text = nameTextField.text
    descriptionLabel.text = descriptionTextView.text
    activityIndicator.startAnimating()
    saveDataWithGcd()
  }
  
  private func saveDataWithGcd() {
    // on completion
    createErrorAlert()
    activityIndicator.stopAnimating()
  }
  
  private func saveDataWithOperation() {
    // on completion
    createSuccessAlert()
    activityIndicator.stopAnimating()
  }
  
  func createSuccessAlert() {
    let alert = UIAlertController(title: "Success!", message: "Data has been successfully changed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      self?.switchEditingMode()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func createErrorAlert() {
    let alert = UIAlertController(title: "Error!", message: "An error has occurred while saving the new data.", preferredStyle: .alert)
    // just let user to try to save again
    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] _ in
      alert.dismiss(animated: true, completion: nil)
      self?.switchEditingMode()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
}
