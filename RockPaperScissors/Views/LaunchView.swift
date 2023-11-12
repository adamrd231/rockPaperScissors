import SwiftUI

struct LaunchView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Text("Rock, Paper, Scissors")
            Button("Play person") {
                // bring to game
                vm.startMatchmaking()
            }
            .disabled(vm.authenticationState != .authenticated || vm.inGame)
            Text(vm.authenticationState.rawValue)
                .font(.headline)
            
            Button("Play robot") {
                
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(vm: ViewModel())
    }
}
