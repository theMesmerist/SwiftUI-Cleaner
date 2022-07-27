//
//  Functions.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 7.06.2022.
//

import Foundation
import Photos
import UIKit

var reloadCount = 0
var duplicates: [[PHAsset]]?
var assetsToDelete = [PHAsset]()
var photoAsset: PHFetchResult<PHAsset>?
var videoAsset: PHFetchResult<PHAsset>?
var screenshotAsset: PHFetchResult<PHAsset>?
var duplicateImg = [DuplicateGroup]()
var arrDuplicateImageGroups = [[UIImage]]()

func photoLibraryAuthorization(success: @escaping () -> Void, failed: @escaping () -> Void) {
    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
        success()
    case .denied:
        failed()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
                DispatchQueue.main.async { success() }
            } else {
                DispatchQueue.main.async { failed() }
            }
        })
    case .restricted:
        failed()
    default:
        failed()
    }
}

func takeAssets() {
    photoAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.image.rawValue, subtypeOfAlbum: .smartAlbumUserLibrary)
    videoAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.video.rawValue, subtypeOfAlbum: .smartAlbumVideos)
    screenshotAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.image.rawValue, subtypeOfAlbum: .smartAlbumScreenshots)
    takeAssetsDataToModel()
}

func takeAssetsDataToModel() {
    guard let photoAsset = photoAsset else { return }
    duplicates = []
    arrDuplicateImageGroups = []
    ImageManager.takeDuplicatesFromCollection(fetchedAsset: photoAsset, completion: { dupl in
        duplicates?.append(contentsOf: dupl)
        for duplicate in duplicates!{
            DispatchQueue.main.async {
                arrDuplicateImageGroups.append( getUIImage(assets: duplicate)!)
            }
         
            
            
        }
        
        
     
  
        
        for arrDuplicateImageGroups in arrDuplicateImageGroups{
            
            print("**************")
            
            for image in arrDuplicateImageGroups {
                print(image)
            }
        }
        
       /*
        for duplicate in duplicates ?? [[]]{
            let imageArr = getUIImage(assets: duplicate)
            
            let dupModel = DuplicateGroup()
            dupModel.image = imageArr![0]
            dupModel.imageArr = imageArr!
            
            print(dupModel)
            
            if duplicates != [[]]{
                duplicateImg.append(dupModel)
                print(dupModel)
                print(duplicateImg)
            }
          
            
            
        }
*/
    })
    
    
    
}

func getUIImage(assets: [PHAsset]) -> [UIImage]? {
    var imageArr = [UIImage]()
    var img: UIImage?
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.version = .original
    options.isSynchronous = true
    for asset in assets {
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
                imageArr.append(img!)
            }
        }
    }

    return imageArr
}


