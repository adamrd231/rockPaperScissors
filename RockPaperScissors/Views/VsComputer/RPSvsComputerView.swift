import SwiftUI
import GameKit



struct RPSvsComputerView: View {
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                GameHeaderView(
                    returnFunction: {
                        vsComputerViewModel.inGame = false
                        
                    },
                    currentStreak: vsComputerViewModel.streak,
                    gamesPlayed: vsComputerViewModel.matchesPlayed.count,
                    rightHandFunction: { vsComputerViewModel.isResettingStreak.toggle() },
                    showRewardedAd: { vsComputerViewModel.showRewardedAd() },
                    isResettingStreak: $vsComputerViewModel.isResettingStreak
                )
                .frame(maxHeight: 120)
                .onChange(of: vsComputerViewModel.match.player1.weaponOfChoice) { newValue in
                    if let choice = newValue {
        
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
                // MARK: Playing game
                RockPaperScissorsView(
                    storeManager: storeManager
                )
                .environmentObject(vsComputerViewModel)
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
