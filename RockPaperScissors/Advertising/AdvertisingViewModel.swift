import SwiftUI
import GoogleMobileAds

class AdsViewModel: ObservableObject {
    
    static let shared = AdsViewModel()
    @Published var interstitial = InterstitialAdManager.Interstitial()
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
