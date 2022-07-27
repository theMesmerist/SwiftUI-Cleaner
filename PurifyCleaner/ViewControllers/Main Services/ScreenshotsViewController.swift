//
//  ScreenshotsViewController.swift
//  Cleaner
//
//  Created by Neon Apps on 20.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import Lottie
import Photos
import UIKit

class ScreenshotsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var counutLabelView: UILabel!
    @IBOutlet var constraint: NSLayoutConstraint!
    
    @IBOutlet var lblItemsSelected: UILabel!
    @IBOutlet var lblRemove: UILabel!
    @IBOutlet var lblCount: UIButton!
    
    var reloadCount = 0
    var deletePopView = UIView()
    let deleteViewImage = UIImageView()
    let deleteViewTitle = UILabel()
    let btnBack = UIButton()
    let cancelButton = UIButton()
    let lblScreenShots = UILabel()
    let deleteBtn = UIButton()
    
    var animationTop = AnimationView()
    var timerCount = 0
    let animationDuration = 10
    
    var isReloadEnabled = true
    
    func deleteAssetes(toDelete: [PHAsset]) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(toDelete as NSArray)
        }) { [self] bool, _ in
            if bool {
                for asset in arrayOfRemoveScreenshots{
                    let index = arrayOfScreenshots!.firstIndex(where: { $0.localId == asset.localId })!
                    arrayOfScreenshots?.remove(at: index)
                }
                DispatchQueue.main.async { [self] in
                    collectionView.reloadData()
                    deleteBtn.isHidden = true
                    btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
                    lblScreenShots.text = "Screenshots"
                }
                
                self.arrayOfRemoveScreenshots = []
                NotificationCenter.default.post(name: Notification.Name("deleteAssets"), object: nil)
            }
        }
    }

    var allScreenShotsArray = [ImageObject]()
    var screenshotAsset: PHFetchResult<PHAsset>?
    var arrayOfRemoveScreenshots: [ImageObject] = []
    var arrayOfScreenshots: [ImageObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultSize(view: view)
        addBg(view: view)
        collectionView.isHidden = true
        ProgressAnimation().createProgressAnimation(view: view, animationDuration: 10, hideView: collectionView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.isReloadEnabled = false
        }
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 35
        layout?.minimumInteritemSpacing = 0
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0.024 * screenWidth, bottom: 0, right: 0.024 * screenWidth)
        layout?.collectionView?.contentSize = CGSize(width: 0.3 * screenWidth, height: 0.4 * screenHeight)
        
        collectionView.backgroundColor = .clear
       
        updateUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        photoLibraryAuthorization(success: { self.takeAssets() }, failed: { fatalError("You need to be authorized") })
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAssets(sender:)), name: Notification.Name("deleteAssets"), object: nil)
        
        if !isFreeUser && !StoreKitOperations().isSubscribed() {
            BannerAdHandler().showBannerAd(VC: self)
        }
    }

    @objc func cancelClicked() {
        arrayOfRemoveScreenshots = []
        arrayOfScreenshots = allScreenShotsArray
        collectionView.reloadData()
    }
    
    @objc func deleteAssets(sender: NSNotification) {
        DispatchQueue.main.async { [self] in
       //     self.dismiss(animated: true)
            deleteBtn.isHidden = true
            btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
            lblScreenShots.text = "Screenshots"
        }
    }
    
    func updateUI() {
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        let background = UIImageView()
        background.image = UIImage(named: "img_bg_all")
        background.frame = CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 1 * screenWidth, height: 1 * screenHeight)
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: UIControl.State.normal)
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
     
        lblScreenShots.text = NSLocalizedString("Screenshots", comment: "")
        lblScreenShots.textAlignment = .center
        lblScreenShots.font = UIFont(name: "Poppins-Medium", size: 15 * stringMultiplier)
        lblScreenShots.frame = CGRect(x: 0.25 * screenWidth, y: 0.12 * screenHeight, width: 0.5 * screenWidth, height: 0.037 * screenHeight)
        lblScreenShots.numberOfLines = 1
        lblScreenShots.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        lblScreenShots.lineBreakMode = .byWordWrapping
        view.addSubview(lblScreenShots)
        lblScreenShots.center.y = btnBack.center.y
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
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
        screenshotAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.image.rawValue, subtypeOfAlbum: .smartAlbumScreenshots)
        takeAssetsDataToModel()
    }
    
    func takeAssetsDataToModel() {
        
        guard let screenshotAsset = screenshotAsset else { return }
        
        ImageManager.takeAllDataFromAssetFetchResult(fetchedResult: screenshotAsset, mediaType: .screenshots) { self.arrayOfScreenshots = $0; if $1 == true {
        
            if self.reloadCount < 3 {
            self.arrayOfScreenshots?.sort(by: { i1, i2 in i1.size > i2.size })
            self.allScreenShotsArray = self.arrayOfScreenshots!
         
            self.reloadCount += 1
            self.collectionView.reloadData()
            }
            self.activityView.isHidden = true
        } }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfScreenshots?.count ?? 0
    }
    
    // Use for
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScreenshotCollectionViewCell
        
        cell.layer.masksToBounds = true
        cell.imageView.frame = cell.bounds
        cell.borderColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        var isAddToRemove = false
        
        if let image = arrayOfScreenshots?[indexPath.row] {
            for addedImg in arrayOfRemoveScreenshots {
                if addedImg.localId == image.localId {
                    isAddToRemove = true
                }
            }
            
            if isAddToRemove {
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
        
        if let image = arrayOfScreenshots?[indexPath.row] {
            for addedImage in arrayOfRemoveScreenshots {
                if addedImage.localId == image.localId {
                    isAddedToRemove = true
                }
            }
            
            if isAddedToRemove {
                let index = arrayOfRemoveScreenshots.firstIndex(where: { $0.localId == image.localId })!
                arrayOfRemoveScreenshots.remove(at: index)
                collectionView.reloadItems(at: [indexPath])
                lblScreenShots.text = "\(arrayOfRemoveScreenshots.count) Screenshots Selected"
            } else {
                arrayOfRemoveScreenshots.append(image)
                collectionView.reloadItems(at: [indexPath])
                deleteBtn.isHidden = false
                btnBack.setBackgroundImage(UIImage(named: "btn_cross_close"), for: .normal)
                btnBack.addTarget(self, action: #selector(cancelClicked), for: UIControl.Event.touchUpInside)
                lblScreenShots.text = "\(arrayOfRemoveScreenshots.count) Screenshots Selected"
            }
        }
        
        if arrayOfRemoveScreenshots.count == 0 {
            deleteBtn.isHidden = true
            btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
            btnBack.addTarget(self, action: #selector(cancelClicked), for: UIControl.Event.touchUpInside)
            lblScreenShots.text = "Screenshots"
        }
    }
    
    @objc func btnBackClicked() {
        if arrayOfRemoveScreenshots.count > 0 {
            btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
            deleteBtn.isHidden = true
            arrayOfRemoveScreenshots = []
            
        } else {
            dismiss(animated: true)
        }
    }

    @objc func proBtnClicked() {
        performSegue(withIdentifier: "screenShotToInApp", sender: nil)
    }

    @objc func deleteButtonClicked() {
        
        
     
        
        deleteAssetes(toDelete: arrayOfRemoveScreenshots.map { $0.asset! })
        deleteViewTitle.text = "Remove \(arrayOfRemoveScreenshots.count) Screenshots From Device"
    }
}

// BURDAN DEVAM ET BOY VEREBİLİRSİN, DİĞER SAYFALARA DA UYARLAYACAĞIZ
extension ScreenshotsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        setDefaultSize(view: view)
        return CGSize(width: 0.3 * screenWidth, height: 0.6 * screenWidth)
    }
}
