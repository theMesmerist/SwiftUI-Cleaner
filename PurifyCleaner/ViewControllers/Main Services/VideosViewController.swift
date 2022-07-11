//
//  VideosViewController.swift
//  Cleaner
//
//  Created by Neon Apps on 22.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import Lottie
import Photos
import UIKit

class VideosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var counutLabelView: UILabel!
    @IBOutlet var constraint: NSLayoutConstraint!
    let imageBlurred = UIImageView()
    
    let deleteViewTitle = UILabel()
    var reloadCount = 0
    var percentLabel = UILabel()
    var isSelectionStart = false
    let lblVideoFiles = UILabel()
    let deleteBtn = UIButton()
    let btnBack = UIButton()
    
    func deleteAssetes(toDelete: [PHAsset]) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(toDelete as NSArray)
        }) { [self] bool, _ in
            if bool {
                
                for addedImage in arrayOfRemoveVideos {
                    
                    if ((arrayOfVideos?.contains(where: {$0.localId == addedImage.localId})) != nil){
                        let index = arrayOfVideos!.firstIndex(where: { $0.localId == addedImage.localId })!
                        arrayOfVideos?.remove(at: index)
                        DispatchQueue.main.async { [self] in
                            self.collectionView.reloadData()
                            deleteBtn.isHidden = true
                            btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
                            btnBack.addTarget(self, action: #selector(cancelClicked), for: UIControl.Event.touchUpInside)
                            lblVideoFiles.text = "Video Files"
                        }
                    }
                }
                
                
                self.arrayOfRemoveVideos = []
           
            }
        }
    }

    var VideoAsset: PHFetchResult<PHAsset>?
    var arrayOfRemoveVideos: [ImageObject] = []
    var arrayOfVideos: [ImageObject]? {
        didSet {
            if VideoAsset?.count ?? 0 == arrayOfVideos?.count ?? 0 {
                arrayOfVideos?.sort(by: { i1, i2 in i1.size > i2.size })
                collectionView.reloadData()
                activityView.isHidden = true
            }
        }
    }

    var allVideosArray = [ImageObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        collectionView.isHidden = true
        ProgressAnimation().createProgressAnimation(view: view, animationDuration: 15, hideView: collectionView)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 20
        layout?.minimumInteritemSpacing = 0
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0.024 * screenWidth, bottom: 0, right: 0.024 * screenWidth)
        layout?.collectionView?.contentSize = CGSize(width: 0.3 * screenWidth, height: 0.4 * screenHeight)
        
        updateUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        collectionView.backgroundColor = .clear
        
        photoLibraryAuthorization(success: { self.takeAssets() }, failed: { fatalError("You need to be authorized") })
        if !isFreeUser && !StoreKitOperations().isSubscribed() {
            BannerAdHandler().showBannerAd(VC: self)
        }
    }
    
    @objc func cancelClicked() {
        arrayOfRemoveVideos = []
        deleteBtn.isHidden = true
        lblVideoFiles.text = "Video Files"
        arrayOfVideos = allVideosArray
        collectionView.reloadData()
//        UIView.animate(withDuration: 0.2) {
//            self.deletePopView.frame = CGRect(x: 0 * screenWidth, y: 1 * screenHeight, width: 1 * screenWidth, height: 0.25 * screenHeight)
//        }
        
        btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
    }
    
    func updateUI() {
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
        btnBack.frame = CGRect(x: 0.05 * screenWidth, y: 0.105 * screenHeight, width: 0.115 * screenWidth, height: 0.05 * screenHeight)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(btnBack)
        btnBack.adapt_width_to_SH()
        btnBack.adapt_y_to_SW()
        
        deleteBtn.setBackgroundImage(UIImage(named: "btn_thrashUI"), for: .normal)
        deleteBtn.frame = CGRect(x: 0.85 * screenWidth, y: 0.11 * screenHeight, width: 0.06 * screenWidth, height: 0.03 * screenHeight)
        deleteBtn.isHidden = true
        view.addSubview(deleteBtn)
        deleteBtn.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
       
        lblVideoFiles.text = NSLocalizedString("Video Files", comment: "")
        lblVideoFiles.textAlignment = .center
        lblVideoFiles.font = UIFont(name: "Graphie-SemiBold", size: 20 * stringMultiplier)
        lblVideoFiles.frame = CGRect(x: 0.3 * screenWidth, y: 0.12 * screenHeight, width: 0.4 * screenWidth, height: 0.037 * screenHeight)
        lblVideoFiles.numberOfLines = 1
        lblVideoFiles.textColor = .black
        lblVideoFiles.lineBreakMode = .byWordWrapping
        view.addSubview(lblVideoFiles)
        lblVideoFiles.adapt_y_to_SW()
        lblVideoFiles.center.y = btnBack.center.y
    }
    
    func photoLibraryAuthorization(success: @escaping () -> Void, failed: @escaping () -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            success()
        case .denied:
            failed()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async { success() }
                } else {
                    DispatchQueue.main.async { failed() }
                }
            }
        case .restricted:
            failed()
        default:
            failed()
        }
    }
    
    func takeAssets() {
        VideoAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.video.rawValue, subtypeOfAlbum: .smartAlbumVideos)
        takeAssetsDataToModel()
    }
    
    func takeAssetsDataToModel() {
        guard let VideoAsset = VideoAsset else { return }
        ImageManager.takeAllDataFromAssetFetchResult(fetchedResult: VideoAsset, mediaType: .video) { [self] in self.arrayOfVideos = $0; if $1 == true {
            if self.reloadCount < 3{
            self.arrayOfVideos?.sort(by: { i1, i2 in i1.size > i2.size })
            self.allVideosArray = self.arrayOfVideos!
          
            self.collectionView.reloadData()
            reloadCount += 1
           }
            self.activityView.isHidden = true
        } }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfVideos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionViewCell
       
        cell.imageView.frame = cell.bounds
        cell.borderWidth = 0
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 3
        cell.backgroundColor = .clear
        cell.borderColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        var isAddedToRemove = false
        
        if let image = arrayOfVideos?[indexPath.row] {
            for addedImage in arrayOfRemoveVideos {
                if addedImage.localId == image.localId {
                    isAddedToRemove = true
                }
            }
            
            if isAddedToRemove {
                cell.borderWidth = 5
                
            } else {
                cell.borderWidth = 0
            }
            
            cell.photoAsset = image
            cell.reload()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isAddedToRemove = false
        
        if let image = arrayOfVideos?[indexPath.row] {
            for addedImage in arrayOfRemoveVideos {
                if addedImage.localId == image.localId {
                    isAddedToRemove = true
                }
            }
            
            if isAddedToRemove {
                let index = arrayOfRemoveVideos.firstIndex(where: { $0.localId == image.localId })!
                arrayOfRemoveVideos.remove(at: index)
                collectionView.reloadItems(at: [indexPath])
                lblVideoFiles.text = "\(arrayOfRemoveVideos.count) Videos Selected"
                deleteViewTitle.text = "Remove \(arrayOfRemoveVideos.count) Videos From Device"
            } else {
                arrayOfRemoveVideos.append(image)
                collectionView.reloadItems(at: [indexPath])
                deleteBtn.isHidden = false
                btnBack.setBackgroundImage(UIImage(named: "btn_cross_close"), for: .normal)
                btnBack.addTarget(self, action: #selector(cancelClicked), for: UIControl.Event.touchUpInside)
                lblVideoFiles.text = "\(arrayOfRemoveVideos.count) Videos Selected"
                deleteViewTitle.text = "Remove \(arrayOfRemoveVideos.count) Videos From Device"
            }
        }
        
        if arrayOfRemoveVideos.count == 0 {
            deleteBtn.isHidden = true
            btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
            btnBack.addTarget(self, action: #selector(cancelClicked), for: UIControl.Event.touchUpInside)
            lblVideoFiles.text = "Video Files"
        }
    }
    
    @objc func btnBackClicked() {
        if arrayOfRemoveVideos.count > 0 {
            btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
        } else {
            dismiss(animated: true)
        }
    }

    @objc func proBtnClicked() {
        performSegue(withIdentifier: "VideosToInApp", sender: nil)
    }

    @objc func deleteButtonClicked() {
        deleteAssetes(toDelete: arrayOfRemoveVideos.map { $0.asset! })
        
        
        
    
}
}

extension VideosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        setDefaultSize(view: view)
        return CGSize(width: 0.3 * screenWidth, height: 0.6 * screenWidth)
    }
}
