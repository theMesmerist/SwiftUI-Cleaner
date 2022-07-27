//
//  AppDelegate.swift
//  BlockingApp
//
//  Created by Neon Apps on 5/25/20.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import CoreData
import StoreKit
import SwiftUI
import UIKit
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        get_prices_from_uDefaults()
        StoreKitOperations().configureStoreKit()
        StoreKitOperations().setPrices()
        IntegrationHandler().configureIntegrations(launchOptions: launchOptions, window: window!)
        isFreeUser = uDefaults.bool(forKey: "isUserFree")
        rememberUser()
        
        if UIDevice().userInterfaceIdiom == .pad {
            isIpad = true
        }
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
          The persistent container for the application. This implementation
          creates and returns a container, having loaded the store for the
          application to it. This property is optional since there are legitimate
          error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BlockingApp")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func get_prices_from_uDefaults() {
        if let price_weekly_uDefault = uDefaults.object(forKey: "priceWeekly") as? String {
            priceMonthly = price_weekly_uDefault
        }
        if let price_annual_uDefault = uDefaults.object(forKey: "priceAnnual") as? String {
            priceAnnual = price_annual_uDefault
        }
    }
    
    func rememberUser() {
        let user = uDefaults.object(forKey: "userFirst")
    
        if user != nil {
            if #available(iOS 13.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    if #available(iOS 14.0, *) {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
                
            print("dfsfsdsf", user!)
        
            let board = UIStoryboard(name: "Main", bundle: nil)
     
            if StoreKitOperations().isSubscribed() || isFreeUser {
                print("KULLANICI PREMIUM")
                let board = UIStoryboard(name: "Main", bundle: nil)
                let main = board.instantiateViewController(withIdentifier: "Main") as? Main
                window?.rootViewController = main
            
            } else {
                let board = UIStoryboard(name: "Main", bundle: nil)
                let shop = board.instantiateViewController(withIdentifier: "inApp") as? inApp
                window!.rootViewController = shop
            
//            let swiftUIView = OnboardingView() // swiftUIView is View
//            let viewCtrl = UIHostingController(rootView: swiftUIView)
//            window!.rootViewController = viewCtrl
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { _, _ in
                // ...
                UserDefaults.standard.set(true, forKey: "isUserFree")
                isFreeUser = true
                
                let board = UIStoryboard(name: "Main", bundle: nil)
                let main = board.instantiateViewController(withIdentifier: "onBoarding1") as? onBoarding1
                self.window?.rootViewController = main
                
                
            }

        return handled
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
    {
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey
                               .sourceApplication] as? String,
                           annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool
    {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
        
            return true
        }
        return false
    }
}
