//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/10/23.
//

import SwiftUI

enum PlayerAuthState: String {
    case authenticating = "Logging into Game Center..."
    case unauthenticated = "Please sign into game center to play against people"
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games."
}

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    
    
    
    var body: some View {
        VStack {
            Text("Rock, Paper, Scissors")
            Button("Play person") {
                // bring to game
            }
            .disabled(vm.authenticationState != .authenticated || vm.inGame)
            Text(vm.authenticationState.rawValue)
                .font(.headline)
            
            Button("Play robot") {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ViewModel())
    }
}
