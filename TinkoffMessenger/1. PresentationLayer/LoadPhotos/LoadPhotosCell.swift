//
//  LoadPhotosCellCollectionViewCell.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 18.04.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

class LoadPhotosCell: UICollectionViewCell {
  
  var curImage: UIImage = #imageLiteral(resourceName: "placeholder") {
    didSet {
      bg.image = curImage
    }
  }
  
  fileprivate let bg: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "placeholder")
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(bg)
    bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
