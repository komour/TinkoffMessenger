//
//  ConfigurableViewProtocol.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

protocol ConfigurableView {
  associatedtype ConfigurationModel
  
  func configure(with model: ConfigurationModel)
}
