
import SwiftUI

class VsComputerViewModel: ObservableObject {
    // Game
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    @Published var gameResult: GameResult? = nil
    @Published var computerChoice: WeaponOfChoice
    @Published var userChoice: WeaponOfChoice? = nil
    @AppStorage("computerStreak") var streak: Int = 0
    @AppStorage("gamesPlayed") var gamesPlayed: Int = 0
    
    @Published var inGame: Bool = false
    @Published var gameOver: Bool = false
    
    init() {
        computerChoice = choices[Int.random(in: 0..<3)]
    }
    
    // Functions
    func playerWon() {
        streak += 1
        gameResult = .win
    }
    
    func playerLost() {
        streak -= 1
        gameResult = .lose
    }
    
    func playerTie() {
        gameResult = .tie
    }
    
    func rockPaperScissors(_ playerChoice: WeaponOfChoice, _ computerChoice: WeaponOfChoice) {
        gamesPlayed += 1
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
}
