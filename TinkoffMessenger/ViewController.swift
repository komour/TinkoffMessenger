//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var choosePhotoButtonOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var imagePicker: ImagePickerManager?
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        print(editButtonOutlet.frame)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
//        print(editButtonOutlet.frame)
//        В editButtonOutlet лежит nil, т.к. к моменту вызова инициализатора IBOutlet'ы еще не назначены
        
        super.init(coder: coder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        printLog("\(#function)\n")
    }
    
    
    override func loadView() {
        super.loadView()
        
        printLog("\(#function)\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = ImagePickerManager(for: self)
        
        editButtonOutlet.layer.borderWidth = 1
        editButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        print(editButtonOutlet.frame)
        
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
        
        let cornerRadius = choosePhotoButtonOutlet.bounds.size.width / 2
        let edgeInset = choosePhotoButtonOutlet.bounds.size.width / 4
        
        avatarImage.layer.cornerRadius = cornerRadius
        choosePhotoButtonOutlet.layer.cornerRadius = cornerRadius
        
        choosePhotoButtonOutlet.imageEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        editButtonOutlet.layer.cornerRadius = editButtonOutlet.bounds.size.width / 25

    }
    
    override func updateViewConstraints() {
        printLog("\(#function)\n")
        
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(editButtonOutlet.frame)
        // frame отличается, т.к. метод viewDidLoad вызывается до завершения Auto Layout'a,
        // а метод viewDidAppear - после
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
        imagePicker!.pickImage({ image in
            self.avatarImage.image = image
        })
    }
    

}

