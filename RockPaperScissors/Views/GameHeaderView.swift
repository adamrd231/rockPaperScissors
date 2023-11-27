//
//  GameHeaderView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/27/23.
//

import SwiftUI

struct GameHeaderView: View {
    
    var returnFunction: () -> Void
    var currentStreak: Int
    var rightHandFunction: () -> Void
    var showRewardedAd: () -> Void
    @Binding var isResettingStreak: Bool
    
    var body: some View {
        HStack {
            Button {
//                computerVM.inGame = false
                returnFunction()
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "arrowtriangle.backward.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
                .foregroundColor(Color.theme.text)
            }
 
      
            VStack {
                Text(currentStreak > -1 ? "Wins" : "Loses")
                Text(currentStreak, format: .number)
                    .font(.largeTitle)
            }
            .bold()
     
    
            Button {
                // Reset streak counter to 0
//                computerVM.isResettingStreak.toggle()
                rightHandFunction()
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)

                }
                .foregroundColor(Color.theme.text)
            }
//                .disabled(admobVM.rewarded.rewardedAd == nil)
            .alert("Watch ad to reset streak?", isPresented: $isResettingStreak) {
                Button {
//                    computerVM.showRewardedAd()
                    showRewardedAd()
                } label: {
                    Text("Im sure")
                }
                Button {
                    
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text("Are you sure, this can not be un-done?")
            }
            .statusBar(hidden: true)

        }
        .padding()
        .padding(.top, 35)
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView(
            returnFunction: { print("") },
            currentStreak: 1,
            rightHandFunction: { print("") },
            showRewardedAd: {},
            isResettingStreak: .constant(false)
        )
    }
}
