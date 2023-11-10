//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/10/23.
//

import SwiftUI

enum GameResult: CustomStringConvertible {
    case win
    case lose
    case tie
    
    var description: String {
        switch self {
        case .win: return "win"
        case .lose: return "lose"
        case .tie: return "tie"
        }
    }
}

enum ChoiceOfWeapon: CustomStringConvertible {
    case rock
    case scissors
    case paper
    var description: String {
        switch self {
        case .rock: return "rock"
        case .paper: return "paper"
        case .scissors: return "scissors"
        }
    }
}

struct ContentView: View {
    let choices:[ChoiceOfWeapon] = [.rock, .scissors, .paper]
    @State var gameResult: String? = nil
    @State var computerChoice: String? = nil
    @AppStorage("bestStreak") var streak: Int = 0
    
    func playGame(playerChoice: ChoiceOfWeapon) {

        let randomIndex = Int.random(in: 0..<3)
        let randomChoice = choices[randomIndex]
        computerChoice = randomChoice.description
        
        switch playerChoice {
        case .rock:
            switch randomChoice {
            case .rock: gameResult = GameResult.tie.description
            case .paper:
                gameResult = GameResult.lose.description
                streak = 0
            case .scissors:
                gameResult = GameResult.win.description
                streak += 1
            }
        case .scissors:
            switch randomChoice {
            case .rock:
                gameResult = GameResult.lose.description
                streak = 0
            case .paper:
                gameResult = GameResult.win.description
                streak += 1
            case .scissors: gameResult = GameResult.tie.description
            }
        case .paper:
            switch randomChoice {
            case .rock:
                gameResult = GameResult.win.description
                streak += 1
            case .paper: gameResult = GameResult.tie.description
            case .scissors:
                gameResult = GameResult.lose.description
                streak = 0
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(streak, format: .number)
            Text("Choose")
            HStack {
                Button("Rock") {playGame(playerChoice: .rock) }
                Button("Paper") { playGame(playerChoice: .paper) }
                Button("Scissors") { playGame(playerChoice: .scissors) }
            }
            if let choice = computerChoice {
                HStack {
                    Text("Computer chose:")
                    Text(choice)
                }
            }
            if let result = gameResult {
                Text(result)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
