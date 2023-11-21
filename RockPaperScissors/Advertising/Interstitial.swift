import SwiftUI
import GoogleMobileAds

class InterstitialAdManager: NSObject, ObservableObject {
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
        
        struct AdMobConstant {
            #if DEBUG
                static var interstitialID = "ca-app-pub-3940256099942544/4411468910"
                static var rewardedAd = "ca-app-pub-3940256099942544/1712485313"
            #else
                static var interstitialID = "ca-app-pub-4186253562269967/2739804861"
                static var rewardedAd = ""
            #endif
            
        }
    
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


