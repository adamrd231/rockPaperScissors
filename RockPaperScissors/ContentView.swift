import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @StateObject var computerVM = VsComputerViewModel()
    @StateObject var storeManager = StoreManager()
    @StateObject var admobVM = AdsViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.theme.tabViewBackground)
    }
    
    var body: some View {
        ZStack {
            Image("rockPaperScissorsBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if vm.isGameOver {
                Text("Game Over")
            } else if vm.inGame {
                RPSvsPersonView(vm: vm)
            } else if computerVM.inGame {
                RPSvsComputerView(
                    computerVM: computerVM,
                    vm: vm,
                    admobVM: admobVM,
                    storeManager: storeManager
                )
            } else {
                TabView {
                    LaunchView(
                        vm: vm,
                        computerVM: computerVM,
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
