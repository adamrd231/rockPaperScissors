//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/10/23.
//

import SwiftUI

enum PlayerAuthState: String {
    case authenticating = "Logging into Game Center..."
    case unauthenticated = "Please sign into game center to play against people"
    case authenticated = ""
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games."
}

struct ContentView: View {
    let choices:[WeaponOfChoice] = [.rock, .scissors, .paper]
    @State var gameResult: GameResult? = nil
    @State var computerChoice: WeaponOfChoice? = nil
    @State var userChoice: WeaponOfChoice? = nil
    @AppStorage("bestStreak") var streak: Int = 0
    
    func playerWon() {
        streak += 1
        gameResult = .win
    }
    
    func playerLost() {
        if streak <= 0 {
            streak -= 1
        } else {
            streak = 0
        }
        gameResult = .lose
    }
    
    func playerTie() {
        print("Tied")
        gameResult = .tie
    }
 
    
    func rockPaperScissors(_ playerChoice: WeaponOfChoice, _ computerChoice: WeaponOfChoice) {
        switch (playerChoice, computerChoice) {
        case (.rock, .rock): playerTie()
        case (.rock, .scissors): playerWon()
        case (.rock, .paper): playerLost()
            
        case (.paper, .rock): playerWon()
        case (.paper, .scissors): playerLost()
        case (.paper, .paper): playerTie()
            
        case (.scissors, .scissors): playerTie()
        case (.scissors, .rock): playerLost()
        case (.scissors, .paper): playerWon()
        }
    }
    
    func playGame(playerChoice: WeaponOfChoice) {

        let randomIndex = Int.random(in: 0..<3)
        computerChoice = choices[randomIndex]
        userChoice = playerChoice

        if let choice = computerChoice {
            rockPaperScissors(playerChoice, choice)
        }
    }
    
    var body: some View {
        VStack {
            Text(streak, format: .number)
            Text("Choose")
            HStack {
                ForEach(choices, id: \.self) { choice in
                    Button {
                        playGame(playerChoice: choice)
                    } label: {
                        HStack {
                            Text(choice.description)
                            Text(choice.emoji)
                        }
                    }
                }
            }
            HStack {
                if let choice = userChoice {
                    VStack {
                        Text("You chose:")
                        Text(choice.description)
                        Text(choice.emoji)
                    }
                }
                if let choice = computerChoice {
                    VStack {
                        Text("Computer chose:")
                        Text(choice.description)
                        Text(choice.emoji)
                    }
                }
            }
    
            if let result = gameResult {
                Text(result.description)
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
