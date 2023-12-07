import SwiftUI

struct RPSGraphic: View {
    let playerChoice: WeaponOfChoice
    let isSelected: Bool
    
    init(playerChoice: WeaponOfChoice, isSelected: Bool = false) {
        self.playerChoice = playerChoice
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(isSelected ? Color.theme.text : .clear, lineWidth: 3)
                .background(Capsule().fill(isSelected ? Color.theme.backgroundColor.opacity(0.9) : Color.theme.backgroundColor))
                
            VStack(spacing: 0) {
                Image(playerChoice.description)
                    .resizable()
                    .frame(maxWidth: 66, maxHeight: 66)
                    .font(.largeTitle)
                Text(playerChoice.description)
                    .foregroundColor(Color.theme.text)
            }
            .padding()
            .padding(.horizontal, 25)
        }
        .fixedSize()
    }
}

struct RPSGraphic_Previews: PreviewProvider {
    static var previews: some View {
        RPSGraphic(playerChoice: .rock)
    }
}
