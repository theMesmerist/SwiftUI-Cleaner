//
//  SmartCleanerApp.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 1.06.2022.
//

import SwiftUI
import CoreData

@main
struct SmartCleanerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            
            if !uDefaults.bool(forKey: "isUserFirst"){
                OnboardingView()
            } else{
                MainView().environment(\.managedObjectContext, dataController.container.viewContext)
            }
         
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
}
