//
//  ViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 16.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        printLog("\(#function)\n")
    }
    
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
    

}

