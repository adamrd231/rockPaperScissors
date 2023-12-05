import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    func returnChoice(_ choice: WeaponOfChoice) {
        print("Chose: \(choice)")
        vsComputerViewModel.makeSelection(choice: choice)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                GameHeaderView(
                    returnFunction: {
                        vsComputerViewModel.inGame = false
                        
                    },
                    currentStreak: vsComputerViewModel.streak,
                    rightHandFunction: { vsComputerViewModel.isResettingStreak.toggle() },
                    showRewardedAd: { vsComputerViewModel.showRewardedAd() },
                    isResettingStreak: $vsComputerViewModel.isResettingStreak
                )
                .frame(maxHeight: 120)
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
                // MARK: Playing game
                ZStack {
                    RockPaperScissorsView(
                        chooseWeapon: { choice in
                            returnChoice(choice)
                        },
                        isDisabled: vsComputerViewModel.match.result != nil,
                        storeManager: storeManager
                    )
                    .environmentObject(vsComputerViewModel)
                    // Game result overlay
                    if let result = vsComputerViewModel.match.result {
                        EndGameView(result: result)
                            .environmentObject(vsComputerViewModel)
                    }
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
