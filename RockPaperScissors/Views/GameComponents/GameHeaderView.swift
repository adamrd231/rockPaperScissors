import SwiftUI

struct GameHeaderView: View {
    
    var returnFunction: () -> Void
    var currentStreak: Int
    var rightHandFunction: () -> Void
    var showRewardedAd: () -> Void
    @Binding var isResettingStreak: Bool
    
    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .fixedSize()
            HStack {
                Button {
                    returnFunction()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "arrowtriangle.backward.fill")
                            .resizable()
                            .frame(width: 20, height: 25)
                    }
                    .foregroundColor(Color.theme.text)
                }
     
                Spacer()
                VStack {
                    Text("streak")
                        .font(.caption)
                        .textCase(.uppercase)
                    Text(currentStreak, format: .number)
                        .font(.largeTitle)
                        .bold()
                }

         
                Spacer()
                Button {
                    rightHandFunction()
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.theme.text)
                    }
                }
    //                .disabled(admobVM.rewarded.rewardedAd == nil)
            }
        }

        .statusBar(hidden: true)
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView(
            returnFunction: { print("") },
            currentStreak: 1,
            rightHandFunction: { print("") },
            showRewardedAd: {},
            isResettingStreak: .constant(false)
        )
    }
}
