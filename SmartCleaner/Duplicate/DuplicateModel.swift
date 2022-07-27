//
//  DuplicateModel.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 7.06.2022.
//

import Foundation
import Photos
import UIKit

struct ImageObject : Hashable {
    
    var localId: String
    var size: Int
    var date: Date
    var asset: PHAsset?
    var image = UIImage()
    var url = URL(string: "")
    var isSelected = false
    
}
