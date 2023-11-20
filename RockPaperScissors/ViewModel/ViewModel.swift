import Foundation
import SwiftUI
import GameKit
import Combine

class ViewModel: NSObject, ObservableObject {
    
    // Game Center
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isRoundOver = false
    @Published var authenticationState = PlayerAuthState.unauthenticated
    @Published var isShowingAlert = false

    // Game
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    @Published var gameResult: GameResult? = nil
    @Published var computerChoice: WeaponOfChoice? = nil
    @Published var userChoice: WeaponOfChoice? = nil
    @Published var streak: Int = 0
    @Published var lastReceivedData: WeaponOfChoice? = nil
    
    @Published var playAgain: Bool = false
    @Published var playerWantsToPlayAgain: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    // GameKit
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    var playerUUIDKey = UUID().uuidString
    
    // Leaderboard
    @Published var playersList: [GKPlayer] = []
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    var rewardedAdVC: AdsViewController // Declare AdsViewController
    
    override init() {
        rewardedAdVC = AdsViewController()
        
        super.init()
        addSubscribers()
    }
    
    func loadRewardedAd() {
        rewardedAdVC.loadRewardedAd()
    }
    
    func showRewardedAd() {
        rewardedAdVC.show()
    }
    
    func loadAchievements(gamesPlayed: Int) {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let achievementID = "PlayFirstGame"
            var achievement: GKAchievement? = nil
            achievement = achievements?.first(where: { $0.identifier == achievementID })
            
            if achievement == nil {
                achievement = GKAchievement(identifier: achievementID)
                if gamesPlayed > 0 {
                    achievement?.percentComplete = 100
                    let achievementsToReport: [GKAchievement] = [achievement!]
                    GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                        if error != nil {
                            print("Error reporting achievement: \(String(describing: error))")
                        }
                    })
                }
            }
            if error != nil {
                print("Error get achievement: \(String(describing: error))")
            }
        })
    }
    
    func updateAchievement() {
        
    }
    
    func showLeaderboards() {
        let gameCenterVC = GKGameCenterViewController(state: .leaderboards)
        gameCenterVC.gameCenterDelegate = self
        rootViewController?.present(gameCenterVC, animated: true, completion: nil)
        
    }
    
    func submitScoreToLeaderBoard(newHighScore: Int) {
        if authenticationState == .authenticated {
            print("Score: \(newHighScore)")
            Task {
                do {
                    try await GKLeaderboard.submitScore(
                        newHighScore,
                        context: 0,
                        player: GKLocalPlayer.local,
                        leaderboardIDs: ["gamesWon", "playerOfTheWeek"]
                        
                    )
                } catch let error {
                    print("Error submitting leaderboard scores: \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let matchmakingVC = GKMatchmakerViewController(matchRequest: request)
        matchmakingVC?.matchmakerDelegate = self
        if let matchmaker = matchmakingVC {
            rootViewController?.present(matchmaker, animated: true)
        }
    }
    
    func addSubscribers() {
        $userChoice
            .combineLatest($computerChoice)
            .sink { [weak self] user, computer in
                if let u = user,
                   let c = computer {
                    self?.rockPaperScissors(u, c)
                
                }
            }
            .store(in: &cancellable)
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [self] vc, e in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            if let error = e {
                authenticationState = .error
                print("Error authenticating user:" + error.localizedDescription)
                return
            }
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                } else {
                    authenticationState = .authenticated
                }
            } else {
                authenticationState = .unauthenticated
            }
        }
    }

    func startMatch(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        sendString("began: \(playerUUIDKey)")
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
    
    func resetGame() {
        sendString("restart:")
        playAgain = true
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
        sendString(playerChoice.description)
        userChoice = playerChoice
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            inGame = true
   
        case "restart":
            // Received request from user to re-start the game
            playerWantsToPlayAgain = true

        // Handle guesses from the other player
        case WeaponOfChoice.scissors.description:
            computerChoice = .scissors
        case WeaponOfChoice.rock.description:
            computerChoice = .rock
        case WeaponOfChoice.paper.description:
            computerChoice = .paper
        case "strData:":
            break
            
        case "timer":
            print("Placeholder")
            
        default:
            break
        }
        
    }
}
