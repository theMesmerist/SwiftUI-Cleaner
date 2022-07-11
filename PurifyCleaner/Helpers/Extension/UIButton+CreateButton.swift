//
//  UIButton+CreateButton.swift
//  PurifyCleaner
//
//  Created by Uzay Altıner on 27.06.2022.
//

import Foundation

extension UIButton {
    func setSettingsButton(yPozition: CGFloat, title: String, selector: Selector, addView: UIView, VC: UIViewController) {
        let icon = UIImage(named: "btn_arrowUI")?.withRenderingMode(.alwaysTemplate)
        self.setImage(icon, for: .normal)
        self.tintColor = UIColor(red: 0.40, green: 0.31, blue: 0.64, alpha: 1.00)
        self.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 18)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (0.85 * screenWidth) * 0.9, bottom: 0, right: 0)
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.contentVerticalAlignment.self = .center
        self.contentHorizontalAlignment.self = .left
        self.setTitleColor(UIColor(red: 0.13, green: 0.12, blue: 0.14, alpha: 1.00), for: UIControl.State.normal)
        self.frame = CGRect(x: 0.05 * screenWidth, y: yPozition * screenHeight, width: 0.9 * screenWidth, height: 0.08 * screenHeight)
        self.setTitle(NSLocalizedString("\(title)", comment: ""), for: UIControl.State.normal)
        addView.addSubview(self)
        self.addTarget(VC, action: selector, for: UIControl.Event.touchUpInside)
    }

    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.00).cgColor
        self.layer.shadowRadius = 13
        self.layer.shadowOpacity = 0.33
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
