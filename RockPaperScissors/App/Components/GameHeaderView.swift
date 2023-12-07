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

struct HeaderCategory: View {
    let title: String
    let number: Int
    var body: some View {
        VStack {
            Text(title)
                .font(.caption2)
                .textCase(.uppercase)
                .fontWeight(.heavy)
            Text(number, format: .number)
                .font(.largeTitle)
        }
        .foregroundColor(Color.theme.text)
    }
}

struct GameHeaderView: View {
    var title: String
    var returnFunction: () -> Void
    var currentStreak: Int?
    var rightHandFunction: () -> Void
    var showRewardedAd: (() -> Void)?
    
    init(
        title: String,
        returnFunction: @escaping () -> Void,
        currentStreak: Int? = nil,
        bestStreak: Int? = nil,
        rightHandFunction: @escaping () -> Void,
        showRewardedAd: (() -> Void)? = nil
    ) {
        self.title = title
        self.returnFunction = returnFunction
        self.currentStreak = currentStreak
        self.rightHandFunction = rightHandFunction
        self.showRewardedAd = showRewardedAd
    }

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
                    HStack {
                        if let currentS = currentStreak {
                            HeaderCategory(title: "Streak", number: currentS)
                        }
                    }
                    Spacer()
                    HeaderButton(
                        function: { rightHandFunction() },
                        icon: "questionmark.circle.fill"
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
            title: "Header",
            returnFunction: { print("") },
            currentStreak: 1,
            rightHandFunction: { print("") },
            showRewardedAd: {}
        )
    }
}
