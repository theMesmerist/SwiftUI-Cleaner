//
//  FullScreenPresent.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 15.06.2022.
//

import SwiftUI

extension View {
    func uiKitFullPresent<V: View>(isPresented: Binding<Bool>, animated: Bool = true, transitionStyle: UIModalTransitionStyle = .coverVertical, presentStyle: UIModalPresentationStyle = .fullScreen, content: @escaping (_ dismissHandler: @escaping (_ completion: @escaping () -> Void) -> Void) -> V) -> some View {
        self.modifier(FullScreenPresent(isPresented: isPresented, animated: animated, transitionStyle: transitionStyle, presentStyle: presentStyle, contentView: content))
    }
    
    func uiKitFullPresent<V: View>(isPresented: Binding<Bool>, animated: Bool = true, customTransitionDelegate: UIViewControllerTransitioningDelegate, content: @escaping (_ dismissHandler: @escaping (_ completion: @escaping () -> Void) -> Void) -> V) -> some View {
        self.modifier(FullScreenPresent(isPresented: isPresented, animated: animated, transitioningDelegate: customTransitionDelegate, contentView: content))
    }
}

struct FullScreenPresent<V: View>: ViewModifier {
    typealias ContentViewBlock = (_ dismissHandler: @escaping (_ completion: @escaping () -> Void) -> Void) -> V
    
    @Binding var isPresented: Bool
    @State private var isAlreadyPresented: Bool = false

    let animated: Bool
    var transitionStyle: UIModalTransitionStyle = .coverVertical
    var presentStyle: UIModalPresentationStyle = .fullScreen
    let contentView: ContentViewBlock
    
    private var transitioningDelegate: UIViewControllerTransitioningDelegate? = nil
    
    init(isPresented: Binding<Bool>, animated: Bool, transitionStyle: UIModalTransitionStyle, presentStyle: UIModalPresentationStyle, contentView: @escaping ContentViewBlock) {
        self._isPresented = isPresented
        self.animated = animated
        self.transitionStyle = transitionStyle
        self.presentStyle = presentStyle
        self.contentView = contentView
    }
    
    init(isPresented: Binding<Bool>, animated: Bool, transitioningDelegate: UIViewControllerTransitioningDelegate, contentView: @escaping ContentViewBlock) {
        self._isPresented = isPresented
        self.animated = animated
        self.transitioningDelegate = transitioningDelegate
        self.contentView = contentView
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            contentIOS14(content)
        } else {
            contentDefault(content)
        }
    }
    
    // Changed implementation
    @available(iOS 14, *)
    func contentIOS14(_ content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                if isPresented {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        let topMost = UIViewController.topMost
                        let rootView = contentView({ [weak topMost] completion in
                            topMost?.dismiss(animated: animated) {
                                completion()
                                isPresented = false
                            }
                        })
                        let hostingVC = UIHostingController(rootView: rootView)
                        
                        if let customTransitioning = transitioningDelegate {
                            hostingVC.modalPresentationStyle = .custom
                            hostingVC.transitioningDelegate = customTransitioning
                        } else {
                            hostingVC.modalPresentationStyle = presentStyle
                            if presentStyle == .overFullScreen {
                                hostingVC.view.backgroundColor = .clear
                            }
                            hostingVC.modalTransitionStyle = transitionStyle
                        }
                        
                        topMost?.present(hostingVC, animated: animated, completion: nil)
                    }
                }
            }
    }
    
    // Same as current implementation
    func contentDefault(_ content: Content) -> some View {
        Group {
            if isPresented {
                content
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                            if isAlreadyPresented == false {
                                let topMost = UIViewController.topMost
                                let rootView = contentView({ [weak topMost] completion in
                                    topMost?.dismiss(animated: animated) {
                                        isPresented = false
                                        isAlreadyPresented = false
                                        completion()
                                    }
                                })
                                
                                let hostingVC = UIHostingController(rootView: rootView)
                                
                                if let customTransitioning = transitioningDelegate {
                                    hostingVC.modalPresentationStyle = .custom
                                    hostingVC.transitioningDelegate = customTransitioning
                                } else {
                                    hostingVC.modalPresentationStyle = presentStyle
                                    if presentStyle == .overFullScreen {
                                        hostingVC.view.backgroundColor = .clear
                                    }
                                    hostingVC.modalTransitionStyle = transitionStyle
                                }
                                
                                topMost?.present(hostingVC, animated: animated) {
                                    isAlreadyPresented = true
                                }
                            }
                        }
                    }
            } else {
                content
            }
        }
    }
}

extension UIViewController {
    static var topMost: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
