//
//  ImagePickerManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 23.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//
// Inspired by https://stackoverflow.com

import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let loadPhotosStoryboard = UIStoryboard(name: "LoadPhotos", bundle: Bundle.main)
  
  let alert = UIAlertController(title: "Select a New Avatar", message: nil, preferredStyle: .actionSheet)
  let picker = UIImagePickerController()
  
  var pickImageCallback: ((UIImage) -> Void)?
  weak var viewController: UIViewController?
  
  init(for viewController: UIViewController) {
    self.viewController = viewController
    super.init()
    guard let viewController = self.viewController else { return }
    let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { _ in
      self.openCamera()
    }
    let galleryAction = UIAlertAction(title: "Choose from gallery", style: .default) { _ in
      self.openGallery()
    }
    let loadAction = UIAlertAction(title: "Download", style: .default) { _ in
      self.goToLoadView()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
    picker.delegate = self
    alert.addAction(cameraAction)
    alert.addAction(galleryAction)
    alert.addAction(loadAction)
    alert.addAction(cancelAction)
    alert.popoverPresentationController?.sourceView = viewController.view
  }
  
  func pickImage(_ callback: @escaping ((UIImage) -> Void)) {
    guard let viewController = self.viewController else { return }
    pickImageCallback = callback
    viewController.present(alert, animated: true, completion: nil)
  }
  
  private func goToLoadView() {
    guard let viewController = self.viewController else { return }
    alert.dismiss(animated: true, completion: nil)
    let loadPhotosViewController = loadPhotosStoryboard.instantiateViewController(withIdentifier: "LoadPhotosVC") as? LoadPhotosViewController
    guard let destination = loadPhotosViewController else {
      print("nil destination in \(#function)")
      return
    }
    destination.modalPresentationStyle = .fullScreen
    destination.profileVC = viewController
    viewController.present(destination, animated: true)
  }
  
  private func openCamera() {
    guard let viewController = self.viewController else { return }
    alert.dismiss(animated: true, completion: nil)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
      viewController.present(picker, animated: true, completion: nil)
    } else {
      let warningAlert = UIAlertController(title: "WARNING", message: "You don't have camera", preferredStyle: .alert)
      warningAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
        warningAlert.dismiss(animated: true, completion: nil)
      }))
      viewController.present(warningAlert, animated: true, completion: nil)
    }
  }
  
  private func openGallery() {
    guard let viewController = self.viewController else { return }
    alert.dismiss(animated: true, completion: nil)
    picker.sourceType = .photoLibrary
    viewController.present(picker, animated: true, completion: nil)
  }
  
  internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    pickImageCallback?(image)
  }
}
