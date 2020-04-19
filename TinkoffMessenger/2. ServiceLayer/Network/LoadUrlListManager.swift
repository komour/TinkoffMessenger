//
//  LoadUrlListManager.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 19.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation

class LoadUrlListManager: LoadUrlListProtocol {
  
  var viewController: LoadPhotosViewController?
  
  private let apiKey = "16102464-3d0d1d0025255c01eee47eb3f"
  private let imagePerPage = 150
  
  init (for viewController: LoadPhotosViewController) {
    self.viewController = viewController
  }
  
  private enum RequestError: Error {
    case networkError
    case wrongUrl
    case parsingError
  }
  
  private func requestUrlList(completion: @escaping(Result<Bool, RequestError>) -> Void) {
    guard let vc = viewController else {
      print("nil LoadPhotosVC in \(#function)")
      return
    }
    guard let url = URL(string:
      "https://pixabay.com/api/?key=\(apiKey)&image_type=photo&per_page=\(imagePerPage)") else {
        completion(.failure(.wrongUrl))
        return
    }
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let data = data,
        (response as? HTTPURLResponse)?.statusCode == 200,
        error == nil {
        do {
          let urlListResponse = try JSONDecoder().decode(UrlListResponse.self, from: data)
          vc.photoUrls = urlListResponse.hits
          completion(.success(true))
        } catch let parsingError {
          completion(.failure(.parsingError))
          print("Error", parsingError)
        }
      } else {
        completion(.failure(.networkError))
        print("Network error")
      }
    }
    dataTask.resume()
  }
  
  func loadUrlList(completion: @escaping (_ success: Bool) -> Void) {
    requestUrlList { result in
      switch result {
      case .failure(let error):
        print(error)
      case .success:
        completion(true)
      }
    }
  }
}
