//
//  LoadPhotosViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class LoadPhotosViewController: UIViewController {
  
  private let spacing: CGFloat = 5.0
  
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
  }
  
  @IBAction func cancelAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension LoadPhotosViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photos.count
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
    
    cellUnwrapped.curImage = #imageLiteral(resourceName: "defaultAvatar")
    
    if indexPath.row % 2 == 0 {
      cellUnwrapped.curImage = photos[indexPath.row]
    }
    
    return cellUnwrapped
  }
}

extension LoadPhotosViewController: UICollectionViewDelegateFlowLayout {
  
}
