//
//  Main.swift
//  Cleaner
//
//  Created by Emre Karaoğlu on 7.12.2021.
//  Copyright © 2021 Neon Apps. All rights reserved.
//

import Hero
import Lottie
import Photos
import SwiftUI
import SystemServices
import UIKit

class Main: UIViewController, UIScrollViewDelegate, StorageInfoControllerDelegate, UIGestureRecognizerDelegate {
    var animationTop = AnimationView()
    
    var percentLabel = UILabel()
    
    var usedSpace = Int()
    
    var storageInfo: StorageInfo?
    
    let systemServices = SystemServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        addBg(view: view)
        setupUI()
        
        freeCount = uDefaults.integer(forKey: "freeCount")
        print(freeCount)
        
        
    }
    
    func setupUI() {
        let usedSpace = ((CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1)) - CGFloat(freeDiskSpaceInBytesImportant / 1000000000)) / (CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1))
        
        var fullSpace = String(format: "%.2f GB", (CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1)) - CGFloat(freeDiskSpaceInBytesImportant / 1000000000))
        
        var diskSpace = String(format: "%.2f GB", CGFloat(systemServices.longDiskSpace / 1000000000) + CGFloat(1))
       
        let premiumBtn = UIButton()
        premiumBtn.backgroundColor = UIColor.white
        premiumBtn.setImage(UIImage(named: "img_premiumUI"), for: .normal)
        premiumBtn.setTitle("Try Premium", for: .normal)
        premiumBtn.setTitleColor(UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1), for: .normal)
        premiumBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.1 * screenHeight, width: 0.425 * screenWidth, height: 0.05 * screenHeight)
        premiumBtn.backgroundColor = UIColor.white
        premiumBtn.layer.shadowColor = UIColor.black.cgColor
        premiumBtn.layer.shadowRadius = 10
        if StoreKitOperations().isSubscribed() || isFreeUser {
            premiumBtn.isHidden = true
        }
        premiumBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        premiumBtn.layer.shadowOpacity = 0.05
        premiumBtn.addTarget(self, action: #selector(premiumBtnClicked), for: .touchUpInside)
        view.addSubview(premiumBtn)
        
        let btnSettings = UIButton()
        btnSettings.setBackgroundImage(UIImage(named: "btn_settingsUI"), for: UIControl.State.normal)
        btnSettings.frame = CGRect(x: 0.85 * screenWidth, y: 0.1 * screenHeight, width: 0.115 * screenWidth, height: 0.05 * screenHeight)
        btnSettings.addTarget(self, action: #selector(btnSettingsClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(btnSettings)
        btnSettings.adapt_width_to_SH()
        
        let percentageHolder = UIView()
        percentageHolder.frame = CGRect(x: 0.05 * screenWidth, y: 0.175 * screenHeight, width: 0.9 * screenWidth, height: 0.3 * screenHeight)
        percentageHolder.backgroundColor = UIColor.white
        percentageHolder.layer.shadowColor = UIColor.black.cgColor
        percentageHolder.layer.shadowRadius = 10
        percentageHolder.layer.shadowOffset = CGSize(width: 0, height: 5)
        percentageHolder.layer.shadowOpacity = 0.05
        view.addSubview(percentageHolder)
        
        let storageLabel = UILabel()
        storageLabel.text = "Your Storage"
        storageLabel.textColor = UIColor(red: 0.224, green: 0.224, blue: 0.224, alpha: 1)
        storageLabel.font = UIFont(name: "Poppins-Medium", size: 24 * stringMultiplier)
        storageLabel.frame = CGRect(x: screenWidth * 0.25, y: 0.015 * screenHeight, width: screenWidth * 0.4, height: screenHeight * 0.05)
        percentageHolder.addSubview(storageLabel)
      
        animationTop.animation = Animation.named("loadingAnimPurple")
        animationTop.frame = CGRect(x: 0.1 * screenWidth, y: 0.08 * screenHeight, width: 0.7 * screenWidth, height: 0.2 * screenHeight)
        animationTop.backgroundColor = .clear
        animationTop.loopMode = .loop
        animationTop.animationSpeed = 1
        animationTop.currentProgress = 0.5
        animationTop.backgroundBehavior = .pauseAndRestore
        percentageHolder.addSubview(animationTop)
        animationTop.play()
        
        percentLabel.text = NSLocalizedString("\(Int(usedSpace * 100))%", comment: "")
        percentLabel.textAlignment = .left
        percentLabel.textColor = .black
        percentLabel.font = UIFont(name: "Poppins-Regular", size: 40 * stringMultiplier)
        percentLabel.numberOfLines = 0
        percentLabel.frame = CGRect(x: 0.37 * screenWidth, y: 0.13 * screenHeight, width: 0.6 * screenWidth, height: 0.1 * screenHeight)
        percentageHolder.addSubview(percentLabel)
        
        animationTop.currentProgress = AnimationProgressTime(usedSpace)
        
        let featuresLbl = UILabel()
        featuresLbl.text = "Features"
        featuresLbl.textColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        featuresLbl.font = UIFont(name: "Graphie-Regular", size: 20 * stringMultiplier)
        featuresLbl.frame = CGRect(x: 0.1 * screenWidth, y: 0.5 * screenHeight, width: 0.2 * screenWidth, height: 0.05 * screenHeight)
        view.addSubview(featuresLbl)
        
        let largeVideosView = UIView()
        largeVideosView.frame = CGRect(x: 0.05 * screenWidth, y: 0.5 * screenHeight, width: 0.425 * screenWidth, height: 0.475 * screenWidth)
        largeVideosView.backgroundColor = .white
        largeVideosView.clipsToBounds = false
        largeVideosView.layer.shadowColor = UIColor.black.cgColor
        largeVideosView.layer.shadowRadius = 10
        largeVideosView.layer.shadowOffset = CGSize(width: 0, height: 5)
        largeVideosView.layer.shadowOpacity = 0.05
        view.addSubview(largeVideosView)

        let largeVideosGesture = UITapGestureRecognizer(target: self, action: #selector(videoFiles_HolderClicked))
        largeVideosGesture.delegate = self
        largeVideosView.addGestureRecognizer(largeVideosGesture)

        let largeVideosImg = UIImageView()
        largeVideosImg.image = UIImage(named: "img_videoUI")
        largeVideosImg.frame = CGRect(x: 0.3 * largeVideosView.frame.size.width, y: 0.05 * largeVideosView.frame.size.height, width: 0.4 * largeVideosView.frame.size.width, height: 0.4 * largeVideosView.frame.size.width)
        largeVideosView.addSubview(largeVideosImg)

        let largeVideosTitle = UILabel()
        largeVideosTitle.text = "Large Videos"
        largeVideosTitle.textColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        largeVideosTitle.frame = CGRect(x: 0.1 * largeVideosView.frame.size.width, y: largeVideosImg.frame.maxY + 0.03 * largeVideosView.frame.size.height, width: 0.8 * largeVideosView.frame.size.width, height: 0.15 * largeVideosView.frame.size.height)
        largeVideosTitle.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        largeVideosTitle.textAlignment = .center
        largeVideosView.addSubview(largeVideosTitle)

        let largeVideosDescription = UILabel()
        largeVideosDescription.text = "Detecting large videos\nthat take up too much\nspace"
        largeVideosDescription.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        largeVideosDescription.textColor = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)
        largeVideosDescription.frame = CGRect(x: 0.05 * largeVideosView.frame.size.width, y: largeVideosTitle.frame.maxY + 0.05 * largeVideosView.frame.size.height, width: 0.9 * largeVideosView.frame.size.width, height: 0.3 * largeVideosView.frame.size.height)
        largeVideosDescription.numberOfLines = 0
        largeVideosDescription.textAlignment = .center
        largeVideosView.addSubview(largeVideosDescription)

        let duplicatesView = UIView()
        duplicatesView.frame = CGRect(x: 0.525 * screenWidth, y: 0.5 * screenHeight, width: 0.425 * screenWidth, height: 0.475 * screenWidth)
        duplicatesView.backgroundColor = .white
        duplicatesView.clipsToBounds = false
        duplicatesView.layer.shadowColor = UIColor.black.cgColor
        duplicatesView.layer.shadowRadius = 10
        duplicatesView.layer.shadowOffset = CGSize(width: 0, height: 5)
        duplicatesView.layer.shadowOpacity = 0.05
        view.addSubview(duplicatesView)

        let duplicatesGesture = UITapGestureRecognizer(target: self, action: #selector(duplicate_HolderClicked))
        duplicatesGesture.delegate = self
        duplicatesView.addGestureRecognizer(duplicatesGesture)

        let duplicatesImg = UIImageView()
        duplicatesImg.image = UIImage(named: "img_duplicateUI")
        duplicatesImg.frame = CGRect(x: 0.3 * duplicatesView.frame.size.width, y: 0.05 * duplicatesView.frame.size.height, width: 0.4 * largeVideosView.frame.size.width, height: 0.4 * duplicatesView.frame.size.width)
        duplicatesView.addSubview(duplicatesImg)

        let duplicatesTitle = UILabel()
        duplicatesTitle.text = "Duplicates"
        duplicatesTitle.textColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        duplicatesTitle.frame = CGRect(x: 0.1 * duplicatesView.frame.size.width, y: duplicatesImg.frame.maxY + 0.03 * duplicatesView.frame.size.height, width: 0.8 * duplicatesView.frame.size.width, height: 0.15 * duplicatesView.frame.size.height)
      
        duplicatesTitle.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        duplicatesTitle.textAlignment = .center
        duplicatesView.addSubview(duplicatesTitle)

        let duplicatesDescription = UILabel()
        duplicatesDescription.text = "View duplicate photos\nand delete or keep them"
        duplicatesDescription.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        duplicatesDescription.textColor = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)
        duplicatesDescription.frame = CGRect(x: 0.05 * duplicatesView.frame.size.width, y: duplicatesTitle.frame.maxY + 0.02 * duplicatesView.frame.size.height, width: 0.9 * duplicatesView.frame.size.width, height: 0.3 * duplicatesView.frame.size.height)
        duplicatesDescription.numberOfLines = 0
        duplicatesDescription.textAlignment = .center
        duplicatesView.addSubview(duplicatesDescription)

        let screenshotsView = UIView()
        screenshotsView.frame = CGRect(x: 0.05 * screenWidth, y: largeVideosView.frame.maxY + 0.025 * screenHeight, width: 0.425 * screenWidth, height: 0.475 * screenWidth)
        screenshotsView.backgroundColor = .white
        screenshotsView.clipsToBounds = false
        screenshotsView.layer.shadowColor = UIColor.black.cgColor
        screenshotsView.layer.shadowRadius = 10
        screenshotsView.layer.shadowOffset = CGSize(width: 0, height: 5)
        screenshotsView.layer.shadowOpacity = 0.05
        view.addSubview(screenshotsView)
        
        let screenShotsGesture = UITapGestureRecognizer(target: self, action: #selector(screenShots_HolderClicked))
        screenShotsGesture.delegate = self
        screenshotsView.addGestureRecognizer(screenShotsGesture)

        let screenShotsImg = UIImageView()
        screenShotsImg.image = UIImage(named: "img_screenshotUI")
        screenShotsImg.frame = CGRect(x: 0.3 * screenshotsView.frame.size.width, y: 0.05 * screenshotsView.frame.size.height, width: 0.4 * screenshotsView.frame.size.width, height: 0.4 * screenshotsView.frame.size.width)
        screenshotsView.addSubview(screenShotsImg)

        let screenshotsTitle = UILabel()
        screenshotsTitle.text = "Screenshot"
        screenshotsTitle.frame = CGRect(x: 0.1 * screenshotsView.frame.size.width, y: screenShotsImg.frame.maxY + 0.03 * duplicatesView.frame.size.height, width: 0.8 * screenshotsView.frame.size.width, height: 0.15 * screenshotsView.frame.size.height)
      
        screenshotsTitle.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        screenshotsTitle.textColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        screenshotsTitle.textAlignment = .center
        screenshotsView.addSubview(screenshotsTitle)

        let screenshotsDescription = UILabel()
        screenshotsDescription.text = "Remove repeated screenshots\nfrom your gallery"
        screenshotsDescription.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        screenshotsDescription.textColor = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)
        screenshotsDescription.frame = CGRect(x: 0.05 * screenshotsView.frame.size.width, y: screenshotsTitle.frame.maxY + 0.02 * duplicatesView.frame.size.height, width: 0.9 * screenshotsView.frame.size.width, height: 0.3 * screenshotsView.frame.size.height)
        
        screenshotsDescription.numberOfLines = 0
        screenshotsDescription.textAlignment = .center
        screenshotsView.addSubview(screenshotsDescription)

        let vaultView = UIView()
        vaultView.frame = CGRect(x: 0.525 * screenWidth, y: duplicatesView.frame.maxY + 0.025 * screenHeight, width: 0.425 * screenWidth, height: 0.475 * screenWidth)
        vaultView.backgroundColor = .white
        vaultView.clipsToBounds = false
        vaultView.layer.shadowColor = UIColor.black.cgColor
        vaultView.layer.shadowRadius = 10
        vaultView.layer.shadowOffset = CGSize(width: 0, height: 5)
        vaultView.layer.shadowOpacity = 0.05
        view.addSubview(vaultView)
        
        let vaultGesture = UITapGestureRecognizer(target: self, action: #selector(storage_HolderClicked))
        vaultGesture.delegate = self
        vaultView.addGestureRecognizer(vaultGesture)

        let vaultImg = UIImageView()
        vaultImg.image = UIImage(named: "img_vaultUI")
        vaultImg.frame = CGRect(x: 0.3 * vaultView.frame.size.width, y: 0.05 * vaultView.frame.size.height, width: 0.4 * vaultView.frame.size.width, height: 0.4 * vaultView.frame.size.width)
        vaultView.addSubview(vaultImg)

        let vaultTitle = UILabel()
        vaultTitle.text = "Vault"
        vaultTitle.frame = CGRect(x: 0.1 * vaultView.frame.size.width, y: vaultImg.frame.maxY + 0.03 * duplicatesView.frame.size.height, width: 0.8 * vaultView.frame.size.width, height: 0.15 * vaultView.frame.size.height)
        vaultTitle.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        vaultTitle.textColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        vaultTitle.textAlignment = .center
        vaultView.addSubview(vaultTitle)

        let vaultDescription = UILabel()
        vaultDescription.text = "Hide your private photos\nand keep them in the\nencrypted vault"
        vaultDescription.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        vaultDescription.textColor = UIColor(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)
        vaultDescription.frame = CGRect(x: 0.05 * vaultView.frame.size.width, y: vaultTitle.frame.maxY + 0.02 * duplicatesView.frame.size.height, width: 0.9 * vaultView.frame.size.width, height: 0.3 * vaultView.frame.size.height)
        vaultDescription.numberOfLines = 0
        vaultDescription.textAlignment = .center
        vaultView.addSubview(vaultDescription)
    }
    
    func storageInfoUpdated() {
        DispatchQueue.main.async {
            print("şdlskfşl")
            self.storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
            print(AMUtils.toNearestMetric(self.storageInfo!.totalVideoSize, desiredFraction: 1))
            print(AMUtils.toNearestMetric(self.storageInfo!.totalPictureSize, desiredFraction: 1))
        }
    }

    @objc func premiumBtnClicked() {
        performSegue(withIdentifier: "to_inApp", sender: nil)
    }
    
    func getStorageInfo() {
        SystemMonitor.storageInfoCtrl().delegate = self
        storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
    }
    
    @objc func proBtnClicked() {
        performSegue(withIdentifier: "to_inApp", sender: nil)
    }
    
    @objc func videoFiles_HolderClicked() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        PHPhotoLibrary.requestAuthorization { [self] status in
            if status == PHAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    if !StoreKitOperations().isSubscribed() && !isFreeUser{
                        if freeCount > 5 {
                           performSegue(withIdentifier: "to_inApp", sender: nil)
                        } else {
                            InterstitialAdHandler().showInterstitialAd(VC: self) {
                                
                                freeCount += 1
                                uDefaults.setValue(freeCount, forKey: "freeCount")
                                
                                performSegue(withIdentifier: "mainToVideoFiles", sender: nil)
                            }
                        }
                        
                    } else {
                        performSegue(withIdentifier: "mainToVideoFiles", sender: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    showAlert()
                }
            }
        }
    }

    @objc func duplicate_HolderClicked() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        PHPhotoLibrary.requestAuthorization { [self] status in
            if status == PHAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    if !StoreKitOperations().isSubscribed() && !isFreeUser{
                        if freeCount > 5 {
                           performSegue(withIdentifier: "to_inApp", sender: nil)
                        } else {
                            InterstitialAdHandler().showInterstitialAd(VC: self) {
                                freeCount += 1
                                uDefaults.setValue(freeCount, forKey: "freeCount")
                                performSegue(withIdentifier: "mainToDuplicate", sender: nil)
                            }
                        }
                        
                    } else {
                        performSegue(withIdentifier: "mainToDuplicate", sender: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    showAlert()
                }
            }
        }
    }

    @objc func screenShots_HolderClicked() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        PHPhotoLibrary.requestAuthorization { [self] status in
            if status == PHAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    if !StoreKitOperations().isSubscribed() && !isFreeUser{
                        if freeCount > 5 {
                           performSegue(withIdentifier: "to_inApp", sender: nil)
                        } else {
                            InterstitialAdHandler().showInterstitialAd(VC: self) {
                                
                                freeCount += 1
                                uDefaults.setValue(freeCount, forKey: "freeCount")
                                performSegue(withIdentifier: "mainToscreenShots", sender: nil)
                            }
                        }
                        
                    } else {
                        performSegue(withIdentifier: "mainToscreenShots", sender: nil)
                    }
                }
                   
            } else {
                DispatchQueue.main.async {
                    showAlert()
                }
            }
        }
    }

    @objc func storage_HolderClicked() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        PHPhotoLibrary.requestAuthorization { [self] status in
            if status == PHAuthorizationStatus.authorized {
                let currentPin = UserDefaults.standard.string(forKey: "pin") ?? ""
                print(currentPin)
                if currentPin == "" {
                    DispatchQueue.main.async {
                        performSegue(withIdentifier: "toSetPassword", sender: nil)
                    }
                   
                } else {
                    passwordSender = "Main"
                    DispatchQueue.main.async {
                        performSegue(withIdentifier: "mainTosecretStorage", sender: nil)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    showAlert()
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Permission required", message: "Please enable photos access in settings", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func isPermissionGranted() -> Bool {
        var result = Bool()
      
        PHPhotoLibrary.requestAuthorization { status in
            if status == PHAuthorizationStatus.authorized {
                result = true
                    
            } else {
                result = false
            }
        }
        
        return result
    }

    @objc func btnSettingsClicked() {
        performSegue(withIdentifier: "mainToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainTosecretStorage" {
            let destinationVC = segue.destination
            destinationVC.modalPresentationStyle = .pageSheet
        }
        if segue.identifier == "to_inApp" {
            let destinationVC = segue.destination
            destinationVC.hero.isEnabled = true
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .up), dismissing: .zoomSlide(direction: .down))
        }
    }
}
