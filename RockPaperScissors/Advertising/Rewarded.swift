//
//  Rewarded.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/20/23.
//

import Foundation
import GoogleMobileAds
import UIKit

class AdsViewController: UIViewController, GADFullScreenContentDelegate, ObservableObject {
    
    struct AdMobConstant {
#if DEBUG
        static var rewardedAdID = "ca-app-pub-3940256099942544/1712485313"
#else
        static var rewardedAdID = ""
#endif
        
    }
    
    @Published var rewardedAd: GADRewardedAd? = nil
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: AdMobConstant.rewardedAdID,
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error \(error)")
            }
            self.rewardedAd = ad
            print("Ad was loaded with reward \(rewardedAd?.adReward.type)")
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    func show() -> Bool {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            print("Root view controller is not setup")
            return false
        }
        
        print("PResenting from root view controller \(rootViewController)")
      if let ad = rewardedAd {
          print("ad")
        ad.present(fromRootViewController: rootViewController) {
          let reward = ad.adReward
          print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
          // TODO: Reward the user.
            
        }
        return true
      } else {
        print("Ad wasn't ready")
          return false
      }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad will present full screen content.
      func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
}

