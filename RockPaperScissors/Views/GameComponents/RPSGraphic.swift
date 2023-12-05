//
//  RPSGraphic.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/5/23.
//

import SwiftUI

struct RPSGraphic: View {
    let playerChoice: WeaponOfChoice
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(Color.theme.backgroundColor)
            VStack(spacing: 0) {
                Image(playerChoice.description)
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .font(.largeTitle)
                Text(playerChoice.description)
                    .foregroundColor(Color.theme.text)
            }
            .padding(25)
            .padding(.horizontal, 25)
        }
        .fixedSize()
    }
}

struct RPSGraphic_Previews: PreviewProvider {
    static var previews: some View {
        RPSGraphic(playerChoice: .rock)
    }
}
