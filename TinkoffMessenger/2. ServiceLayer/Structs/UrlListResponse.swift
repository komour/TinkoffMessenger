//
//  UrlListResponse.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

struct UrlListResponse: Decodable {
    var total: Int
    var totalHits: Int
    var hits: [PhotoUrl]
}

struct PhotoUrl: Decodable {
  var webformatURL: String
}
