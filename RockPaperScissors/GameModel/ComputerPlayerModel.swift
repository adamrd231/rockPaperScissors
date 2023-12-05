import Foundation

struct PlayerModel {
    var id: String
    var name: String
    var weaponOfChoice: WeaponOfChoice? = nil
}

struct RPSMatch {
    var id: String
    var player1: PlayerModel
    var player2: PlayerModel
    var result: GameResult? = nil
    
    mutating func playMatch(wop: WeaponOfChoice) {
        print("play match")
        player1.weaponOfChoice = wop
        if let player2Choice = player2.weaponOfChoice {
            result = rockPaperScissors(wop, player2Choice)
        }
    }
    
    func rockPaperScissors(_ playerChoice: WeaponOfChoice, _ computerChoice: WeaponOfChoice) -> GameResult {
        print("You chocse \(playerChoice.description) computer: \(computerChoice.description)")
        switch (playerChoice, computerChoice) {
            case (.rock, .rock): return .tie
            case (.rock, .scissors): return  .win
            case (.rock, .paper): return .lose
                
            case (.paper, .rock): return .win
            case (.paper, .scissors): return .lose
            case (.paper, .paper): return .tie
                
            case (.scissors, .scissors): return .tie
            case (.scissors, .rock): return .lose
            case (.scissors, .paper): return .win
        }
    }
    
}
