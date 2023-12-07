import SwiftUI

enum EndGameOverlayUsedFor {
    case matchmaking
    case computer
}

struct EndGameView: View {
    let result: GameOutcome
    let playerOneChoice: WeaponOfChoice
    let playerTwoChoice: WeaponOfChoice
    let isBeingUsedFor: EndGameOverlayUsedFor
    let isOtherPlayerReady: Bool?
    let buttonFunction: () -> Void
    let secondButtonFunc: () -> Void?
    let computerRetryFunc: () -> Void
    
    init(result: GameOutcome, playerOneChoice: WeaponOfChoice, playerTwoChoice: WeaponOfChoice, isBeingUsedFor: EndGameOverlayUsedFor, isOtherPlayerReady: Bool? = nil, buttonFunction: @escaping () -> Void, secondButtonFunc: (() -> Void)? = nil,
        computerRetryFunc: @escaping () -> Void ) {
            self.result = result
            self.playerOneChoice = playerOneChoice
            self.playerTwoChoice = playerTwoChoice
            self.isBeingUsedFor = isBeingUsedFor
            self.isOtherPlayerReady = isOtherPlayerReady
            self.buttonFunction = buttonFunction
            self.secondButtonFunc = secondButtonFunc ?? {}
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
                        .offset(y: 15)
                    Text("You \(result.description)")
                        .padding()
                        .textCase(.uppercase)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.backgroundColor)
                        .offset(y: 10)
                }
                .foregroundColor(Color.theme.blue)
                
                HStack(spacing: 0) {
                    RPSGraphic(playerChoice: playerOneChoice)
                    ResultMessage(result: result, choice: playerOneChoice)
                    RPSGraphic(playerChoice: playerTwoChoice)
                }
                .foregroundColor(Color.theme.text)
                .font(.callout)
                .fontWeight(.heavy)
                
                if isBeingUsedFor == .matchmaking {
                    if let ready = isOtherPlayerReady {
                        Text(ready ? "Rematch requested" : "Waiting for rematch request")
                    }
                }
                
                VStack(spacing: 7) {
                    BasicMainButton(
                        title: "Rematch",
                        icon: "goforward",
                        textColor: Color.theme.backgroundColor,
                        background: Color.theme.blue,
                        function: { buttonFunction() }
                    )

                    if result == .lose && isBeingUsedFor == .computer {
                        BasicMainButton(
                            title: "Retry match",
                            icon: "play.square",
                            textColor: Color.theme.backgroundColor,
                            background: Color.theme.orange,
                            function: {  computerRetryFunc() }
                        )
                    } else {
                        BasicMainButton(
                            title: "Done",
                            icon: "xmark.circle",
                            background: Color.theme.text.opacity(0.1),
                            function: { secondButtonFunc() }
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
            result: .lose,
            playerOneChoice: .rock,
            playerTwoChoice: .paper,
            isBeingUsedFor: .matchmaking,
            isOtherPlayerReady: true,
            buttonFunction: {},
            secondButtonFunc: {},
            computerRetryFunc: {}
        )
    }
}
