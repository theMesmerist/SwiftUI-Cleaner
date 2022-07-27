//
//  BannerAdHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import UIKit


var bannerAd: SwiftyAdsBannerType?

class BannerAdHandler{

    func showBannerAd(VC : UIViewController){
    
    bannerAd = SwiftyAds.shared.makeBannerAd(
           in: VC,
           adUnitIdType: .plist, // set to `.custom("AdUnitId")` to add a different AdUnitId for this particular banner ad
           position: .bottom(isUsingSafeArea: false), // banner is pinned to bottom and follows the safe area layout guide
           animation: .slide(duration: 1.5),
           onOpen: {
               print("SwiftyAds banner ad did receive ad and was opened")
           },
           onClose: {
               print("SwiftyAds banner ad did close")
           },
           onError: { error in
               print("SwiftyAds banner ad error \(error)")
           },
           onWillPresentScreen: {
               print("SwiftyAds banner ad was tapped and is about to present screen")
           },
           onWillDismissScreen: {
               print("SwiftyAds banner ad presented screen is about to be dismissed")
           },
           onDidDismissScreen: {
               print("SwiftyAds banner did dismiss presented screen")
           }
       )
    
    bannerAd?.show(isLandscape: VC.view.frame.width > VC.view.frame.height)
    
}

}
