import SwiftUI

struct RPSvsPersonView: View {
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    
    var body: some View {
        VStack {
            GameHeaderView(
                returnFunction: { vsPersonViewModel.inGame = false },
                currentStreak: <#T##Int#>,
                rightHandFunction: <#T##() -> Void#>,
                showRewardedAd: <#T##() -> Void#>,
                isResettingStreak: <#T##Binding<Bool>#>
            )
            Text("Currently playing")
            Text(vsPersonViewModel.personPlayer.name)
            
        }
    }
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(vsPersonViewModel: VsPersonViewModel())
    }
}
