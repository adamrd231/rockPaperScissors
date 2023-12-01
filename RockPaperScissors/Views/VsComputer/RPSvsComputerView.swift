import SwiftUI
import GameKit

struct RPSGraphic: View {
    let playerChoice: WeaponOfChoice
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(Color.theme.backgroundColor)
            VStack(spacing: 0) {
                Image(playerChoice.description)
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
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

struct RPSvsComputerView: View {
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        VStack {
            GameHeaderView(
                returnFunction: { vsComputerViewModel.inGame = false },
                currentStreak: vsComputerViewModel.gameModel.streak,
                rightHandFunction: { vsComputerViewModel.isResettingStreak.toggle() },
                showRewardedAd: { vsComputerViewModel.showRewardedAd() },
                isResettingStreak: $vsComputerViewModel.isResettingStreak
            )
            .onChange(of: vsComputerViewModel.gameModel.player.weaponOfChoice) { newValue in
                if let choice = newValue {
                    let result = vsComputerViewModel.gameModel.rockPaperScissors(choice, vsComputerViewModel.gameModel.computerPlayer.weaponOfChoice)
                    vsComputerViewModel.gameModel.gameResult = result
                    switch result {
                    case .lose: vsComputerViewModel.gameModel.streak -= 1
                    case .tie: print("Tie")
                    case .win: vsComputerViewModel.gameModel.streak += 1
                    }
                }
            }
            .alert("Watch ad to reset streak?", isPresented: $vsComputerViewModel.isResettingStreak) {
                Button {
                    vsComputerViewModel.showRewardedAd()
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

            // MARK: Game over screen
            ZStack {
                // MARK: Playing game
                RockPaperScissorsView(computerVM: vsComputerViewModel)
                if let playerChoice = vsComputerViewModel.gameModel.player.weaponOfChoice {
                    VStack {
                        if let result = vsComputerViewModel.gameModel.gameResult {
                            Text(result.description)
                                .font(.largeTitle)
                                .padding()
                                .textCase(.uppercase)
                        }

                        VStack {
                            RPSGraphic(playerChoice: playerChoice)
                            Text("VS")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            RPSGraphic(playerChoice: vsComputerViewModel.gameModel.computerPlayer.weaponOfChoice)
                        }
                        Button("Play Again") {
                            // Reset everything to start new game
                            vsComputerViewModel.startNewGame()
                            // If applicable, update counter for ads
                            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                                adsVM.interstitialCounter += 1
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .onTapGesture {
                        // Reset everything to start new game
                        vsComputerViewModel.startNewGame()
                        // If applicable, update counter for ads
                        if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                            adsVM.interstitialCounter += 1
                        }
                    }
                    .foregroundColor(Color.theme.backgroundColor)
                    .padding()
                    .background(Color.theme.text)
                    .cornerRadius(20)
                }
            }

            Spacer(minLength: 0)
            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                Banner()
            }
        }
        .onAppear {
            vsComputerViewModel.loadRewardedAd()
        }
        .onDisappear {
            // TODO: Only send this if it's a high score?
            // If score is better than leaderboard overall, submit to overall
            // Update score for player of the week
//            .submitScoreToLeaderBoard(newHighScore: computerVM.gameModel.streak)
        }

    }
}

struct RPSvsComputerView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(
            vsComputerViewModel: VsComputerViewModel(),
            vsPersonViewModel: VsPersonViewModel(),
            adsVM: AdsViewModel(),
            storeManager: StoreManager()
        )
        .preferredColorScheme(.dark)
    }
}
