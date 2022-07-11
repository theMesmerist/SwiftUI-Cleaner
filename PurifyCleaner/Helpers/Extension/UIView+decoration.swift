//
//  UIView+decoration.swift
//  ITMO
//
//  Created by Neon Apps Voronov on 01/08/2019.
//  Copyright © 2019 Neon Apps Voronov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignableUIButton: UIButton {}
@IBDesignable class DesignableUIView: UIView {
    @IBInspectable var isShadowActive: Bool = false {
        didSet {
            if isShadowActive {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowRadius = 50
                layer.shadowOpacity = 0.30
                layer.shadowOffset.height = 2
                self.layer.masksToBounds = !isShadowActive
            } else {
                layer.shadowOpacity = 0
            }
        }
    }
}
@IBDesignable class DesignableUIImageView: UIImageView {
    @IBInspectable var isShadowActive: Bool = false {
        didSet {
            if isShadowActive {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowRadius = 50
                layer.shadowOpacity = 0.30
                layer.shadowOffset.height = 2
                self.layer.masksToBounds = !isShadowActive
            } else {
                layer.shadowOpacity = 0
            }
        }
    }
}

extension UIView {
    func rounded(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    // MARK: IBInspectable
    
    @IBInspectable var borderColor: UIColor {
        get {
            let color = self.layer.borderColor ?? UIColor.white.cgColor
            return UIColor(cgColor: color) // not using this property as such
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var cornerRadiusSize: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.rounded(cornerRadius: newValue)
        }
    }
}
