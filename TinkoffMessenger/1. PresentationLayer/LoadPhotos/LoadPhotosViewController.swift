//
//  LoadPhotosViewController.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class LoadPhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  
  lazy var loadUrlListManager: LoadUrlListProtocol = LoadUrlListManager(for: self)
  
  private let spacing: CGFloat = 5.0
  var urlListHasBeenLoaded = false
  var photoUrls = [PhotoUrl]()
  
  weak var profileVC: UIViewController?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView.backgroundColor = .white
    collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

    collectionView.isHidden = true

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.reloadData()

    DispatchQueue.global(qos: .default).async {
      self.loadUrlList()
    }
  }
  
    func loadUrlList() {
      DispatchQueue.main.async {
        self.activityIndicator.startAnimating()
      }
      loadUrlListManager.loadUrlList { (success) -> Void in
        if success {
          DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.urlListHasBeenLoaded = true
            self.collectionView.reloadData()
          }
        } else {
          print(#function)
        }
      }
    }
    
  @IBAction func cancelAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDataSource

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
    if urlListHasBeenLoaded {
    cellUnwrapped.loadedPhotoImageView.loadImageUsingUrlString(urlString: photoUrls[indexPath.row].webformatURL)
    } else {
      cellUnwrapped.curImage = #imageLiteral(resourceName: "placeholder")
    }
    
    return cellUnwrapped
  }
}

// MARK: - UICollectionViewDelegate

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
