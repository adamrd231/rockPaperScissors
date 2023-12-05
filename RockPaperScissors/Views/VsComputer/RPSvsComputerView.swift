import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    func returnChoice(_ choice: WeaponOfChoice) {
        vsComputerViewModel.makeSelection(choice: choice)
    }
    
    func shouldResetStreak() {
        vsComputerViewModel.isResettingStreak.toggle()
    }
    
    var body: some View {
        VStack {
            // Header with high score, controls
            GameHeaderView(
                returnFunction: {
                    vsComputerViewModel.inGame = false
                },
                currentStreak: vsComputerViewModel.streak,
                rightHandFunction: { vsComputerViewModel.isResettingStreak.toggle() },
                showRewardedAd: { vsComputerViewModel.showRewardedAd() }
            )
            .alert("Watch ad to reset streak?", isPresented: $vsComputerViewModel.isResettingStreak) {
                Button { vsComputerViewModel.showRewardedAd() } label: { Text("Im sure") }
                Button { } label: { Text("Cancel") }
            } message: {
                Text("Are you sure, this can not be un-done?")
            }

            ZStack {
                // Game View
                RockPaperScissorsView(
                    chooseWeapon: { choice in
                        returnChoice(choice)
                    },
                    isDisabled: vsComputerViewModel.match.player1.result != nil,
                    storeManager: storeManager
                )

                // Game Result overlay
                if let playerOneResult = vsComputerViewModel.match.player1.result,
                   let playerOneChoice = vsComputerViewModel.match.player1.weaponOfChoice,
                   let playerTwoChoice = vsComputerViewModel.match.player2.weaponOfChoice {
                    EndGameView(
                        result: playerOneResult,
                        playerOneChoice: playerOneChoice,
                        playerTwoChoice: playerTwoChoice,
                        buttonFunction: { vsComputerViewModel.startNewGame() }
                    )
                }
            }
        }
        .onAppear {
            vsComputerViewModel.loadRewardedAd()
        }
        .onDisappear {
            // TODO: Update user high score if logged into GameCenter
        }
    }
}

struct RPSvsComputerView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(
            vsComputerViewModel: VsComputerViewModel(),
            adsVM: AdsViewModel(),
            storeManager: StoreManager()
        )
        .preferredColorScheme(.dark)
    }
}
