//
//  RockPaperScissorsView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/11/23.
//

import SwiftUI

struct RPSvsComputerView: View {
    @ObservedObject var vm: VsComputerViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    vm.inGame = false
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
                Spacer()
                VStack {
                    Text(vm.streak > -1 ? "Wins" : "Loses")
                    Text(vm.streak, format: .number)
                        .font(.largeTitle)
                }
                .bold()
               
                Spacer()
                Button {
                    // Reset streak counter to 0
                    vm.streak = 0
                    // TODO: Make user watch an ad to do this
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
            }
            .padding()
            .padding(.top, 35)
          
            Spacer()
           
            
            
            if let result = vm.gameResult {
                if let choice = vm.userChoice,
                   let computerChoice = vm.computerChoice {
                    Text(result.description)
                        .font(.largeTitle)
                        .padding()
                        .textCase(.uppercase)
                    HStack {
                        VStack {
                            Text("You chose:")
                            Image(choice.description)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        VStack {
                            Text("Computer chose:")
                            Image(computerChoice.description)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                
                Button("Play Again") {
                    vm.userChoice = nil
                    vm.gameResult = nil
                    vm.computerChoice = vm.choices[Int.random(in: 0..<3)]
                }
                .buttonStyle(.bordered)
                
            } else {
                VStack {
                    ForEach(vm.choices, id: \.self) { choice in
                        Button {
                            // Play game
                            vm.userChoice = choice
                            vm.rockPaperScissors(choice, vm.computerChoice)
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
                        .disabled(vm.gameResult != nil)
                    }
                }
                .padding()
            }
            Spacer()
        }
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(vm: VsComputerViewModel())
    }
}
