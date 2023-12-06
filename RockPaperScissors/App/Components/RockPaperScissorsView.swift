import SwiftUI

struct RockPaperScissorsView: View {
    // Static choices
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    // Function for selecting choice left vague so either vs computer or vs person can use this component.
    let chooseWeapon: (WeaponOfChoice) -> Void
    let isDisabled: Bool
    let isSelected: WeaponOfChoice?
    // Needed to check if should be playing advertising
    let storeManager: StoreManager
    
    init(chooseWeapon: @escaping (WeaponOfChoice) -> Void, isDisabled: Bool, isSelected: WeaponOfChoice? = nil, storeManager: StoreManager) {
        self.chooseWeapon = chooseWeapon
        self.isDisabled = isDisabled
        self.isSelected = isSelected
        self.storeManager = storeManager
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer(minLength: 0)
                ForEach(choices, id: \.self) { choice in
                    Button {
                        chooseWeapon(choice)
                    } label: {
                        RPSGraphic(
                            playerChoice: choice,
                            isSelected: isSelected == choice ? true : false
                        )
                    }
                    .disabled(isDisabled)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView(
            chooseWeapon: { _ in },
            isDisabled: true,
            isSelected: .rock,
            storeManager: StoreManager()
        )
        .environmentObject(VsComputerViewModel())
    }
}
