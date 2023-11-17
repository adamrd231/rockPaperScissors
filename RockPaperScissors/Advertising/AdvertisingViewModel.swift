import SwiftUI
import GoogleMobileAds
import Combine

class AdsViewModel: ObservableObject {
    
    static let shared = AdsViewModel()
    @Published var interstitial = InterstitialAdManager.Interstitial()
    @Published var showedRewarded: Bool = false
    @Published var rewarded = InterstitialAdManager.Rewarded()

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
    @Published var showRewarded = false {
        didSet {
            if showRewarded {
                rewarded.showRewardedAd()
                showRewarded = false
            }
        }
    }
    
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        rewarded.$showedRewardedAd
            .sink { returnedRewardedAdStatus in
                print("FInished showing rewarded ad")
                self.showedRewarded = true
                
            }
            .store(in: &cancellable)
    }
}
