import SwiftUI

class VsComputerViewModel: ObservableObject {
    // Game
    @Published var match = RPSMatch(
        id: UUID().uuidString,
        player1: PlayerModel(id: UUID().uuidString, name: "Player"),
        player2: PlayerModel(id: UUID().uuidString, name: "Computer", weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
    )
    @Published var matchesPlayed:[RPSMatch] = []
    
    var player1Record: Int {
        return matchesPlayed.filter({ $0.result == .win }).count - matchesPlayed.filter({ $0.result == .lose }).count
    }
    
    var player2Record: Int {
        return matchesPlayed.filter({ $0.result == .lose }).count - matchesPlayed.filter({ $0.result == .win }).count
    }
    
    var streak: Int {
        var consecutiveWins = 0

        for match in matchesPlayed.reversed() {
            if match.result == .win {
                consecutiveWins += 1
            } else if match.result == .tie {
                // Do nothing
            } else {
                // If player1 doesn't win, break the streak
                break
            }
        }
        return consecutiveWins
    }
    
    var bestStreak: Int {
        var consecutiveWins = 0
        var longestStreak = 0

        for match in matchesPlayed {
            match.result == .win ? (consecutiveWins += 1) : (consecutiveWins = 0)
            longestStreak = max(longestStreak, consecutiveWins)
        }
        return longestStreak
    }
    
    @Published var isGameOver: Bool = false
    @Published var inGame: Bool = false

    // AdsViewController
    var rewardedAdVC: AdsViewController
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    init() {
        rewardedAdVC = AdsViewController()
        // This runs when rewarded advertising is completed
        rewardedAdVC.adCompletionHandler = { [weak self] in
            self?.retryCurrentGame()
        }
    }
    
    func makeSelection(choice: WeaponOfChoice) {
        match.playMatch(wop: choice)
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
            player1: PlayerModel(id: player1.id, name: player1.name, weaponOfChoice: nil),
            player2: PlayerModel(id: player2.id, name: player2.name, weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
        )
    }
    
    func retryCurrentGame() {
        let currentMatchID = match.id
        let player1 = match.player1
        let player2 = match.player2
        match = RPSMatch(
            id: currentMatchID,
            player1: PlayerModel(id: player1.id, name: player2.name, weaponOfChoice: nil),
            player2: PlayerModel(id: player2.id, name: player2.name, weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
            )
    }
}
