//
//  ViewController.swift
//  PurifyCleaner
//
//  Created by Uzay Altıner on 27.06.2022.
//

import MessageUI
import UIKit

class SettingsVC: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    let accessBtn = UIButton(type: .system)
    let shareBtn = UIButton(type: .system)
    let helpBtn = UIButton(type: .system)
    let termBtn = UIButton(type: .system)
    let privacyBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        setupUI()
        addBg(view: view)
    }

    func setupUI() {
        let settingsLbl = UILabel()
        settingsLbl.text = "Settings"
        settingsLbl.frame = CGRect(x: 0.2 * screenWidth, y: 0.1 * screenHeight, width: 0.6 * screenWidth, height: 0.1 * screenWidth)
        settingsLbl.font = UIFont(name: "Poppins-Medium", size: 24)
        settingsLbl.textAlignment = .center
        settingsLbl.textColor = .black
        view.addSubview(settingsLbl)
        
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage(named: "btn_backUI"), for: .normal)
        backBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.1 * screenHeight, width: 0.1 * screenWidth, height: 0.1 * screenWidth)
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        view.addSubview(backBtn)
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0.15 * screenHeight, width: screenWidth, height: 0.850 * screenHeight)
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight * 0.75)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = true
        view.addSubview(scrollView)
        
        accessBtn.setSettingsButton(yPozition: 0.025, title: "Photo Access", selector: #selector(accessBtnTapped), addView: scrollView, VC: self)
        accessBtn.addShadow()
        shareBtn.setSettingsButton(yPozition: 0.125, title: "Share with your friends", selector: #selector(shareBtnTapped), addView: scrollView, VC: self)
        shareBtn.addShadow()
        helpBtn.setSettingsButton(yPozition: 0.225, title: "Help & Support", selector: #selector(helpBtnTapped), addView: scrollView, VC: self)
        helpBtn.addShadow()
        termBtn.setSettingsButton(yPozition: 0.325, title: "Term of Use", selector: #selector(termBtnTapped), addView: scrollView, VC: self)
        termBtn.addShadow()
        privacyBtn.setSettingsButton(yPozition: 0.425, title: "Privacy Policy", selector: #selector(privacyBtnTapped), addView: scrollView, VC: self)
        // termBtn
        // privacyBtn
    }
    
    @objc func accessBtnTapped() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    @objc func backBtnTapped() {
        dismiss(animated: true)
    }
    
    @objc func shareBtnTapped() {
        let items = [URL(string: "https://apps.apple.com/app/id\(1627482561)")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }

    @objc func helpBtnTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["smartmobilecleaner@gmail.com"])
            mail.setMessageBody("I need help", isHTML: true)
            present(mail, animated: true)
        }
    }
    
    @objc func termBtnTapped() {
        if let url = URL(string: "https://sites.google.com/view/purify-smart-cleaner/terms-of-use") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func privacyBtnTapped() {
        if let url = URL(string: "https://sites.google.com/view/purify-smart-cleaner/privacy-policy") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
