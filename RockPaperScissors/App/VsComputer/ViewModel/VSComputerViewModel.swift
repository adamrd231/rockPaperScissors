import SwiftUI
import Combine

class VsComputerViewModel: ObservableObject {
    @Published var isGameOver: Bool = false
    @Published var inGame: Bool = false
    
    @Published var gameDataService = GameDataService()
    // Game
    @Published var match = RPSMatch(
        id: UUID().uuidString,
        player1: PlayerModel(id: UUID().uuidString, name: "Player"),
        player2: PlayerModel(id: UUID().uuidString, name: "Computer", weaponOfChoice: WeaponOfChoice.allCases[Int.random(in: 0..<3)])
    )
    @Published var matchesPlayed:[RPSMatch] = []
    
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
        addSubscribers()
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    var player1Record: Int {
        return matchesPlayed.filter({ $0.result == .win }).count - matchesPlayed.filter({ $0.result == .lose }).count
    }
    
    var player2Record: Int {
        return matchesPlayed.filter({ $0.result == .lose }).count - matchesPlayed.filter({ $0.result == .win }).count
    }
    
    func addSubscribers() {
        gameDataService.$savedGameEntities
            .sink { [weak self] savedGames in
                var savedMatches:[RPSMatch] = []
                for match in savedGames {
                    print("match id: \(match.id)")
                    let newRPSMatch = RPSMatch(
                        id: match.id ?? "N/A",
                        player1: PlayerModel(
                            id: match.playerOneID ?? "",
                            name: match.playerOneName ?? "N/A",
                            weaponOfChoice: self?.getWeaponOfChoiceFromString(match.playerOneChoice ?? "")),
                        player2: PlayerModel(
                            id: match.playerTwoID ?? "",
                            name: match.playerTwoName ?? "N/A",
                            weaponOfChoice: self?.getWeaponOfChoiceFromString(match.playerTwoChoice ?? "")),
                        result: self?.getResultFromString(match.result ?? "")
                    )
                    savedMatches.append(newRPSMatch)
                }
                self?.matchesPlayed = savedMatches
            }
            .store(in: &cancellable)
    }
    
    func getResultFromString(_ string: String) -> GameOutcome? {
        switch string {
        case GameOutcome.win.description: return .win
        case GameOutcome.lose.description: return .lose
        case GameOutcome.tie.description: return .tie
        default: return nil
        }
    }
    
    func getWeaponOfChoiceFromString(_ string: String) -> WeaponOfChoice? {
        switch string {
        case WeaponOfChoice.paper.description: return .paper
        case WeaponOfChoice.scissors.description: return .scissors
        case WeaponOfChoice.rock.description: return .rock
        default: return nil
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
        gameDataService.addGameToHistory(match: match)
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
