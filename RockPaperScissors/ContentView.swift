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
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth:UIScreen.main.bounds.width,
                       maxHeight: UIScreen.main.bounds.height - 30
                )
            
            if vsPersonViewModel.inGame {
                RPSvsPersonView(
                    vsPersonViewModel: vsPersonViewModel,
                    adsVM: adsVM,
                    storeManager: storeManager
                )
            } else if vsComputerViewModel.inGame {
                RPSvsComputerView(
                    vsComputerViewModel: vsComputerViewModel,
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
                    
                    GameOverviewView(
                        vsComputerViewModel: vsComputerViewModel
                    )
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Scores")
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
