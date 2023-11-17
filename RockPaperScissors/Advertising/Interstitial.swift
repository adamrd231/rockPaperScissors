import SwiftUI
import GoogleMobileAds

class InterstitialAdManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        #if DEBUG
            static var interstitialID = "ca-app-pub-3940256099942544/4411468910"
            static var rewardedAd = "ca-app-pub-3940256099942544/1712485313"
        #else
            static var interstitialID = "ca-app-pub-4186253562269967/2739804861"
            static var rewardedAd = ""
        #endif
        
    }
    
    final class Rewarded: NSObject, GADFullScreenContentDelegate, ObservableObject {
        private var rewardedAd: GADRewardedAd?
        @Published var showedRewardedAd: Bool = false
        var computerViewModel = VsComputerViewModel()
        override init() {
            super.init()
            loadRewardedAd()
        }
        
        func loadRewardedAd() {
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: AdMobConstant.rewardedAd,
                               request: request,
                               completionHandler: { [self] ad, error in
                if let e = error {
                    print("Failed to load rewarded ad with error \(e.localizedDescription)")
                }
               rewardedAd = ad
                return
            })
        }
        
        func showRewardedAd() {
            let root = UIApplication.shared.windows.last?.rootViewController
            
            if let ad = rewardedAd {
                ad.present(fromRootViewController: root!, userDidEarnRewardHandler: {
                    let reward = self.rewardedAd!.adReward
                    self.showedRewardedAd = true
                    print("Reward \(reward.type)")
                    print("Rewarding user!")
                })
            } else {
                print("Interstitial advertisement not ready")
            }
        }
        
        // Tells the delegate that the ad failed to present full screen content.
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
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
       

        override init() {
            super.init()
            requestInterstitialAds()
        }
        
        func requestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitialID, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            })
            
        }

        func showAd() {
            let root = UIApplication.shared.windows.last?.rootViewController
            if let fullScreenAds = interstitial {
                fullScreenAds.present(fromRootViewController: root!)
            } else {
                print("Interstitial advertisement not ready")
            }
        }
        
    }
}


