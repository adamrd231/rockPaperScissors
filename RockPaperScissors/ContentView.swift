import SwiftUI

enum PlayerAuthState: String {
    case authenticating = "Logging into Game Center..."
    case unauthenticated = "Please sign into game center to play against people"
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games."
}



struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ZStack {
            if vm.isGameOver {
                Text("Game Over")
            } else if vm.inGame {
                RPSvsPersonView(vm: vm)
            } else {
                LaunchView(vm: vm)
            }
        }
        .onAppear {
            vm.authenticateUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ViewModel())
    }
}
