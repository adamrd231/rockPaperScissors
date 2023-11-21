import SwiftUI

struct LaunchView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var computerVM: VsComputerViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        VStack {
            Spacer()
            Image("title")
                .resizable()
                .frame(width: 200, height: 300)
                .padding()

            LaunchButtonView(title: computerVM.streak > -1 ? "Play Computer +\(computerVM.streak)" : "Play Computer \(computerVM.streak)", function: { computerVM.inGame = true })
            LaunchButtonView(title: "Matchmaking", function: {
                vm.startMatchmaking()
                
            })
            .disabled(vm.authenticationState != .authenticated || vm.inGame)
            .opacity(vm.authenticationState != .authenticated ? 0.66 : 1.0)
            
            LaunchButtonView(title: "Leaderboard", function: {
                // Go to leaderboard
                vm.showLeaderboards()
                
            })
            .disabled(vm.authenticationState != .authenticated || vm.inGame)
            .opacity(vm.authenticationState != .authenticated ? 0.66 : 1.0)
            
            LaunchButtonView(title: "In-App Purchases", function: {
                // Go to in app purchases
                storeManager.isViewingStore = true
            })
            
            if vm.authenticationState == .unauthenticated || vm.authenticationState == .authenticating || vm.authenticationState == .error {
                Button(vm.authenticationState == .error ?  "Use phone to login to game center" : "Log into Game Center") {
                    print("Test0")
                    if vm.authenticationState == .error {
                        vm.goToGameCenter()
                    } else {
                        vm.authenticateUser()
                    }
                   
                }
                .buttonStyle(.borderedProminent)
                Text(vm.authenticationState.rawValue)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 200)
            }
               
            Spacer()
            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                Banner()
            }
        }
        .onAppear {
            vm.authenticateUser()
        }
        .padding()
        .alert("Opponent left game", isPresented: $vm.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(
            vm: ViewModel(),
            computerVM: VsComputerViewModel(),
            storeManager: StoreManager()
        )
    }
}
