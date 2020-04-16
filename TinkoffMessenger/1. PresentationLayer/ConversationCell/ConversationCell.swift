//
//  ConversationCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 29.02.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
  
  lazy var model = ConversationCellModel(for: self)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  func configure(with curStruct: ConversationCellStruct) {
    model.configure(with: curStruct)
  }
}
