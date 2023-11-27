import SwiftUI
import GoogleMobileAds

struct BackgroundHelper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            // find first superview with color and make it transparent
            var parent = view.superview
            repeat {
                if parent?.backgroundColor != nil {
                    parent?.backgroundColor = UIColor.clear
                    break
                }
                parent = parent?.superview
            } while (parent != nil)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

enum PlayerAuthState: String {
    case authenticating = "Logging into Game Center..."
    case unauthenticated = "Please sign into game center to play against people"
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games."
}

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @StateObject var computerVM = VsComputerViewModel()
    @StateObject var storeManager = StoreManager()
    @StateObject var admobVM = AdsViewModel()
    
    var body: some View {
        ZStack {
            Image("rockPaperScissorsBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
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
                VStack {
                    TabView {
                        LaunchView(
                            vm: vm,
                            computerVM: computerVM,
                            storeManager: storeManager
                        )
                        .background(BackgroundHelper())
                        .toolbarBackground(.blue, for: .tabBar)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
