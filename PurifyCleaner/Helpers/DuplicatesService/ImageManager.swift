//
//  ImageManager.swift
//  ChoosePhoto
//
//  Created by Developer on 09/07/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Photos

enum MediaType {
    case photo
    case video
    case screenshots
}

class ImageManager {
    // MARK: - Properties
    static let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }()
    
    // MARK: - Methods
    class func takeAssetsfor(mediaType: CVarArg, subtypeOfAlbum: PHAssetCollectionSubtype) -> PHFetchResult<PHAsset> {
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType)
        let allCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtypeOfAlbum, options: nil)
        return PHAsset.fetchAssets(in: allCollection.object(at: 0), options: fetchOptions)
    }
    
    class func takeAllDataFromAssetFetchResult(fetchedResult: PHFetchResult<PHAsset>, mediaType: MediaType, completion: @escaping ([ImageObject], Bool) -> Void) {
        var isLast = false
        DispatchQueue.global().async {
            var arrayOfAssets = [ImageObject]() {
                willSet {
                    DispatchQueue.main.async {
                        completion(arrayOfAssets, isLast)
                    }
                }
            }
            fetchedResult.enumerateObjects { (asset, index, _) in
                guard let date = asset.creationDate else { return }
                let localId = asset.localIdentifier
                switch mediaType {
                case .video:
                    let videoOptions = PHVideoRequestOptions()
                    videoOptions.isNetworkAccessAllowed = true
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: videoOptions) { (urlAsset, _, _) in
                        guard let urlAsset = urlAsset as? AVURLAsset else { return;}
                        guard let recourceValues = try? urlAsset.url.resourceValues(forKeys: [.fileSizeKey]), let fileSize = recourceValues.fileSize else { return }
                        let imageObject = ImageObject(localId: localId, size: fileSize, date: date, asset: asset)
                        if fetchedResult.count - 1 == index {
                            isLast = true
                        }
                        arrayOfAssets.append(imageObject)
                    }
                default:
                    let photoOptions = PHImageRequestOptions()
                    photoOptions.isNetworkAccessAllowed = true
                    PHImageManager.default().requestImageData(for: asset, options: photoOptions) { (data, _, _, _) in
                        guard let data = data else { return }
                        let imageObject = ImageObject(localId: localId, size: data.count, date: date, asset: asset)
                        if fetchedResult.count - 1 == index {
                            isLast = true
                        }
                        arrayOfAssets.append(imageObject)
                    }
                }
            }
        }
    }
    
    class func takeAllDataFromArrayOfDuples(array: [[PHAsset]], completion: @escaping ([[ImageObject]]) -> Void) {
        var result = [[ImageObject]]()
        for i in array {
            makeArrayOfImagesFromArrayOfAssets(arrayOfImages: i) {
                result.append($0)
                if result.count == array.count {
                    completion(result)
                }
            }
        }
        
    }

    
    class func makeArrayOfImagesFromArrayOfAssets(arrayOfImages: [PHAsset], completion: @escaping ([ImageObject]) -> Void) {
        let photoOptions = PHImageRequestOptions()
        photoOptions.isNetworkAccessAllowed = true
        
        var kk: [ImageObject] = []
        for i in arrayOfImages {
            PHImageManager.default().requestImageData(for: i, options: photoOptions) { (data, _, _, _) in
                guard let resultData = data?.count else { return }
                kk.append(ImageObject(localId: i.localIdentifier, size: resultData, date: i.creationDate!))
                if kk.count == arrayOfImages.count {
                    completion(kk)
                }
            }
        }
    }
    
    class func takeImageFromAsset(asset: PHAsset, completion: @escaping (UIImage, Int?) -> Void) -> Int {
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            
            let imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: options) { (image, data) in
                guard let image = image else { return }
                completion(image, (data?["PHImageResultRequestIDKey"] as? Int))
            }
            
        return Int(imageRequestID)
    }
    
    class func takeFullImageFromAsset(asset: PHAsset, completion: @escaping (UIImage, Int?) -> Void) -> Int {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            
            let imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: options) { (image, data) in
                guard let image = image else { return }
                completion(image, (data?["PHImageResultRequestIDKey"] as? Int))
            }
            
        return Int(imageRequestID)
    }
    
    class func cancelImageRequest(id: Int) {
        PHImageManager.default().cancelImageRequest(PHImageRequestID(id))
    }
    
    class func takeAssetsFromArrayOfObjects(arrayOfImageObjects: [ImageObject], completion: @escaping (PHAsset) -> Void) {
        let i = arrayOfImageObjects.map { $0.localId }
        
        PHAsset.fetchAssets(withLocalIdentifiers: i, options: fetchOptions).enumerateObjects { (asset, _, _) in
            completion(asset)
        }
    }
    
    class func takeDuplicatesFromCollection(fetchedAsset: PHFetchResult<PHAsset>, completion: @escaping ([[PHAsset]]) -> Void) {
        var array = [PHAsset]()
        var result = [[PHAsset]]()
        
        
        DispatchQueue.global().async {
            fetchedAsset.enumerateObjects { (asset, _, _) in
                array.append(asset)
            }
            
            let arrayChunked = array.chunked(into: 1000)
            
            for arraySlice in arrayChunked {
                result = FindDuplicatesUsingThumbnail.findDuples(assets: arraySlice, strictness: .similar)
                completion(result)
            }
        }
    }
}
