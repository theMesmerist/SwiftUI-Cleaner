//
//  Screenshot.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 14.06.2022.
//

import Foundation
import SwiftUI
import Photos

class ScreenshotModel: ObservableObject {
    @Published var errorString = String()

    init() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.errorString = ""
              
            case .denied, .restricted:
                self.errorString = "Photo access permission denied"
            case .notDetermined:
                self.errorString = "Photo access permission not determined"
            @unknown default:
                fatalError()
            }
        }
    }

    public func getAllPhotos() {
        
        
        var count = 0
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoScreenshot.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700) //You can change size here
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    
                    count += 1
                    if let image = image {
                      
//                        DispatchQueue.main.async {
                            asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
                              if let input = eidtingInput, let imgURL = input.fullSizeImageURL {
                                 // imgURL
                                  var imgUrl = URL(string: "a")
                                  imgUrl = imgURL
                                  guard let date = asset.creationDate else { return }
                                  let localId = asset.localIdentifier
                                  let strSize = NSCoder.string(for: image.size)
                                  let intSize = Int(strSize)
                                 
                                  
                                 
                                  let imgObj = ImageObject(localId: localId, size: intSize ?? 0, date: date, asset: asset, image: image, url: imgUrl)
                                  if allScreenshot.contains(where: {$0.url == imgObj.url}){
                                      print("already added")
                                  } else{
                                      allScreenshot.append(imgObj)
                                      print("Success : \(count)")
                                      print("Success : \(imgUrl!)")
                                      
                                      print(imgUrl!)
                                  }
                                 
                              }
                            }
                      
                    } else {
                        print("Fail : \(count)")
                       // print("error asset to image")
                    }
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "screenshotPressed"), object: nil, userInfo: nil) 
        } else {
            self.errorString = "No photos to display"
        }
        
     
    }
}
