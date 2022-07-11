//
//  progressAnimation.swift
//  Cleaner
//
//  Created by Bedri Doğan on 20.01.2022.
//  Copyright © 2022 Neon Apps. All rights reserved.
//

import Foundation
import Lottie
import UIKit



class ProgressAnimation{
    
    

    
    func createProgressAnimation(view : UIView, animationDuration : Int, hideView : UIView ){
        
        var timerCount = 0
        
        setDefaultSize(view: view)
        
        let animationTop = AnimationView()
        animationTop.animation = Animation.named("loadingAnimPurple")
        animationTop.frame = CGRect(x: 0.325 * screenWidth, y: 0.46 * screenHeight, width: 0.35 * screenWidth, height: 0.15 * screenHeight)
        animationTop.backgroundColor = .clear
        animationTop.loopMode = .playOnce
        animationTop.animationSpeed = CGFloat(16) / CGFloat(animationDuration)
        animationTop.currentProgress = 0
        animationTop.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationTop)
        animationTop.play()
        
        
        let storageLabel = UILabel()
        storageLabel.text = NSLocalizedString("%20", comment: "")
        storageLabel.textAlignment = .left
        storageLabel.font = UIFont(name: "Avenir-Roman", size: 14 * stringMultiplier)
        storageLabel.frame = CGRect(x: 0.47 * screenWidth, y: 0.5 * screenHeight, width: 0.12 * screenWidth, height: 0.075 * screenHeight)
        storageLabel.numberOfLines = 1
        storageLabel.textColor = .black
        view.addSubview(storageLabel)
        storageLabel.isHidden = true
        

     
       
        
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: Double(animationDuration) / Double(100), repeats: true) { [self] timer in
           
            if timerCount < 100{
                
                timerCount += 1
                storageLabel.text = "\(timerCount)%"
                
            }else{
                hideView.isHidden = false
                animationTop.isHidden = true
                storageLabel.isHidden = true
            }
           
        }
        
        
    }
}
