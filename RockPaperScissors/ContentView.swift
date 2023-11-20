import SwiftUI
import GoogleMobileAds

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
                .aspectRatio(contentMode: .fill)
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
          
            } else if storeManager.isViewingStore {
               InAppPurchaseView(storeManager: storeManager)
            } else {
                LaunchView(
                    vm: vm,
                    computerVM: computerVM,
                    storeManager: storeManager
                )
            }
            
        }
        .onAppear {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ViewModel())
    }
}
