import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    func returnChoice(_ choice: WeaponOfChoice) {
        vsComputerViewModel.makeSelection(choice: choice)
    }
    
    @State var isRequestingAds: Bool = false
    @State var isShowingExplanation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with high score, controls
            GameHeaderView(
                title: "Streak",
                returnFunction: {
                    vsComputerViewModel.inGame = false
                },
                currentStreak: vsComputerViewModel.streak,
                bestStreak: vsComputerViewModel.bestStreak,
                rightHandFunction: { isShowingExplanation.toggle() },
                showRewardedAd: { vsComputerViewModel.showRewardedAd() }
            )
            .alert("Watch ad to try again?", isPresented: $isRequestingAds) {
                Button { vsComputerViewModel.showRewardedAd() } label: { Text("Im sure") }
                Button { } label: { Text("Cancel") }
            } message: {
                Text("Watching ad will preserve your streak and let you try again.")
            }
            .sheet(isPresented: $isShowingExplanation) {
                ExplanationView(
                    matchesPlayed: vsComputerViewModel.matchesPlayed
                )
            }
            
            // opponent player bio
            PlayerBioRowView(
                player1: PlayerBio(
                    name: vsComputerViewModel.match.player1.name, image: "",
                    count: vsComputerViewModel.matchesPlayed.filter({ $0.player1.result == .win }).count
                ),
                player2: PlayerBio(
                    name: vsComputerViewModel.match.player2.name, image: "",
                    count: vsComputerViewModel.matchesPlayed.filter({ $0.player2.result == .win }).count
                )
            )
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
                        
                        buttonFunction: { vsComputerViewModel.startNewGame() },
                        computerRetryFunc: { isRequestingAds.toggle() }
                    )
                }
            }
            if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                Banner()
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
