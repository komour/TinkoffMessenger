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
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var imagePicker: ImagePickerManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = ImagePickerManager(for: self)
        
        editButtonOutlet.layer.borderWidth = 1
        editButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        print(editButtonOutlet.frame)
        
        printLog("\(#function)\n")
    }
    
    override func viewDidLayoutSubviews() {
        printLog("\(#function)\n")
        
        let cornerRadius = choosePhotoButtonOutlet.bounds.size.width / 2
        let edgeInset = choosePhotoButtonOutlet.bounds.size.width / 4
        
        avatarImage.layer.cornerRadius = cornerRadius
        choosePhotoButtonOutlet.layer.cornerRadius = cornerRadius
        
        choosePhotoButtonOutlet.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        editButtonOutlet.layer.cornerRadius = editButtonOutlet.bounds.size.width / 25

    }
        
    @IBAction func choosePhotoAction() {
        print("Выбери изображение профиля")
        imagePicker!.pickImage({ image in
            self.avatarImage.image = image
        })
    }
    

}
