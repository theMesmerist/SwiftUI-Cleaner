//
//  DuplicatePhotosViewController.swift
//  Cleaner
//
//  Created by Neon Apps on 19.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import GoogleMobileAds
import Lottie
import Photos

import UIKit

class DuplicatePhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DublicatesTableViewCellDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var photoAsset: PHFetchResult<PHAsset>?
    var videoAsset: PHFetchResult<PHAsset>?
    var screenshotAsset: PHFetchResult<PHAsset>?
    
    var reloadCount = 0
    let lblDuplicate = UILabel()
    
    let deletePopView = UIView()
 
    var assetsToDelete = [PHAsset]()
    
    var arrayOfVideos: [ImageObject]? {
        willSet {
            //
        }
    }

    var arrayOfScreenshots: [ImageObject]? {
        willSet {
            //
        }
    }

    var duplicates: [[PHAsset]]?
    
    var animationTop = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setDefaultSize(view: view)
        
        tableView.isHidden = true
        
        ProgressAnimation().createProgressAnimation(view: view, animationDuration: 10, hideView: tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelClicked))
        tapGesture.cancelsTouchesInView = false
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tapGesture)
        
        tableView.dataSource = self
        tableView.delegate = self
        photoLibraryAuthorization(success: { self.takeAssets() }, failed: { fatalError("You need to be authorized") })
        tableView.frame = CGRect(x: 0, y: 0.2 * screenHeight, width: screenWidth, height: 0.8 * screenHeight)
        
        if !isFreeUser && !StoreKitOperations().isSubscribed() {
            BannerAdHandler().showBannerAd(VC: self)
        }
    }
    
    func updateUI() {
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        let holderView = UIView()
        holderView.backgroundColor = .white
        holderView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.2)
        view.addSubview(holderView)
        
        let btnBack = UIButton()
        btnBack.setBackgroundImage(UIImage(named: "btn_backUI"), for: UIControl.State.normal)
        btnBack.frame = CGRect(x: 0.05 * screenWidth, y: 0.114 * screenHeight, width: 0.115 * screenWidth, height: 0.05 * screenHeight)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(btnBack)
        btnBack.adapt_width_to_SH()
        btnBack.adapt_y_to_SW()
        
        lblDuplicate.text = NSLocalizedString("Duplicates", comment: "")
        lblDuplicate.textAlignment = .center
        lblDuplicate.font = UIFont(name: "Graphie-SemiBold", size: 20 * stringMultiplier)
        lblDuplicate.frame = CGRect(x: 0.35 * screenWidth, y: 0.12 * screenHeight, width: 0.3 * screenWidth, height: 0.037 * screenHeight)
        lblDuplicate.numberOfLines = 1
        lblDuplicate.textColor = .black
        lblDuplicate.lineBreakMode = .byWordWrapping
        view.addSubview(lblDuplicate)
        lblDuplicate.center.y = btnBack.center.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelClicked), name: Notification.Name("ClosePopup"), object: nil)
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
        photoAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.image.rawValue, subtypeOfAlbum: .smartAlbumUserLibrary)
        videoAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.video.rawValue, subtypeOfAlbum: .smartAlbumVideos)
        screenshotAsset = ImageManager.takeAssetsfor(mediaType: PHAssetMediaType.image.rawValue, subtypeOfAlbum: .smartAlbumScreenshots)
        
        takeAssetsDataToModel()
    }
    
    func takeAssetsDataToModel() {
        guard let photoAsset = photoAsset else { return }
        
        duplicates = []
        activityIndicator.isHidden = false
        
        ImageManager.takeDuplicatesFromCollection(fetchedAsset: photoAsset, completion: { dupl in
          
            DispatchQueue.main.async {
                self.duplicates?.append(contentsOf: dupl)
                if self.reloadCount < 3 {
                    self.reloadCount += 1
                    self.tableView.reloadData()
             
                
                self.activityIndicator.isHidden = true
                self.statusLabel.text = "FOUND \(self.duplicates?.count ?? 0) DUPLICATES"
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duplicates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DublicatesTableViewCell
        ImageManager.cancelImageRequest(id: cell.currentId)
        cell.reload(duplicates: duplicates![indexPath.row])
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.borderWidth = 0
        cell.previewImageView.cornerRadiusSize = 0
        return cell
    }
    
    func deleteAssetes(toDelete: [PHAsset]) {
        assetsToDelete = toDelete
        deleteButtonClicked()
    }
    
    @objc func deleteButtonClicked() {
        PHPhotoLibrary.shared().performChanges({ [self] in
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }) { [self] bool, _ in
            if bool {
                if let duplicates = self.duplicates {
                    for (indexOfPhotoSet, smilarPhotoSet) in duplicates.enumerated() {
                        if smilarPhotoSet.contains(assetsToDelete.first!) {
//                      self.duplicates?.remove(at: indexi)
                    
                            if self.duplicates![indexOfPhotoSet].count == 1 {
                                self.duplicates?.remove(at: indexOfPhotoSet)
                            
                            } else {
                                if let index = smilarPhotoSet.firstIndex(of: assetsToDelete[0]) {
                                    self.duplicates?[indexOfPhotoSet].remove(at: index)
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.statusLabel.text = "FOUND \(self.duplicates?.count ?? 0) DUPLICATES"
                    
                    UIView.animate(withDuration: 0.5) {
                        assetsToDelete = []
                        self.deletePopView.frame = CGRect(x: 0.1 * screenWidth, y: 1 * screenHeight, width: 0.8 * screenWidth, height: 0.3 * screenHeight)
                    }
                }
            }
        }
    }

    func createDeleteView() {
        deletePopView.frame = CGRect(x: 0.1 * screenWidth, y: 1 * screenHeight, width: 0.8 * screenWidth, height: 0.3 * screenHeight)
        deletePopView.backgroundColor = UIColor.white
        deletePopView.borderWidth = 1
        view.addSubview(deletePopView)
        
        let deleteViewTitle = UILabel()
        deleteViewTitle.text = "Deleting Screenshots"
        deleteViewTitle.textColor = .black
        deleteViewTitle.textAlignment = .center
        deleteViewTitle.font = UIFont(name: "Graphie-SemiBold", size: 18 * stringMultiplier)
        deleteViewTitle.frame = CGRect(x: 0.1 * screenWidth, y: 0.001 * screenHeight, width: 0.6 * screenWidth, height: 0.06 * screenHeight)
        deletePopView.addSubview(deleteViewTitle)
        
        let deleteViewText = UILabel()
        deleteViewText.text = "save selected images/videos and delete duplicates"
        deleteViewText.textColor = .black
        deleteViewText.textAlignment = .center
        deleteViewText.font = UIFont(name: "Graphie-Regular", size: 14 * stringMultiplier)
        deleteViewText.numberOfLines = 2
        deleteViewText.frame = CGRect(x: 0.1 * screenWidth, y: 0.06 * screenHeight, width: 0.6 * screenWidth, height: 0.1 * screenHeight)
        deletePopView.addSubview(deleteViewText)
        
        let deleteButton = UIButton()
        deleteButton.frame = CGRect(x: 0.1 * screenWidth, y: 0.17 * screenHeight, width: 0.6 * screenWidth, height: 0.04 * screenHeight)
        deleteButton.backgroundColor = .white
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor(red: 1.00, green: 0.35, blue: 0.35, alpha: 1.00), for: .normal)
        deleteButton.titleLabel?.textAlignment = .center
        deleteButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        deleteButton.borderWidth = 1
        deleteButton.borderColor = UIColor.black
        deletePopView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
       
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0.1 * screenWidth, y: 0.23 * screenHeight, width: 0.6 * screenWidth, height: 0.04 * screenHeight)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textColor = .white
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        cancelButton.backgroundColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        deletePopView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cancelClicked()
    }
    @objc func btnBackClicked() {
        dismiss(animated: true)
    }

    @objc func cancelClicked() {
        UIView.animate(withDuration: 0.2) {
            self.deletePopView.frame = CGRect(x: 0.1 * screenWidth, y: 1 * screenHeight, width: 0.8 * screenWidth, height: 0.3 * screenHeight)
        }
    }
    
 
    
 
    @objc func proBtnClicked() {
        performSegue(withIdentifier: "DuplicatedToInApp", sender: nil)
    }
}
