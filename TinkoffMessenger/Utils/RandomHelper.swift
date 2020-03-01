//
//  RandomHelper.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 01.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

func randomString(length: Int) -> String {
  let letters = "abcdefghijkl mnopqrstuvwxyz ABCDEFGHIJKLMN OPQRSTUVWXYZ 0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
