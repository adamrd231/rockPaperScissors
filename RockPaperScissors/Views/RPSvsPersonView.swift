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
                        .bold()
                    Text(vm.remainingTime, format: .number)
                }
                Spacer()
                VStack {
                    Text("Current score")
                        .bold()
                    Text(vm.streak, format: .number)
                }
            }
            .padding()
           Spacer()
            VStack {
                VStack(spacing: 10) {
                    ForEach(vm.choices, id: \.self) { choice in
                        Button {
                            vm.playGame(playerChoice: choice)
                        } label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(Color(.systemGray))
                                
                                VStack {
                                    Text(choice.emoji)
                                        .font(.largeTitle)
                                    Text(choice.description)
                                }
                                .frame(minWidth: 150, minHeight: 90)
                                .foregroundColor(Color(.systemGray6))
                            }
                            .fixedSize()
                        }
                        .disabled(vm.remainingTime <= 0)
                    }
                }
            }
            Spacer()
       
            HStack {
                if let choice = vm.userChoice {
                    VStack {
                        Text("You chose:")
                        Text(choice.description)
                        Text(choice.emoji)
                    
                    }
                }
                if let choice = vm.userChoice,
                   let theirChoice = vm.computerChoice {
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
                    vm.resetGame()
                }
            }
        }
        .padding()
        .onReceive(vm.countdownTimer) { _ in
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
