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
        ZStack {
            Image("rockPaperScissorsBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(vm.streak > -1 ? "Wins" : "Loses")
                Text(vm.streak, format: .number)
                VStack {
                    ForEach(vm.choices, id: \.self) { choice in
                        Button {
                            // Play game
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
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(vm: VsComputerViewModel())
    }
}
