//
//  onBoarding2.swift
//  Cleaner
//
//  Created by Uzay Altıner on 22.06.2022.
//  Copyright © 2022 voronoff. All rights reserved.
//

import Hero
import UIKit

class onBoarding2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSize(view: view)
        addBg(view: view)
        setupUI()
    }

    func setupUI() {
        let onbImg = UIImageView()
        onbImg.image = UIImage(named: "img_onboarding1")
        onbImg.frame = CGRect(x: 0.05 * screenWidth, y: 0.1 * screenHeight, width: 0.9 * screenWidth, height: 0.9 * screenWidth)
        onbImg.contentMode = .scaleAspectFit
        view.addSubview(onbImg)

        let sliderImg = UIImageView()
        sliderImg.image = UIImage(named: "img_slider02")
        sliderImg.frame = CGRect(x: 0.4 * screenWidth, y: 0.5 * screenHeight, width: 0.2 * screenWidth, height: 0.2 * screenWidth)
        sliderImg.contentMode = .scaleAspectFit
        view.addSubview(sliderImg)

        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: 0.15 * screenWidth, y: 0.58 * screenHeight, width: 0.7 * screenWidth, height: 0.2 * screenWidth)
        titleLbl.text = "Purify Your Gallery"
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont(name: "Poppins-Medium", size: 26)
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor(red: 0.13, green: 0.12, blue: 0.14, alpha: 1.00)
        view.addSubview(titleLbl)

        let descLbl = UILabel()
        descLbl.frame = CGRect(x: 0.15 * screenWidth, y: 0.68 * screenHeight, width: 0.7 * screenWidth, height: 0.3 * screenWidth)
        descLbl.numberOfLines = 0
        descLbl.text = "The app detects duplicate photos and screenshots in your gallery and shows them to you."
        descLbl.font = UIFont(name: "Poppins-Light", size: 18)
        descLbl.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.29, alpha: 1.00)
        descLbl.textAlignment = .center
        view.addSubview(descLbl)

        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: 0.05 * screenWidth, y: 0.85 * screenHeight, width: 0.9 * screenWidth, height: 0.15 * screenWidth)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        nextBtn.backgroundColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        nextBtn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        view.addSubview(nextBtn)
    }

    @objc func nextBtnTapped() {
        performSegue(withIdentifier: "onBoarding2To3", sender: nil)
    }
}















