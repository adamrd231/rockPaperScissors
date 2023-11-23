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

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case inAppPurchases
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .inAppPurchases: return "In-App Purchases"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "play.fill"
        case .inAppPurchases: return "creditcard.fill"

        }
    }
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
    @State var selectedTab = 0
    
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
                    TabView(selection: $selectedTab) {
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
                        
                        InAppPurchaseView(storeManager: storeManager)
                            .tag(1)
                            .background(BackgroundHelper())
                        
                    }
                    ZStack {
                        HStack {
                            ForEach((TabbedItems.allCases), id: \.self) { item in
                                Button {
                                    selectedTab = item.rawValue
                                } label: {
                                    customTabbedItem(imageName: item.iconName, title: item.title, isActive: selectedTab == item.rawValue)
                                }
                            }
                        }
                    }
                    .background(Color.theme.backgroundColor.opacity(0.4))
                    .toolbarBackground(.blue, for: .tabBar)
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

extension ContentView {
    func customTabbedItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color.theme.text : Color.theme.text.opacity(0.6))
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? Color.theme.text : Color.theme.text.opacity(0.6))
            }
            Spacer()
        }
        .padding()

        .frame(width: isActive ? .infinity : UIScreen.main.bounds.width * 0.3, height: 80)
        .background(isActive ? Color.theme.backgroundColor.opacity(0.5) : Color.theme.backgroundColor.opacity(0))


    }
}
