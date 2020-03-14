//
//  UIView+bindEdgesToSuperview.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func bindEdgesToSuperview() {
    
    guard let superview = superview else {
      preconditionFailure("`superview` is nil in bindEdgesToSuperview")
    }
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
  }
}
