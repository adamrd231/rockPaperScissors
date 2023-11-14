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
                VStack() {
                    ForEach(vm.choices, id: \.self) { choice in
                        Button {
                            vm.playGame(playerChoice: choice)
                        } label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(choice == vm.userChoice ? Color(.systemGray4) : Color(.systemGray6))
                                
                                VStack(spacing: 0) {
                                    
                                    Image(choice.description)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .font(.largeTitle)
                                    Text(choice.description)
                                }
                                .padding()
                                .frame(minWidth: 250, minHeight: 90)
                                .foregroundColor(Color(.systemGray))
                            }
                            .fixedSize()
                        }
                        .disabled(vm.userChoice != nil && vm.computerChoice != nil)
                    }
                }
                .onChange(of: vm.playAgain) { newValue in
                    if vm.playAgain && vm.playerWantsToPlayAgain {
                        vm.userChoice = nil
                        vm.computerChoice = nil
                        vm.playAgain = false
                        vm.playerWantsToPlayAgain = false
                        vm.gameResult = nil
                    }
                }
                .onChange(of: vm.playerWantsToPlayAgain) { newValue in
                    if vm.playAgain && vm.playerWantsToPlayAgain {
                        vm.userChoice = nil
                        vm.computerChoice = nil
                        vm.playAgain = false
                        vm.playerWantsToPlayAgain = false
                        vm.gameResult = nil
                    }
                }
            }
            Spacer()
            HStack {
                if let choice = vm.userChoice {
                    VStack {
                        Text("You chose:")
                        Image(choice.description)
                            .resizable()
                            .frame(width: 100, height: 100)
                    
                    }
                }
                if let _ = vm.userChoice,
                   let theirChoice = vm.computerChoice {
                    Text("VS")
                        .bold()
                    VStack {
                        Text("They chose:")
                        Image(theirChoice.description)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
        .padding()
        if let result = vm.gameResult {
            ZStack {
                Capsule()
                    .foregroundColor(Color(.black))
                VStack(spacing: 5) {
                    Text("RESULT")
                        .font(.caption)
                        .bold()
                    Text(result.description)
                        .font(.title)
                        .fontWeight(.heavy)
                    Button("Rematch?") {
                        vm.resetGame()
                    }
                    .buttonStyle(.bordered)
                    if vm.playAgain == true {
                        Text("Waiting for other player")
                            .font(.caption)
                    } else if vm.playerWantsToPlayAgain == true {
                        Text("Other player is ready")
                            .font(.caption)
                    }
                }
                .foregroundColor(.white)
                .frame(minWidth: 200)
                .padding()
            }
            .fixedSize()
        }
    }
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(vm: ViewModel())
    }
}
