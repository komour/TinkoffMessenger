//
//  LoadUrlListProtocol.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 19.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

protocol LoadUrlListProtocol {
  func loadUrlList(completion: @escaping (_ success: Bool) -> Void)
}
