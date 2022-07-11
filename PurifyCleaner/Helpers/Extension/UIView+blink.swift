//
//  UIView+blink.swift
//  BlockingApp
//
//  Created by Neon Apps on 14.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import UIKit


extension UIView {
    
    func blink() {
        self.alpha = 1.0;
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [ .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0 },
            completion:nil)
    }
    
}
