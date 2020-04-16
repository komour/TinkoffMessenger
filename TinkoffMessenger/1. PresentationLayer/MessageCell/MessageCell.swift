//
//  incomingMessageCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
  
  lazy var model = MessageCellModel(for: self)
  
  let messageView = UIView()
  let messageLabel = UILabel()
  let dateLabel = UILabel()
  let senderLabel = UILabel()
  
  lazy var leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
  lazy var trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = UIColor(named: "cream")
    addSubview(messageView)
    messageView.addSubview(messageLabel)
    messageView.addSubview(dateLabel)
    messageView.addSubview(senderLabel)
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageView.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    senderLabel.translatesAutoresizingMaskIntoConstraints = false
    
    senderLabel.numberOfLines = 1
    senderLabel.textColor = .black
    
    dateLabel.numberOfLines = 1
    dateLabel.textColor = .black
    
    messageLabel.numberOfLines = 0
    messageView.layer.cornerRadius = 12
    
    messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    messageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
    messageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    
    messageLabel.leadingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
    messageLabel.trailingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    messageLabel.bottomAnchor.constraint(equalTo: self.messageView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    messageLabel.topAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
    
    senderLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749.0), for: .horizontal)
    senderLabel.leadingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
    senderLabel.bottomAnchor.constraint(equalTo: self.messageView.safeAreaLayoutGuide.bottomAnchor, constant: -4).isActive = true
    senderLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.dateLabel.safeAreaLayoutGuide.leadingAnchor, constant: -10).isActive = true
    
    dateLabel.trailingAnchor.constraint(equalTo: messageView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true

    dateLabel.bottomAnchor.constraint(equalTo: self.messageView.safeAreaLayoutGuide.bottomAnchor, constant: -4).isActive = true
    
  }
  
  func configure(with curStruct: MessageCellStruct) {
    let dateFormatter = model.getDateFormatter(with: curStruct)
    dateLabel.text = dateFormatter.string(from: curStruct.date)
    messageLabel.text = curStruct.text
    senderLabel.text = curStruct.sender
    model.adjustWithIncomingType(isIncoming: curStruct.isIncoming)
  }
}
