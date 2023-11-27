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
                    computerVM.userChoice = choice
                    computerVM.rockPaperScissors(choice, computerVM.computerChoice)
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color.theme.backgroundColor)
           
                        VStack(spacing: 0) {
                            Image(choice.description)
                                .resizable()
                                .frame(maxWidth: 100, maxHeight: 100)
                                .font(.largeTitle)
                            Text(choice.description)
                                .foregroundColor(Color.theme.text)
                        }
                        .padding(25)
                        .padding(.horizontal, 25)
                    }
                    .fixedSize()
                }
                .disabled(computerVM.gameResult != nil)
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
