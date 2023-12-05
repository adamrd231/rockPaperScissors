import SwiftUI

struct RPSvsPersonView: View {
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    @ObservedObject var adsVM: AdsViewModel
    @ObservedObject var storeManager: StoreManager
    
    // Alert to double check user wants to leave game
    @State var isBackingOut: Bool = false
    
    func localPlayerChoseWOP(_ choice: WeaponOfChoice) {
        print("Local player picker wop: \(choice)")
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
            RockPaperScissorsView(
                chooseWeapon: localPlayerChoseWOP,
                isDisabled: false,
                storeManager: storeManager)
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
