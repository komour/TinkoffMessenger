//
//  incomingMessageCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    let messageView = UIView()
    let messageLabel = UILabel()
    
    lazy var leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
    lazy var trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(named: "cream")
        addSubview(messageView)
        messageView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.numberOfLines = 0
        messageView.layer.cornerRadius = 12
        
        messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        messageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        messageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        
        messageLabel.leadingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        messageLabel.trailingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.messageView.safeAreaLayoutGuide.bottomAnchor, constant: -4).isActive = true
        messageLabel.topAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        DispatchQueue.main.async {
            if model.isIncoming {
                self.messageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.45)
                self.trailingConstraint.isActive = false
                self.leadingConstraint.isActive = true
            } else {
                self.messageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.55)
                self.leadingConstraint.isActive = false
                self.trailingConstraint.isActive = true
            }
        }
    }
}
