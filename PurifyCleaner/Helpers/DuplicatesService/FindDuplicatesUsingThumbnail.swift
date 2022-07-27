//
//  Method.swift
//  ChoosePhoto
//
//  Created by Developer on 08/07/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import CocoaImageHashing
import Photos

extension PHAsset {
    
    var thumbnailSync: UIImage? {
        var result: UIImage?
        let targetSize = CGSize(width: 300, height: 300)
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: self, targetSize: targetSize, contentMode: .default, options: options) { (image, info) in
            result = image
        }
        return result
    }
}

class FindDuplicatesUsingThumbnail {
    
    enum Strictness {
        case similar
        case closeToIdentical
    }
    
    class func findDuples(assets: [PHAsset], strictness: Strictness) -> [[PHAsset]] {
        
        let providerId = OSImageHashingProviderIdForHashingQuality(.high)
        let provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
        let defaultHashDistanceTreshold: Int64 = 4
        let hashDistanceTreshold: Int64
        
        switch strictness {
            case .similar: hashDistanceTreshold = defaultHashDistanceTreshold
            case .closeToIdentical: hashDistanceTreshold = 1
        }
        
        let rawTuples: [OSTuple<NSString, NSData>] = assets.enumerated().map { (index, asset) -> OSTuple<NSString, NSData> in
            let imageData = asset.thumbnailSync?.pngData()
            return OSTuple<NSString, NSData>.init(first: "\(index)" as NSString, andSecond: imageData as NSData?)
        }
        
        let toCheckTuples = rawTuples.filter({ $0.second != nil })
        
        let similarImageIdsAsTuples = OSImageHashing.sharedInstance().similarImages(withProvider: providerId, withHashDistanceThreshold: hashDistanceTreshold, forImages: toCheckTuples)
        var duplicateGroups = [[PHAsset]]()
        var assetToGroupIndex = [PHAsset: Int]()
        for pair in similarImageIdsAsTuples {
            let assetIndex1 = Int(pair.first! as String)!
            let assetIndex2 = Int(pair.second! as String)!
            let asset1 = assets[assetIndex1]
            let asset2 = assets[assetIndex2]
            let groupIndex1 = assetToGroupIndex[asset1]
            let groupIndex2 = assetToGroupIndex[asset2]
            if groupIndex1 == nil && groupIndex2 == nil {
                
                duplicateGroups.append([asset1, asset2])
                let groupIndex = duplicateGroups.count - 1
                assetToGroupIndex[asset1] = groupIndex
                assetToGroupIndex[asset2] = groupIndex
            } else if groupIndex1 == nil && groupIndex2 != nil {
                
                duplicateGroups[groupIndex2!].append(asset1)
                assetToGroupIndex[asset1] = groupIndex2!
            } else if groupIndex1 != nil && groupIndex2 == nil {
                
                duplicateGroups[groupIndex1!].append(asset2)
                assetToGroupIndex[asset2] = groupIndex1!
            }
        }
        return duplicateGroups
    }
}

