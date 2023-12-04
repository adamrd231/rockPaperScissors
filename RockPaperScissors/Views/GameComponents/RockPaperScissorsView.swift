//
//  RockPaperScissorsView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/27/23.
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

struct RockPaperScissorsView: View {
    
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    @EnvironmentObject var computerVM: VsComputerViewModel
    let storeManager: StoreManager
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer(minLength: 0)
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
                Spacer(minLength: 0)
                if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                    Banner()
                }
            }
            
            if let result = computerVM.gameModel.gameResult {
                EndGameView(result: result)
                    .environmentObject(computerVM)
            }

        }
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView(
            storeManager: StoreManager()
        )
        .environmentObject(VsComputerViewModel())
    }
}
