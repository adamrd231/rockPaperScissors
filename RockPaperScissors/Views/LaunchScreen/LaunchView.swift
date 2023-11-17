import SwiftUI

struct LaunchView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var computerVM: VsComputerViewModel
    
    var body: some View {
        VStack {
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
                
            })
            if vm.authenticationState == .unauthenticated || vm.authenticationState == .authenticating || vm.authenticationState == .error {
                Button("Log into Game Center") {
                    vm.authenticateUser()
                }
                .buttonStyle(.borderedProminent)
                Text(vm.authenticationState.rawValue)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 200)
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
            computerVM: VsComputerViewModel()
        )
    }
}
