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
                currentStreak: vsComputerViewModel.gameDataService.streak,
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
                    bestStreak: vsComputerViewModel.gameDataService.bestStreak
                )
            }
            
            // opponent player bio
            PlayerBioRowView(
                player1: PlayerBio(
                    name: vsComputerViewModel.match.player1.name, image: "",
                    count: vsComputerViewModel.player1Record
                ),
                player2: PlayerBio(
                    name: vsComputerViewModel.match.player2.name, image: "",
                    count: vsComputerViewModel.player2Record
                )
            )
            ZStack {
                // Game View
                RockPaperScissorsView(
                    chooseWeapon: { choice in
                        returnChoice(choice)
                    },
                    isDisabled: vsComputerViewModel.match.result != nil,
                    storeManager: storeManager
                )

                // Game Result overlay
                if let result = vsComputerViewModel.match.result,
                   let playerOneChoice = vsComputerViewModel.match.player1.weaponOfChoice,
                   let playerTwoChoice = vsComputerViewModel.match.player2.weaponOfChoice {
                    EndGameView(
                        result: result,
                        playerOneChoice: playerOneChoice,
                        playerTwoChoice: playerTwoChoice,
                        isBeingUsedFor: .computer,
                        buttonFunction: { vsComputerViewModel.startNewGame() },
                        secondButtonFunc: { vsComputerViewModel.startNewGame() },
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
