//
//  EndGameView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/4/23.
//

import SwiftUI

struct EndGameView: View {
    let result: GameResult
    @EnvironmentObject var computerVM: VsComputerViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.theme.backgroundColor)
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.theme.blue)
                    Rectangle()
                        .foregroundColor(Color.theme.blue)
                        .offset(y: 10)
                    Text("You \(result.description)")
                        .padding()
                        .textCase(.uppercase)
                        .font(.title2)
                        .padding(.top, 5)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.backgroundColor)
                }

                HStack {
                    VStack {
                        if let playerChoice = computerVM.match.player1.weaponOfChoice {
                            Text("You")
                                .foregroundColor(Color.theme.text)
                            Image(playerChoice.description)
                                .resizable()
                                .frame(width: 75, height: 75)
                        }
                    }
                    VStack {
                        if let computerChoice = computerVM.match.player2.weaponOfChoice {
                            Text("Comp")
                                .foregroundColor(Color.theme.text)
                            Image(computerChoice.description)
                                .resizable()
                                .frame(width: 75, height: 75)
                        }
                    }
                }
                .padding()
                Button {
                    // Reset game
                    computerVM.startNewGame()
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color.theme.blue)
                        Text("Play again?")
                            .bold()
                            .foregroundColor(Color.theme.backgroundColor)
                            .padding()
                    }
                    .fixedSize()
                    .padding(.bottom)
                }
            }
            .foregroundColor(Color.theme.backgroundColor)
        }
        .fixedSize()
        .offset(y: -50)
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(result: .tie)
            .environmentObject(VsComputerViewModel())
    }
}