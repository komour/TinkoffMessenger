//
//  incomingMessageCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class incomingMessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }    
}
