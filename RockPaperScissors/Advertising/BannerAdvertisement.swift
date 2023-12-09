import SwiftUI
import GoogleMobileAds
import UIKit

private struct BannerVC: UIViewControllerRepresentable  {
    
    private struct BannerAdMobConstant {
        #if DEBUG
            static var bannerID = "ca-app-pub-3940256099942544/2934735716"
        #else
            static var bannerID = "ca-app-pub-4186253562269967/7129641862"
        #endif
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = BannerAdMobConstant.bannerID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner:View{
    var body: some View{
//        #if !DEBUG
        BannerVC()
            .frame(width: 320, height: 70, alignment: .center)
//        #endif
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
