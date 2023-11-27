import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var computerVM: VsComputerViewModel
    @ObservedObject var vm: ViewModel
    @ObservedObject var admobVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        VStack {
            GameHeaderView(
                returnFunction: { computerVM.inGame = false },
                currentStreak: computerVM.streak,
                rightHandFunction: { computerVM.isResettingStreak.toggle() },
                showRewardedAd: { computerVM.showRewardedAd() },
                isResettingStreak: $computerVM.isResettingStreak
            )
            .alert("Watch ad to reset streak?", isPresented: $computerVM.isResettingStreak) {
                Button {
                    computerVM.showRewardedAd()
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
            
            Spacer(minLength: 0)

            if let result = computerVM.gameResult {
                if let choice = computerVM.userChoice,
                   let computerChoice = computerVM.computerChoice {
                    VStack {
                        Text(result.description)
                            .font(.largeTitle)
                            .padding()
                            .textCase(.uppercase)
                        HStack {
                            VStack {
                                Text("You chose:")
                                    .foregroundColor(Color.theme.backgroundColor)
                                Image(choice.description)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            VStack {
                                Text("Computer chose:")
                                    .foregroundColor(Color.theme.backgroundColor)
                                Image(computerChoice.description)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        Button("Play Again") {
                            computerVM.resetGame()
                            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                                admobVM.interstitialCounter += 1
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .onTapGesture {
                        computerVM.resetGame()
                        if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                            admobVM.interstitialCounter += 1
                        }
                       
                    }
                }
            } else {
                RockPaperScissorsView(computerVM: computerVM)
            }
            Spacer(minLength: 0)
            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                Banner()
            }
        }
        .onAppear {
            computerVM.loadRewardedAd()
        }
        .onDisappear {
            // TODO: Only send this if it's a high score?
            // If score is better than leaderboard overall, submit to overall
            // Update score for player of the week
            vm.submitScoreToLeaderBoard(newHighScore: computerVM.streak)
        }

    }
}

struct RPSvsComputerView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(
            computerVM: VsComputerViewModel(),
            vm: ViewModel(),
            admobVM: AdsViewModel(),
            storeManager: StoreManager()
        )
        .preferredColorScheme(.dark)
    }
}
