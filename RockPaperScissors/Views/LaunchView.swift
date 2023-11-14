import SwiftUI

struct LaunchButtonView: View {
    
    var title: String
    var function: () -> Void
    
    var body: some View {
        Button {
            // bring to game
//            computerVM.inGame = true
            function()
        } label: {
            ZStack {
                Capsule()
                    .foregroundColor(Color(.systemGray))
                    .frame(minWidth: 200)
                Text(title)
                    .foregroundColor(Color(.systemGray6))
                    .padding()
            }
            .fixedSize()
        }
    }
}

struct LaunchView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var computerVM: VsComputerViewModel
    
    var body: some View {
        ZStack {
            ZStack {
                Image("rockPaperScissorsBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                   
                Image("rockPaperScissorsText")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .offset(y: -80)
            }
           
            VStack {
                Spacer()
                LaunchButtonView(title: "Play Computer", function: { computerVM.inGame = true })
                LaunchButtonView(title: "Matchmaking", function: {
                    vm.startMatchmaking()
                    
                })
                .disabled(vm.authenticationState != .authenticated || vm.inGame)
                LaunchButtonView(title: "Leaderboard", function: {
                    // Go to leaderboard
                    
                })
                LaunchButtonView(title: "In-App Purchases", function: {
                    // Go to in app purchases
                    
                })
                
                Text(vm.authenticationState.rawValue)
                    .font(.headline)
                    .padding()
            }
            .padding(.bottom, 50)
        }
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
