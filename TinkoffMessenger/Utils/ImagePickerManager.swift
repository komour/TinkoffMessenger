//
//  ImagePickerManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 23.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//
// Inspired by https://stackoverflow.com

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let alert = UIAlertController(title: "Select a New Avatar", message: nil, preferredStyle: .actionSheet)
    let picker = UIImagePickerController()
    
    var pickImageCallback : ((UIImage) -> ())?
    var viewController: UIViewController?
    
    init(for viewController: UIViewController) {
        super.init()
        
        self.viewController = viewController
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
    }


    func pickImage(_ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        viewController!.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            viewController!.present(picker, animated: true, completion: nil)
        } else {
            let warningAlert = UIAlertController(title: "WARNING", message: "You don't have camera", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {UIAlertAction in
                warningAlert.dismiss(animated: true, completion: nil)
            }))
            viewController!.present(warningAlert, animated: true, completion: nil)
        }
    }
    
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        viewController!.present(picker, animated: true, completion: nil)
    }


    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
}
