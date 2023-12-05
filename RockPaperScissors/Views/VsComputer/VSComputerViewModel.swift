import SwiftUI
import Combine

class VsComputerViewModel: ObservableObject {
    // Game
    @Published var match = RPSMatch(
        id: UUID().uuidString,
        player1: PlayerModel(id: UUID().uuidString, name: "Player"),
        player2: PlayerModel(id: UUID().uuidString, name: "Computer", weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
    )
    
    @Published var matchesPlayed:[RPSMatch] = []
    
    @Published var streak: Int = 0

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
            self?.matchesPlayed = []
        }
    }
    
    func makeSelection(choice: WeaponOfChoice) {
        let result = match.playMatch(wop: choice)
        switch result {
            case .win: streak += 1
            case .tie: print("Good luck!")
            case .lose: streak = 0
            default: print("Default I guess")
        }
        matchesPlayed.append(match)
    }
    
    func updateStreakAfterAdCompletion() {
        matchesPlayed = []
    }
    
    func loadRewardedAd() {
        rewardedAdVC.loadRewardedAd()
    }
    
    func showRewardedAd() {
        rewardedAdVC.show()
    }
    
    func startNewGame() {
        let player1 = match.player1
        let player2 = match.player2
        match = RPSMatch(
            id: UUID().uuidString,
            player1: PlayerModel(id: player1.id, name: player2.name, weaponOfChoice: nil),
            player2: PlayerModel(id: player2.id, name: player2.name, weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
        )
    }
}
