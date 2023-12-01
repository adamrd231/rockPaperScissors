//
//  RockPaperScissorsView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/27/23.
//

import SwiftUI

struct RockPaperScissorsView: View {
    
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    let computerVM: VsComputerViewModel
    
    var body: some View {
        VStack {
            ForEach(choices, id: \.self) { choice in
                Button {
                    // Play game
                    computerVM.gameModel.player.weaponOfChoice = choice
//                    computerVM.rockPaperScissors(choice, computerVM.computerChoice)
                } label: {
                    RPSGraphic(playerChoice: choice)
                }
//                .disabled(computerVM.gameResult != nil)
            }
        }
        .padding()
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView(computerVM: VsComputerViewModel())
    }
}
