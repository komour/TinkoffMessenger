//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var avatarUIImage: UIImageView!
    @IBOutlet weak var choosePhotoUIButton: UIButton!
    @IBOutlet weak var editUIButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        printLog("\(#function)\n")
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        printLog("\(#function)\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editUIButton.layer.borderWidth = 1
        editUIButton.layer.borderColor = UIColor.black.cgColor
        
        printLog("\(#function)\n")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        printLog("\(#function)\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        printLog("\(#function)\n")
    }
    
    override func viewWillLayoutSubviews() {
        printLog("\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        printLog("\(#function)\n")
        
        let cornerRadius = choosePhotoUIButton.bounds.size.width / 2
        let edgeInset = choosePhotoUIButton.bounds.size.width / 4
        
        avatarUIImage.layer.cornerRadius = cornerRadius
        choosePhotoUIButton.layer.cornerRadius = cornerRadius
        
        choosePhotoUIButton.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        editUIButton.layer.cornerRadius = editUIButton.bounds.size.width / 25

    }
    
    override func updateViewConstraints() {
        printLog("\(#function)\n")
        
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        printLog("\(#function)\n")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        printLog("\(#function)\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        printLog("\(#function)\n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        printLog("\(#function)\n")
    }
    
    
    @IBAction func choosePhotoAction() {
        print("Выбери изображение профиля")
    }
    

}

