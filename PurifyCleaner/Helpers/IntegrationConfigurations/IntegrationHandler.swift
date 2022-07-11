//
//  AdjustHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import Firebase
import AppTrackingTransparency

class IntegrationHandler{
    
    var adjustAppToken = ""
    var appMetricaAPIKey = ""

    
    func configureIntegrations(launchOptions : [UIApplication.LaunchOptionsKey: Any]?, window : UIWindow){
        
        
        getValuesFromPlist()
        FirebaseApp.configure()
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = Bundle.main.bundleIdentifier
        requestIDFA()
        RemoteConfigOperations().configure_remote_config_operations()
        MMPHandler().configureMMP(launchOptions: launchOptions)
        AdmobHandler().configureAdmob(window: window)
       
      
       
    }
    
    func requestIDFA(){
        
        if #available(iOS 14, *) {
           ATTrackingManager.requestTrackingAuthorization { status in
             if status == .authorized {
              
             }else{
                 
                
             }
           }
         }
         
      }
    
    func getValuesFromPlist()
    {
        if let path = Bundle.main.path(forResource: "Integrations", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path)
        {
            let plist =  (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as! [String :  String]
            
            guard let adjustAppTokenTemp = plist["adjustAppToken"] else{
                fatalError("Adjust token not exist in Integrations.plist")
            
            }
            adjustAppToken = adjustAppTokenTemp
            
            guard let aappMetricaAPIKeyTemp = plist["appMetricaAPIKey"] else{
                fatalError("App Metrica API key not exist in Integrations.plist")
             
            }
            appMetricaAPIKey = aappMetricaAPIKeyTemp
            
            
             
        }
        
   
    }
    
  
        
}
