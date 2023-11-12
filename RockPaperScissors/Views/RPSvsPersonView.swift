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
            HStack {
                VStack {
                    Text("Time:")
                    Text(vm.remainingTime, format: .number)
                }
                VStack {
                    Text("Current score")
                    Text(vm.streak, format: .number)
                }
            }
           
            VStack {
                VStack(spacing: 10) {
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
                .onChange(of: vm.userChoice) { newValue in
                    if let user = vm.userChoice,
                       let computer = vm.computerChoice {
                        vm.rockPaperScissors(user, computer)
                    }
                }
            }
            .onChange(of: vm.computerChoice) { newValue in
                if let user = vm.userChoice,
                   let computer = vm.computerChoice {
                    vm.rockPaperScissors(user, computer)
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
                Text("You" + result.description)
                Button("Play another game") {
         
                }
            }
        }
        .padding()
        .onReceive(vm.countdownTimer) { _ in
            print("isTimerKeeper: \(vm.isTimeKeeper)")
            guard vm.isTimeKeeper else { return }
            vm.remainingTime -= 1
        }
        
    }
        
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(vm: ViewModel())
    }
}
