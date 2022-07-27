//
//  AdmobHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import GoogleMobileAds

final class SwiftyAdsRequestBuilder {}

extension SwiftyAdsRequestBuilder: SwiftyAdsRequestBuilderType {

    func build() -> GADRequest {
        GADRequest()
    }
}

class AdmobHandler{
    
    func configureAdmob(window: UIWindow){
    
        if let rootViewController = window.rootViewController {
            configureSwiftyAds(from: rootViewController)
        }
    
}
    
    private func configureSwiftyAds(from viewController: UIViewController) {
        #if DEBUG
        // testDeviceIdentifiers: The test device identifiers used for debugging purposes.
        // consentConfiguration: The debug consent configuration:
        //    1) .default(geography: UMPDebugGeography),
        //    2) .resetOnLaunch(geography: UMPDebugGeography)
        //    3) .disabled
            
        let environment: SwiftyAdsEnvironment = .development(testDeviceIdentifiers: [], consentConfiguration: .resetOnLaunch(geography: .EEA))
        #else
        let environment: SwiftyAdsEnvironment = .production
        #endif
        
        SwiftyAds.shared.configure(
            from: viewController,
            for: environment,
            requestBuilder: SwiftyAdsRequestBuilder(),
            mediationConfigurator: nil, // set to nil if no mediation is required
            consentStatusDidChange: { status in
                print("The consent status has changed")
            },
            completion: { result in
                switch result {
                case .success(let consentStatus):
                    print("Configure successful")
                    // Ads will preload and sohuld be ready for displaying
                case .failure(let error):
                    print("Setup error: \(error)")
                }
            }
        )
    }
    
}
