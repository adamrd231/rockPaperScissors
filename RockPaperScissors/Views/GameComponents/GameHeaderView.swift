import SwiftUI

struct HeaderButton: View {
    let function: () -> Void
    let icon: String
    var body: some View {
        Button {
            function()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .foregroundColor(Color.theme.text)
        }
    }
}

struct GameHeaderView: View {
    var returnFunction: () -> Void
    var currentStreak: Int
    var rightHandFunction: () -> Void
    var showRewardedAd: () -> Void
    
    var body: some View {
        ZStack {
            // Background layer
            Color.theme.backgroundColor
                .ignoresSafeArea()

            VStack {
                Spacer()
                HStack(alignment: .center) {
                    HeaderButton(
                        function: { returnFunction() },
                        icon: "arrowtriangle.backward.fill"
                    )
                    Spacer()
                    VStack {
                        Text("streak")
                            .font(.caption2)
                            .textCase(.uppercase)
                            .fontWeight(.heavy)
                        Text(currentStreak, format: .number)
                            .font(.largeTitle)
                    }
                    .foregroundColor(Color.theme.text)

                    Spacer()
                    HeaderButton(
                        function: { rightHandFunction() },
                        icon: "arrow.counterclockwise.circle.fill"
                    )
                }
                .padding()
            }
        }
        .statusBar(hidden: true)
        .frame(maxHeight: 120)
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView(
            returnFunction: { print("") },
            currentStreak: 1,
            rightHandFunction: { print("") },
            showRewardedAd: {}
        )
    }
}
