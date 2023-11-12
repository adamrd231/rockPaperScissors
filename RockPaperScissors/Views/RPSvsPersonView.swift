//
//  RPSvsPersonView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/11/23.
//

import SwiftUI

struct RPSvsPersonView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Text(vm.streak, format: .number)
            Text("Choose")
            HStack {
                ForEach(vm.choices, id: \.self) { choice in
                    Button {
                        vm.playGame(playerChoice: choice)
                    } label: {
                        HStack {
                            Text(choice.description)
                            Text(choice.emoji)
                        }
                    }
                }
            }
            if let choice = vm.userChoice,
               let theirChoice = vm.computerChoice {
                HStack {
                    VStack {
                        Text("You chose:")
                        Text(choice.description)
                        Text(choice.emoji)
                    }
                    VStack {
                        Text("they chose:")
                        Text(theirChoice.description)
                        Text(theirChoice.emoji)
                    }
                }
            }
            
            
            
            
    
            if let result = vm.gameResult {
                Text(result.description)
            }
        }
        .padding()
    }
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(vm: ViewModel())
    }
}
