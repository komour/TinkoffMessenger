//
//  UIImageView+Load.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImageUsingUrlString(urlString: String) {
    let url = URL(string: urlString)
    
    image = UIImage(named: "placeholder")
    
    guard let urlUnwrapped = url else {
      print("nil url in \(#function)")
      return
    }
    URLSession.shared.dataTask(with: urlUnwrapped, completionHandler: { (data, _, error) in
      
      if let error = error {
        print(error)
        return
      }
      
      guard let dataUnwrapped = data else {
        print("nil data in \(#function)")
        return
      }
      
      DispatchQueue.main.async {
        self.image = UIImage(data: dataUnwrapped)
      }
      }).resume()
  }
}
