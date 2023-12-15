import SwiftUI
import GoogleMobileAds
import Combine

class AdsViewModel: ObservableObject {
    
    static let shared = AdsViewModel()
    @Published var interstitial = InterstitialAdManager.Interstitial()
    @Published var showedRewarded: Bool = false
    @Published var interstitialCounter = 0 {
        
        didSet {
            if interstitialCounter >= 10 {
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
