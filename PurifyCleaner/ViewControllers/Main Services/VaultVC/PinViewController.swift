//
//  PinViewController.swift
//  FACoin
//
//  Created by Алексей Воронов on 09.12.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit
import KAPinField
import MediaBrowser
import Files
import LocalAuthentication

var urls: [URL] = []
var passwordSender = ""

class PinViewController: UIViewController, KAPinFieldDelegate, MediaBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   var isPreviewActive = false
    @IBOutlet weak var pinField: KAPinField!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
//    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    var firstPin = ""
    var currentPin = ""
    
    
    
    var browser = MediaBrowser()
    
    
    func showError(title: String? = "Error", text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: Notification.Name("CollectionReloaded"), object: nil)
        
       setDefaultSize(view: view)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

                titleLabel.textAlignment = .center
                titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20 * stringMultiplier)
                
        
        
        pinField.backgroundColor = .clear
        pinField.becomeFirstResponder()
        pinField.properties.delegate = self
        pinField.properties.isSecure = false
        pinField.tintColor = .clear
        pinField.appearance.backOffset = 8
        pinField.appearance.font = .menlo(20)
        pinField.appearance.kerning = 40
        pinField.appearance.backColor = UIColor.white
        pinField.textColor = UIColor.black
        pinField.appearance.tokenColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)
  
        currentPin = UserDefaults.standard.string(forKey: "pin") ?? ""
        print(currentPin)
        if currentPin == "" {
            titleLabel.text = "Create New PIN"
            titleLabel.textColor = .black

        } else {
            titleLabel.text = "Enter Your PIN"
            titleLabel.textColor = .black
        }
        
        loadData()


       
        descLabel.text = NSLocalizedString("Set a strong password in order to protect your\ndata. You can recover your password in case\nyou forget it. Please contact our support\nin this case.", comment: "")
        descLabel.textAlignment = .center
        descLabel.font = UIFont(name: "Avenir-Roman", size: 15 * stringMultiplier)
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.textColor = .gray
        descLabel.adjustsFontSizeToFitWidth = false
        view.addSubview(descLabel)
        descLabel.adapt_width_to_SH()
        

        btnBack.addTarget(self, action: #selector(self.btnBackClicked), for: UIControl.Event.touchUpInside)
        view.addSubview(btnBack)
        view.bringSubviewToFront(btnBack)
     //   btnBack.adapt_width_to_SH()
       
     
        self.isModalInPresentation = true
       
     
     
        NotificationCenter.default.addObserver(self, selector: #selector(activatePreview), name: Notification.Name("ActivatePreview"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(deactivatePreview), name: Notification.Name("DeactivatePreview"), object: nil)
        
    /*
        if getUserDefaultsBoolValue(FaceID_Active) {
          
            authenticateTapped()
        }
        */
    }
    func authenticateTapped() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please verify Touch/FaceID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                      
                        
                        self!.showSecretMedia()
                        
                    }
                }
            }
        }
    }
    
    @objc func reloadCollectionView(){
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showSecretMedia()
        }
    
     }
    
    
    
    @objc func btnBackClicked(){
        
        if isPreviewActive{
           
            NotificationCenter.default.post(name: Notification.Name("ShowGrid"), object: nil)
           
            
            
        }else{
        if passwordSender == "Main"{
            
            
            dismiss(animated: true, completion: nil)
        }else{
            
            performSegue(withIdentifier: "vaultToMain", sender: nil)
        }
        
        }
        
    
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        if firstPin == "" && currentPin == "" {
            firstPin = code
            pinField.text = ""
            pinField.animateFailure()
            titleLabel.text = "Repeat PIN"
        } else if currentPin == "" {
            if code == firstPin {
                UserDefaults.standard.set(code, forKey: "pin")
                showSecretMedia()
            } else {
                showError(text: "Wrong PIN")
                titleLabel.text = "Setup PIN"
                firstPin = ""
                pinField.animateFailure()
                pinField.text = ""
            }
        } else if code == currentPin {
            showSecretMedia()
        } else {
            showError(text: "Wrong PIN")
            pinField.animateFailure()
            pinField.text = ""
        }
    }

    func showSecretMedia() {
        

        browser = MediaBrowser(delegate: self)
        browser.alwaysShowControls = true
        browser.enableGrid = true
        browser.startOnGrid = true
        browser.displayActionButton = true
        browser.disableGridAnimations = true
        browser.displayMediaNavigationArrows = true
        browser.navigationBarBackgroundColor = UIColor.white
        
//       navigationItem Color
        browser.navigationBarTextColor = UIColor.black
        
//        image'ye tıklandıktan sonraki alanın arka planı
        browser.scrollViewBackgroundColor = UIColor.white
        
        
//        trash ve share özelliğinin olduğu yerin arkaplan rengi
        browser.toolbarBarTintColor = UIColor.white
        
//        trash ve share butonu coloru
        browser.toolbarTextColor = UIColor.black

        
        browser.view.backgroundColor = UIColor.white
        browser.navigationItem.hidesBackButton = true
        browser.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .done, target: self, action: #selector(addImage))
        browser.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(btnBackClicked))
        browser.navigationItem.leftBarButtonItem?.image = UIImage(named: "btn_backUI")


        browser.delegate = self
      
        
     
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(browser, animated: true)
        browser.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        
    }
    
    @objc func activatePreview(){
        
        isPreviewActive = true
    }
    
    @objc func deactivatePreview(){
        
       isPreviewActive = false
        
    }

    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return urls.count
    }
    
    
    
    func thumbnail(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        return Media(url: urls[index])
    }
    
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        return Media(url: urls[index])
    }
    
    var imagePicker = UIImagePickerController()
    
    @objc func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        
         var previousCount = 10000000
            
        if let previousPhotoCount = UserDefaults.standard.object(forKey: "previousPhotoCount") as? Int{
            
            previousCount = previousPhotoCount
            
            
        }
        
        previousCount -= 1
        UserDefaults.standard.set(previousCount, forKey: "previousPhotoCount")
        
        do {
            let folder = try Folder(path: documentDirectory!.path)
            let file = try folder.createFile(named: "\(previousCount).jpeg")
           
            try file.write(image.jpegData(compressionQuality: 0.8)!)
            self.loadData()
            print(file.url)
        } catch {
            print(error)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadData()
        }
        picker.dismiss(animated: true, completion: nil)
//        self.navigationController?.popToRootViewController(animated: false)
        self.showSecretMedia()
    }
    
    
    func loadData() {
        let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let folder = try? Folder(path: documentDirectory!.path)
        
        urls = []
    
        for file in try! folder!.files {
            if file.extension == "jpeg" {
            
                    
                    urls.append(file.url)
                
              
            }
            
            
        }
        
        
        self.browser.reloadData()
    
    }
    
    
}
