//
//  CreateChannelViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 20.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class CreateChannelViewController: UIViewController {
  
  lazy var model = CreateChannelModel(for: self)
  
  @IBOutlet weak var newChannelName: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.barTintColor = UIColor(named: "brightYellow")
    let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
    view.addGestureRecognizer(tapEndEditing)
  }
  
  @IBAction func doneAction() {
    endEditing()
    model.doneAction()
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func endEditing() {
    self.view.endEditing(true)
  }
}
