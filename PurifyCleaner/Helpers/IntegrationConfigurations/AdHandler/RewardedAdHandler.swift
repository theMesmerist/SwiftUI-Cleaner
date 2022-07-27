//
//  RewardedAdHandler.swift
//  Mobile Arts Integrations
//
//  Created by Tuna Öztürk on 13.06.2022.
//

import Foundation
import UIKit

class RewardedAdHandler{

    func showRewardedAd(VC : UIViewController, onClose : @escaping (_ isRewardEarned : Bool) -> () ){
    
        var isRewardEarned = false
        
    SwiftyAds.shared.showRewardedAd(
        from: VC,
        onOpen: {
        },
        onClose: {
                onClose(isRewardEarned)
        },
        onError: { error in
            print("SwiftyAds rewarded ad error \(error)")
        },
        onNotReady: { [] in
            print("SwiftyAds rewarded ad was not ready")
            let alertController = UIAlertController(
                title: "Sorry",
                message: "No video available to watch at the moment.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            DispatchQueue.main.async {
                VC.present(alertController, animated: true)
            }
        },
        onReward: { [] rewardAmount in
            isRewardEarned = true
        }
    )
    
}

}
