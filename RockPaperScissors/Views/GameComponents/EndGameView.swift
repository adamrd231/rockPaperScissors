import SwiftUI

struct EndGameView: View {
    let result: GameResult
    let playerOneChoice: WeaponOfChoice
    let playerTwoChoice: WeaponOfChoice
    let buttonFunction: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.theme.backgroundColor)
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.theme.blue)
                    Rectangle()
                        .foregroundColor(Color.theme.blue)
                        .offset(y: 10)
                    Text("You \(result.description)")
                        .padding()
                        .textCase(.uppercase)
                        .font(.title2)
                        .padding(.top, 5)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.backgroundColor)
                }

                HStack {
                    VStack {
                        Text("You")
                            .foregroundColor(Color.theme.text)
                        Image(playerOneChoice.description)
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                    VStack {
                        Text("Comp")
                            .foregroundColor(Color.theme.text)
                        Image(playerTwoChoice.description)
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                }
                .padding()
                Button {
                    // Reset game
                    buttonFunction()
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color.theme.blue)
                        Text("Play again?")
                            .bold()
                            .foregroundColor(Color.theme.backgroundColor)
                            .padding()
                    }
                    .fixedSize()
                    .padding(.bottom)
                }
            }
            .foregroundColor(Color.theme.backgroundColor)
        }
        .fixedSize()
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(
            result: .win,
            playerOneChoice: .rock,
            playerTwoChoice: .paper,
            buttonFunction: {}
        )
    }
}
