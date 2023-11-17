import SwiftUI
import GoogleMobileAds

class AdsViewModel: ObservableObject {
    
    static let shared = AdsViewModel()
    @Published var interstitial = InterstitialAdManager.Interstitial()
    @Published var interstitialCounter = 0 {
        didSet {
            if interstitialCounter >= 5 {
                showInterstitial = true
                interstitialCounter = 0
            }
        }
    }
    
    
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }
    }
}
