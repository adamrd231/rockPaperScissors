import SwiftUI

struct EndGameView: View {
    let result: GameResult
    let playerOneChoice: WeaponOfChoice
    let playerTwoChoice: WeaponOfChoice
    let buttonFunction: () -> Void
    let computerRetryFunc: () -> Void?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.theme.backgroundColor)
            
            VStack(spacing: 25) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                    Rectangle()
                        .offset(y: 10)
                    Text("You \(result.description)")
                        .padding()
                        .textCase(.uppercase)
                        .font(.title2)
                        .padding(.top, 5)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.backgroundColor)
                }
                .foregroundColor(Color.theme.blue)
                
                HStack {
                    VStack(spacing: 5) {
                        Text("You")
                        Image(playerOneChoice.description)
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                    VStack(spacing: 5) {
                        Text("Comp")
                        Image(playerTwoChoice.description)
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                }
                .foregroundColor(Color.theme.text)
                
                VStack {
                    Button {
                        // Reset game
                        buttonFunction()
                    } label: {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color.theme.blue)
                            HStack {
                                Image(systemName: "goforward")
                                Text("Play again")
                            }
                            .bold()
                            .foregroundColor(Color.theme.backgroundColor)
                            .padding()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    if result == .lose {
                        Button {
                            computerRetryFunc()
                        } label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(Color.theme.orange)
                                HStack {
                                    Image(systemName: "play.square")
                                    Text("Retry")
                                }
                                .bold()
                                .foregroundColor(Color.theme.backgroundColor)
                                .padding()
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .frame(minWidth: 230)
        .fixedSize()

    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(
            result: .win,
            playerOneChoice: .rock,
            playerTwoChoice: .paper,
            buttonFunction: {},
            computerRetryFunc: {}
        )
    }
}
