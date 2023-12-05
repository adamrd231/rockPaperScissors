import SwiftUI

struct RockPaperScissorsView: View {
    // Static choices
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    // Function for selecting choice left vague so either vs computer or vs person can use this component.
    let chooseWeapon: (WeaponOfChoice) -> Void
    let isDisabled: Bool
    // Needed to check if should be playing advertising
    let storeManager: StoreManager
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer(minLength: 0)
                ForEach(choices, id: \.self) { choice in
                    Button {
                        chooseWeapon(choice)
                    } label: {
                        RPSGraphic(playerChoice: choice)
                    }
                    .disabled(isDisabled)
                }
                Spacer(minLength: 0)
                if !storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                    Banner()
                }
            }
        }
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView(
            chooseWeapon: { _ in },
            isDisabled: true,
            storeManager: StoreManager()
        )
        .environmentObject(VsComputerViewModel())
    }
}
