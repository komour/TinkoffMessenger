//
//  incomingMessageCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageLeading: NSLayoutConstraint!
    @IBOutlet weak var messageTrailing: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        DispatchQueue.main.async {
            self.messageView.layer.cornerRadius = 12
            if model.isIncoming {
                self.messageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                self.messageLabel.text = "INCOMING: " + model.text
                self.messageLeading.isActive = true
                self.messageTrailing.isActive = false
            } else {
                self.messageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                self.messageLabel.text = "OUTGOING: " + model.text
                self.messageLeading.isActive = false
                self.messageTrailing.isActive = true
            }
        }
    }
}
