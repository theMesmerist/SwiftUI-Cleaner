//
//  CollectionViewCell.swift
//  Cleaner
//
//  Created by Uzay Altıner on 24.06.2022.
//  Copyright © 2022 voronoff. All rights reserved.
//

import Foundation
import Photos
import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    var currentId = 0
    var showedId = ""
    
    @IBOutlet var imageView: UIImageView!
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
                            self.labelView.text = Formatter.humanReadableByteCount(bytes: self.photoAsset?.size ?? 0)
                            self.labelView.font = UIFont(name: "Poppins-Medium", size: 14 * stringMultiplier)
                            self.labelView.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                            self.labelView.frame = CGRect(x: screenWidth * 0.1, y: screenHeight * 0.23, width: screenWidth * 0.3, height: screenHeight * 0.05)
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
