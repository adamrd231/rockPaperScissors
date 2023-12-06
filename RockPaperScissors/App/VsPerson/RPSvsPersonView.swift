import SwiftUI

struct RPSvsPersonView: View {
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    // Alert to double check user wants to leave game
    @State var isBackingOut: Bool = false
    
    func timeToPlayRPS() {
        // Unwrap optional variable and ensure choices have been made by both players
        if let player1Choice = vsPersonViewModel.gameMatch.player1.weaponOfChoice,
        let _ = vsPersonViewModel.gameMatch.player2.weaponOfChoice {
            print("We have both choices!")
            vsPersonViewModel.gameMatch.playMatch(wop: player1Choice)
        }
    }
    
    func localPlayerChoseWOP(_ choice: WeaponOfChoice) {
        print("Local player picker wop: \(choice)")
        vsPersonViewModel.gameMatch.player1.weaponOfChoice = choice
        vsPersonViewModel.sendString(choice.description)
    }
    
    func resetGameToPlay() {
        print("reset game to play")
        if vsPersonViewModel.playAgain && vsPersonViewModel.playerWantsToPlayAgain {
            // Reset game for another round
            print("resettting!")
            vsPersonViewModel.matchesPlayed.append(vsPersonViewModel.gameMatch)
            let player1 = vsPersonViewModel.gameMatch.player1
            let player2 = vsPersonViewModel.gameMatch.player2
            vsPersonViewModel.gameMatch = RPSMatch(
                id: UUID().uuidString,
                player1: PlayerModel(id: player1.id, name: player1.name),
                player2: PlayerModel(id: player2.id, name: player2.name)
            )
            vsPersonViewModel.playAgain = false
            vsPersonViewModel.playerWantsToPlayAgain = false
        }
    }
    
    var body: some View {
        VStack {
            GameHeaderView(
                returnFunction: {
                    isBackingOut.toggle()
                },
                currentStreak: vsPersonViewModel.matchesPlayed.count,
                rightHandFunction: { },
                showRewardedAd: { }
            )
            .alert("Do you want to leave this game?", isPresented: $isBackingOut) {
                Button { vsPersonViewModel.inGame = false } label: { Text("Im sure") }
                Button { } label: { Text("Cancel") }
            } message: {
                Text("You will forfeit the game, this can not be un-done")
            }
            Text(vsPersonViewModel.gameMatch.player2.weaponOfChoice == nil ? "User is selecting" : "User is waiting")
                .foregroundColor(Color.theme.backgroundColor)

            ZStack {
                RockPaperScissorsView(
                    chooseWeapon: self.localPlayerChoseWOP,
                    isDisabled: vsPersonViewModel.gameMatch.player1.result != nil,
                    storeManager: storeManager
               )
                .onChange(of: vsPersonViewModel.gameMatch.player1.weaponOfChoice) { newValue in
                    timeToPlayRPS()
                }
                .onChange(of: vsPersonViewModel.gameMatch.player2.weaponOfChoice) { newValue in
                    timeToPlayRPS()
                }
                
                if let result = vsPersonViewModel.gameMatch.player1.result,
                   let playerOneChoice = vsPersonViewModel.gameMatch.player1.weaponOfChoice,
                   let playerTwoChoice = vsPersonViewModel.gameMatch.player2.weaponOfChoice {
                    VStack {
                        Text(vsPersonViewModel.playerWantsToPlayAgain == false ? "waiting for user" : "user wants to play again")
                            .foregroundColor(Color.theme.backgroundColor)
                        EndGameView(
                            result: result,
                            playerOneChoice: playerOneChoice,
                            playerTwoChoice: playerTwoChoice,
                            buttonFunction: {
                                vsPersonViewModel.playAgain = true
                                vsPersonViewModel.sendString("restart")
                                
                            },
                            computerRetryFunc: {}
                        )
                        .onChange(of: vsPersonViewModel.playAgain) { newValue in
                            resetGameToPlay()
                        }
                        .onChange(of: vsPersonViewModel.playerWantsToPlayAgain) { newValue in
                            resetGameToPlay()
                        }
                    }
                   
                }
            }
        }
    }
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(
            vsPersonViewModel: VsPersonViewModel(),
            adsVM: AdsViewModel(),
            storeManager: StoreManager()
        )
    }
}
