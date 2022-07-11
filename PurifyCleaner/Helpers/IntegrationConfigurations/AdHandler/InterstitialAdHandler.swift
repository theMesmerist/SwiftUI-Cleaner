//
//  InterstitialAdHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import UIKit

class InterstitialAdHandler{

    func showInterstitialAd(VC : UIViewController, onClose : @escaping () -> () ){
    
    SwiftyAds.shared.showInterstitialAd(
        from: VC,
        afterInterval: nil, // 2 for every 2nd time method is called ad will be displayed. Set to nil to always display.
        onOpen: {
            freeCount += 1
            UserDefaults.standard.set(freeCount, forKey: "freeCount")
        },
        onClose: {
            onClose()
        },
        onError: { error in
            onClose()
        }
    )
    
}

}
