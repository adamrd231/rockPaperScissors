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
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.backgroundColor)
                }
                .foregroundColor(Color.theme.blue)
                
                HStack {
                    RPSGraphic(playerChoice: playerOneChoice)
                    Text("VS")
                        .foregroundColor(Color.theme.text)
                        .font(.callout)
                        .fontWeight(.heavy)
                    RPSGraphic(playerChoice: playerTwoChoice)
                }
                .foregroundColor(Color.theme.text)
                
                VStack {
                    BasicMainButton(
                        title: "Play Again",
                        icon: "goforward",
                        textColor: Color.theme.backgroundColor,
                        background: Color.theme.blue,
                        function: { buttonFunction() }
                    )
                
                    if result == .lose {
                        BasicMainButton(
                            title: "Retry",
                            icon: "play.square",
                            textColor: Color.theme.backgroundColor,
                            background: Color.theme.orange,
                            function: {  computerRetryFunc() }
                        )
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
