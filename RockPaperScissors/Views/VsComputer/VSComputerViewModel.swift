import SwiftUI
import Combine

class VsComputerViewModel: ObservableObject {
    // Game
    @Published var match = RPSMatch(
        id: UUID().uuidString,
        player1: PlayerModel(id: UUID().uuidString, name: "Player"),
        player2: PlayerModel(id: UUID().uuidString, name: "Computer", weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
    )
    
    var matchesPlayed:[RPSMatch] = []
    
    var matchesWon: Int {
        return matchesPlayed.filter({ $0.result == .win }).count
    }
    
    var matchesLost: Int {
        return matchesPlayed.filter({ $0.result == .lose }).count
    }
    
    var streak: Int {
        return matchesWon - matchesLost
    }

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
    
    func makeSelection(choice: WeaponOfChoice) {
        print("Made selection")
        match.player1.weaponOfChoice = choice
        match.playMatch(wop: choice)
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
        matchesPlayed.append(match)
        let player1 = match.player1
        let player2 = match.player2
        match = RPSMatch(
            id: UUID().uuidString,
            player1: PlayerModel(id: player1.id, name: player2.name, weaponOfChoice: nil),
            player2: PlayerModel(id: player2.id, name: player2.name, weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
        )
    }
}
