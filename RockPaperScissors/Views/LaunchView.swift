import SwiftUI

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
                Button {
                    // bring to game
                    computerVM.inGame = true
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color(.systemGray))
                        Text("Play Computer")
                            .foregroundColor(Color(.systemGray6))
                            .padding()
                    }
                    .fixedSize()
                }
                Button {
                    // bring to game
                    vm.startMatchmaking()
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color(.systemGray))
                        Text("Matchmaking")
                            .foregroundColor(Color(.systemGray6))
                            .padding()
                    }
                    .fixedSize()
                }
                .disabled(vm.authenticationState != .authenticated || vm.inGame)
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
