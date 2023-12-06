import SwiftUI

struct LaunchView: View {
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Image("title")
                .resizable()
                .frame(width: 150, height: 200)
                .padding()

            BasicMainButton(
                title: "Play Computer",
                icon: "play.fill",
                background: Color.theme.backgroundColor,
                function: { vsComputerViewModel.inGame = true }
            )
            BasicMainButton(
                title: "Matchmaking",
                icon: "play",
                background: Color.theme.backgroundColor,
                function: { vsPersonViewModel.startMatchmaking() }
            )
            .disabled(vsPersonViewModel.authenticationState != .authenticated || vsPersonViewModel.inGame)
            .opacity(vsPersonViewModel.authenticationState != .authenticated ? 0.66 : 1.0)
            
            BasicMainButton(
                title: "Leaderboard",
                icon: "star.leadinghalf.filled",
                background: Color.theme.backgroundColor,
                function: { vsPersonViewModel.showLeaderboards() }
            )
            .disabled(vsPersonViewModel.authenticationState != .authenticated || vsPersonViewModel.inGame)
            .opacity(vsPersonViewModel.authenticationState != .authenticated ? 0.66 : 1.0)
            
            if vsPersonViewModel.authenticationState == .unauthenticated || vsPersonViewModel.authenticationState == .authenticating || vsPersonViewModel.authenticationState == .error {
                Button(vsPersonViewModel.authenticationState == .error ?  "Use phone to login to game center" : "Log into Game Center") {
                    if vsPersonViewModel.authenticationState == .error {
                        vsPersonViewModel.goToGameCenter()
                    } else {
                        vsPersonViewModel.authenticateUser()
                    }
                }
                .buttonStyle(.borderedProminent)
                Text(vsPersonViewModel.authenticationState.rawValue)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 200)
                    .foregroundColor(Color.black.opacity(0.8))
            }
            Spacer()
            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                Banner()
            }
        }
        .onAppear {
            vsPersonViewModel.authenticateUser()
        }
        .padding()
        .alert("Opponent left game", isPresented: $vsPersonViewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(
            vsPersonViewModel: VsPersonViewModel(),
            vsComputerViewModel: VsComputerViewModel(),
            storeManager: StoreManager()
        )
    }
}



