//
//  RockPaperScissorsView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/11/23.
//

import SwiftUI

struct RockPaperScissorsView: View {
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
            HStack {
                if let choice = vm.userChoice {
                    VStack {
                        Text("You chose:")
                        Text(choice.description)
                        Text(choice.emoji)
                    }
                }
                if let choice = vm.computerChoice {
                    VStack {
                        Text("Computer chose:")
                        Text(choice.description)
                        Text(choice.emoji)
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

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView(vm: ViewModel())
    }
}
