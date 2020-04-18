//
//  LoadPhotosViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class LoadPhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  
  private let spacing: CGFloat = 5.0
  
  var cratch = false
  
  var profileVC: UIViewController?
  
  let reusableCellId = "loadReuseId"
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    layout.minimumLineSpacing = 5.0
    layout.minimumInteritemSpacing = 5.0
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.register(LoadPhotosCell.self, forCellWithReuseIdentifier: "loadReuseId")
    return cv
  }()
  
  let photos: [UIImage] = (1...50).map { _ in
    #imageLiteral(resourceName: "placeholder")
  }
  var photoUrls = [PhotoUrl]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(collectionView)
    collectionView.backgroundColor = .white
    collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.reloadData()
    
    loadUrlList { (success) -> Void in
      if success {
        self.cratch = true
        self.collectionView.reloadData()
      } else {
        print(#function)
      }
    }
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  private enum RequestError: Error {
    case networkError
    case wrongUrl
    case parsingError
  }
  
  private func requestUrlList(completion: @escaping(Result<Bool, RequestError>) -> Void) {
    guard let url = URL(string:
      "https://pixabay.com/api/?key=16102464-3d0d1d0025255c01eee47eb3f&q=yellow+flowers&image_type=photo") else {
      completion(.failure(.wrongUrl))
      return
    }
    
    let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
      guard let self = self else { return }
      if let data = data,
        (response as? HTTPURLResponse)?.statusCode == 200,
        error == nil {
        do {
          let decoder = JSONDecoder()
          let urlListResponse = try decoder.decode(UrlListResponse.self, from: data)
          self.photoUrls = urlListResponse.hits
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
  
  private func loadUrlList(completion: @escaping (_ success: Bool) -> Void) {
    requestUrlList { result in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          print(error)
        case .success:
          completion(true)
        }
      }
    }
  }
}

extension LoadPhotosViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photoUrls.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = spacing
    
    let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
    
    let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as? LoadPhotosCell
    guard let cellUnwrapped = cell else {
      return UICollectionViewCell()
    }
    
    cellUnwrapped.layer.borderColor = UIColor.red.cgColor
    cellUnwrapped.layer.borderWidth = 1
    cellUnwrapped.layer.cornerRadius = 5
    
    if indexPath.row % 2 == 0 {
      cellUnwrapped.curImage = photos[indexPath.row]
    }
    
//    if indexPath.row == 0 {
//      cellUnwrapped.loadedPhotoImageView.loadImageUsingUrlString(urlString:
//        "https://pixabay.com/get/55e1d4404953a414f1dc84609629317f153ddae3574c704c7d2879d69f4ec351_640.jpg")
//    }
    if cratch {
    cellUnwrapped.loadedPhotoImageView.loadImageUsingUrlString(urlString: photoUrls[indexPath.row].webformatURL)
    } else {
      cellUnwrapped.curImage = #imageLiteral(resourceName: "placeholder")
    }
    
    return cellUnwrapped
  }
}

extension LoadPhotosViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let vc = profileVC as? ProfileViewController, let curCell = collectionView.cellForItem(at: indexPath) as? LoadPhotosCell else {
      self.dismiss(animated: true, completion: nil)
      return
    }
    vc.didSetAvatar = true
    DispatchQueue.main.async {
      vc.avatarImageView.image = curCell.loadedPhotoImageView.image
      self.dismiss(animated: true, completion: nil)
    }
  }
}

// https://pixabay.com/api/?key=16102464-3d0d1d0025255c01eee47eb3f&q=yellow+flowers&image_type=photo&pre\y=true&per_page=10

// image
// https://pixabay.com/get/55e1d4404953a414f1dc84609629317f153ddae3574c704c7d2879d69f4ec351_640.jpg
