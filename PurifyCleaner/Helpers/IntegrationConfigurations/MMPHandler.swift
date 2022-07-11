//
//  MMPHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import Adjust
import YandexMobileMetrica
import Branch

enum MMPOptions{
    case adjust
    case branch
    case appMetrica
}

var selectedMMP = MMPOptions.adjust


class MMPHandler{
    
    func configureMMP(launchOptions : [UIApplication.LaunchOptionsKey: Any]?){
        
        
        switch selectedMMP {
        case .adjust:
            configureAdjust()
        case .branch:
            configureBranch(launchOptions: launchOptions)
        case .appMetrica:
            configureAppMetrica()
        }
        
    }
    
    func configureAdjust(){
        
        
        let appToken = IntegrationHandler().adjustAppToken
        let environment = ADJEnvironmentProduction
        let adjustConfig = ADJConfig(appToken: appToken, environment: environment)
        Adjust.appDidLaunch(adjustConfig!)
       
    }
    
    
    func configureBranch(launchOptions : [UIApplication.LaunchOptionsKey: Any]?){
        
       

          Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
              
          }
    }
    
    func configureAppMetrica(){
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: IntegrationHandler().appMetricaAPIKey)
         YMMYandexMetrica.activate(with: configuration!)
        
    }
    
    
    func configurePurchasely(){
        
    }
    
    
}
