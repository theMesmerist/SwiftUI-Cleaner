//
//  BluredBackgroundView.swift
//  Cleaner
//
//  Created by Neon Apps on 16.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import UIKit

@IBDesignable class BluredBackgroundView: UIView {
    
    override func didMoveToSuperview() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        
    }
}
