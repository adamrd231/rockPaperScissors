import SwiftUI

struct EndGameView: View {
    let result: GameOutcome
    let playerOneChoice: WeaponOfChoice
    let playerTwoChoice: WeaponOfChoice
    let playerStatus: Bool?
    let buttonFunction: () -> Void
    let computerRetryFunc: () -> Void
    
    init(
        result: GameOutcome,
        playerOneChoice: WeaponOfChoice,
        playerTwoChoice: WeaponOfChoice,
        playerStatus: Bool? = nil,
        buttonFunction: @escaping () -> Void,
        computerRetryFunc: @escaping () -> Void ) {
            self.result = result
            self.playerOneChoice = playerOneChoice
            self.playerTwoChoice = playerTwoChoice
            self.playerStatus = playerStatus
            self.buttonFunction = buttonFunction
            self.computerRetryFunc = computerRetryFunc
    }
    
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
                
                HStack(spacing: 0) {
                    RPSGraphic(playerChoice: playerOneChoice)
                    switch result {
                        case .win:
                        switch playerOneChoice {
                        case .rock: Text("crushes")
                        case .paper: Text("covers")
                        case .scissors: Text("cuts")
                        }
                        case .lose:
                        switch playerOneChoice {
                        case .rock: Text("covered")
                        case .paper: Text("split")
                        case .scissors: Text("crushed")
                        }
                        case .tie: Text("push")
                    }
                    RPSGraphic(playerChoice: playerTwoChoice)
                }
                .foregroundColor(Color.theme.text)
                .font(.callout)
                .fontWeight(.heavy)
                
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
                    
                    if let ready = playerStatus {
                        Text(ready ? "Other player ready" : "Waiting for other player")
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
            playerStatus: true,
            buttonFunction: {},
            computerRetryFunc: {}
        )
    }
}
