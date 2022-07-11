//
//  ScreenshotCollectionViewCell.swift
//  Cleaner
//
//  Created by Neon Apps on 20.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import UIKit
import Photos

class ScreenshotCollectionViewCell: UICollectionViewCell {
    var currentId = 0
    var showedId = ""
    
    @IBOutlet weak var imageView: UIImageView!
    var labelView = UILabel()
   
    
    var photoAsset: ImageObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reload() {
        contentView.addSubview(labelView)
        if let asset = photoAsset?.asset {
            if showedId != asset.localIdentifier {
                currentId = ImageManager.takeImageFromAsset(asset: asset, completion: { photo, id in
                    DispatchQueue.main.async {
                        if id == self.currentId {
                            self.imageView.image = photo
                            self.showedId = asset.localIdentifier
                        }
                    }
                })
            }
        }
    }
    
    override func prepareForReuse() {
        ImageManager.cancelImageRequest(id: currentId)
    }
}
