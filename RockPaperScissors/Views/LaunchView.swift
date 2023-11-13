import SwiftUI

struct LaunchView: View {
    @ObservedObject var vm: ViewModel
    
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

        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(vm: ViewModel())
    }
}
