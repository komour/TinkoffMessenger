//
//  UIImage+isEqual.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 15.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

extension UIImage {
  func isEqual(to image: UIImage) -> Bool {
    let data1 = self.jpegData(compressionQuality: 1)
    let data2 = image.jpegData(compressionQuality: 1)
    return data1 == data2
  }
}
