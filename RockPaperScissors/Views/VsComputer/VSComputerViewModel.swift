import SwiftUI
import Combine

struct RPSvsComputerGameModel {
    var player = PersonPlayer(id: UUID().uuidString, name: "Player")
    var computerPlayer = ComputerPlayer(id: UUID().uuidString, name: "Computer")
    var streak: Int = 0
    var gameResult: GameResult? = nil

    
    mutating func rockPaperScissors(_ playerChoice: WeaponOfChoice, _ computerChoice: WeaponOfChoice) -> GameResult {
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

class VsComputerViewModel: ObservableObject {
    // Game
    @Published var gameModel = RPSvsComputerGameModel()
    @Published var isGameOver: Bool = false
    
    @Published var inGame: Bool = false
    // Advertising
    @Published var isResettingStreak: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    // AdsViewController
    var rewardedAdVC: AdsViewController
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    init() {
        rewardedAdVC = AdsViewController()
        
        rewardedAdVC.adCompletionHandler = { [weak self] in
            print("Updating streak")
            self?.updateStreakAfterAdCompletion()
        }
    }
    
    func updateStreakAfterAdCompletion() {
        self.gameModel.streak = 0
    }
    
    func loadRewardedAd() {
        rewardedAdVC.loadRewardedAd()
    }
    
    func showRewardedAd() {
        rewardedAdVC.show()
    }
    
    func startNewGame() {
        gameModel.player.weaponOfChoice = nil
        gameModel.computerPlayer.weaponOfChoice = WeaponOfChoice.allCases[Int.random(in: 0..<3)]

    }
    
    
}
