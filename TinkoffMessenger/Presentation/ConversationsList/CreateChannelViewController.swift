//
//  CreateChannelViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 20.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class CreateChannelViewController: UIViewController {
  @IBAction func dismissAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func doneAction() {
  }
  
  @IBAction func cancelAction(_ sender: Any) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
}
