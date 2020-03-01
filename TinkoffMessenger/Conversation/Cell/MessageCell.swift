//
//  incomingMessageCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageLeading: NSLayoutConstraint!
    @IBOutlet weak var messageTrailing: NSLayoutConstraint!
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        if model.isIncoming {
            messageLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            messageLabel.text = "INCOMING: " + model.text
            messageLeading.isActive = true
            messageTrailing.isActive = false
        } else {
            messageLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
            messageLabel.text = "OUTGOING: " + model.text
            messageLeading.isActive = false
            messageTrailing.isActive = true
        }
    }
}


