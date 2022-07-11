//
//  Globals.swift
//  Ultimate AdBlock
//
//  Created by Tuna Öztürk on 30.07.2021.
//

import Foundation
import UIKit
import Lottie
import Hero


var uDefaults = UserDefaults.standard

var sender = ""


var screenHeight = CGFloat()
var screenWidth = CGFloat()
var stringMultiplier = CGFloat()
var ScreenWidth_To_ScreenHeight_Converter = CGFloat()
var ScreenHeight_To_ScreenWidth_Converter = CGFloat()


var freeCount = 0



var isIpad = false
var isIphone8 = false


enum deviceTypes{
    
    case iPhone8
    case iPhoneX
    case iPad
    
    
}
var deviceType = deviceTypes.iPad
func setDefaultSize(view : UIView){

    screenHeight = view.frame.size.height
    screenWidth = view.frame.size.width
    stringMultiplier = 0.00115 * screenHeight
    ScreenWidth_To_ScreenHeight_Converter = 1 / screenWidth * screenHeight / 2.1642
    ScreenHeight_To_ScreenWidth_Converter = 1 / screenHeight * screenWidth / 0.4620
}
func addLightModeBg(view: UIView) {
    let white1 = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    let white2 = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.00)
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [white1.cgColor, white2.cgColor]
    view.layer.insertSublayer(gradientLayer, at: 0)
}

extension UIView{
    
    

func adapt_width_to_SH(){
    
    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width * ScreenWidth_To_ScreenHeight_Converter, height: self.frame.height)
}

func adapt_height_to_SW(){
    
    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height * ScreenHeight_To_ScreenWidth_Converter)
}

func adapt_x_to_SH(){
    
    self.frame = CGRect(x: self.frame.minX * ScreenWidth_To_ScreenHeight_Converter, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
}

func adapt_y_to_SW(){
    
    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY * ScreenHeight_To_ScreenWidth_Converter, width: self.frame.width, height: self.frame.height)
}


}

func addBg(view: UIView) {
    let white1 = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    let white2 = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [white1.cgColor, white2.cgColor]
    view.layer.insertSublayer(gradientLayer, at: 0)
}

let currency_symbol = "$"

func create_loading_view(view : UIView) -> UIView{
    
    let view_loading = UIView()
    view_loading.frame = view.bounds
    
    let view_background = UIView()
    view_background.frame = view_loading.bounds
    view_background.backgroundColor = .black
    view_background.alpha = 0.6
    view_loading.addSubview(view_background)
    
    let anim_loading = AnimationView(name: "inAppLoading")
    anim_loading.frame = CGRect(x: 0.25 * screenWidth, y: 0.25 * screenHeight, width: 0.5  * screenWidth, height: 0.5 * screenHeight)
    anim_loading.backgroundColor = .clear
    anim_loading.loopMode = .loop
    anim_loading.animationSpeed = 1
    anim_loading.backgroundBehavior = .pauseAndRestore
    view_loading.addSubview(anim_loading)
    anim_loading.play()
    
    return view_loading
    
}

func showAlert(title: String, message: String,  viewController : UIViewController){
    

    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
    
    
}

func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
    
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
    
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
var vSpinner : UIView?


extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        spinnerView.frame = CGRect(x: 0.04 * screenWidth, y: 0.05 * screenHeight, width: 0.02 * screenWidth, height: 0.005 * screenHeight)
        // Add Animation View

        let animationView = AnimationView(name: "animation")
        animationView.center = spinnerView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.backgroundColor = .clear

        // Start Animation

        animationView.play()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(animationView)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.isHidden = true
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}



enum Direction {
    case right
    case left
    case up
    case down
    
}


func presentVC(currentVC : UIViewController, destinationVC : UIViewController, toDirection : Direction){
    
    
    switch toDirection {
    case .left:
        destinationVC.hero.modalAnimationType = .selectBy(presenting:.slide(direction: .right), dismissing:.slide(direction: .left))
    case .right:
        destinationVC.hero.modalAnimationType = .selectBy(presenting:.slide(direction: .left), dismissing:.slide(direction: .right))
    case .up:
        destinationVC.hero.modalAnimationType = .selectBy(presenting:.slide(direction: .down), dismissing:.slide(direction: .up))
    case .down:
        destinationVC.hero.modalAnimationType = .selectBy(presenting:.slide(direction: .up), dismissing:.slide(direction: .down))
    }
    
    
    destinationVC.isHeroEnabled = true
    destinationVC.modalPresentationStyle = .fullScreen
    currentVC.present(destinationVC, animated: true)
    
}

func presentVCWithoutAnimation(currentVC : UIViewController, destinationVC : UIViewController){
    destinationVC.modalPresentationStyle = .fullScreen
    currentVC.present(destinationVC, animated: false)
}

func presentAsPageSheet(currentVC : UIViewController, destinationVC : UIViewController){
    destinationVC.modalPresentationStyle = .pageSheet
    currentVC.present(destinationVC, animated: true)
}





func showAlert(title: String, message: String, viewController: UIViewController, completion: @escaping ()->()) {


    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {_ in
        completion()
    }))
    viewController.present(alert, animated: true, completion: nil)
}



