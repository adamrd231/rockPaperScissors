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
        VStack {
            // Header with high score, controls
            GameHeaderView(
                returnFunction: {
                    vsComputerViewModel.inGame = false
                },
                currentStreak: vsComputerViewModel.streak,
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
                VStack {
                    Text("It's the rock, the paper, the scissors!")
                        .font(.title)
                    Text("Pick a option, and the computer will randomly pick one as well. Try to get as many wins in a row as possible!")
                    Divider()
                    ScrollView {
                        HStack {
                            Text("Record")
                                .bold()
                            Spacer()
                        }
                        ForEach(Array(zip(vsComputerViewModel.matchesPlayed.indices, vsComputerViewModel.matchesPlayed)), id: \.0) { index, match in
                            HStack {
                                Text(index + 1, format: .number)
                                Text("Vs \(match.player2.name)")
                                Spacer()
                                Text(match.player1.result?.description ?? "N/A")
                            }
                        }
                    }
                    
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                
                .multilineTextAlignment(.center)
                .padding()
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
                        buttonFunction: { vsComputerViewModel.startNewGame() },
                        computerRetryFunc: { isRequestingAds.toggle() }
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
