import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @StateObject var vsPersonViewModel = VsPersonViewModel()
    @StateObject var vsComputerViewModel = VsComputerViewModel()
    @StateObject var storeManager = StoreManager()
    @StateObject var adsVM = AdsViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.theme.tabViewBackground)
    }
    
    var body: some View {
        ZStack {
            Image("rockPaperScissorsBackground")
                .resizable()
                .scaledToFill()
                .clipped()
                .edgesIgnoringSafeArea(.all)
            
            if vsPersonViewModel.inGame {
                RPSvsPersonView(vsPersonViewModel: vsPersonViewModel)
            } else if vsComputerViewModel.inGame {
                RPSvsComputerView(
                    vsComputerViewModel: vsComputerViewModel,
                    vsPersonViewModel: vsPersonViewModel ,
                    adsVM: adsVM,
                    storeManager: storeManager
                )
            } else {
                TabView {
                    LaunchView(
                        vsPersonViewModel: vsPersonViewModel,
                        vsComputerViewModel: vsComputerViewModel,
                        storeManager: storeManager
                    )
                    .background(BackgroundHelper())
                    .tag(0)
                    .onAppear {
                        GADMobileAds.sharedInstance().start(completionHandler: nil)
                    }
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    
                    InAppPurchaseView(storeManager: storeManager)
                        .tag(1)
                        .background(BackgroundHelper())
                        .tabItem {
                            VStack {
                                Image(systemName: "creditcard.fill")
                                Text("In-app Purchases")
                            }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
