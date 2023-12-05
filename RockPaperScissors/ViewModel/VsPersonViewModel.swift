import Foundation
import SwiftUI
import GameKit

class VsPersonViewModel: NSObject, ObservableObject {
    // GameKit
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    @Published var authenticationState = PlayerAuthState.unauthenticated
    var localPlayer = GKLocalPlayer.local
    var playerUUIDKey = UUID().uuidString

    // RPS Game
    @Published var gameMatch = RPSMatch(
        id: UUID().uuidString,
        player1: PlayerModel(id: UUID().uuidString, name: ""),
        player2: PlayerModel(id: UUID().uuidString, name: "")
    )

    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isRoundOver = false
    @Published var isShowingAlert = false
    
    @Published var matchesPlayed: [RPSMatch] = []
    
    // Game controls
    @Published var lastReceivedData: WeaponOfChoice? = nil
    @Published var playAgain: Bool = false
    @Published var playerWantsToPlayAgain: Bool = false
    
    // Leaderboard
    @Published var playersList: [GKPlayer] = []
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
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
    
    func goToGameCenter() {
        if let gameCenterURL = URL(string: "gamecenter:")  {
            if UIApplication.shared.canOpenURL(gameCenterURL) {
                UIApplication.shared.open(gameCenterURL)
            } else {
                print("Can not open gameCenter")
            }
        } else {
            print("Invalid URL for game center")
        }
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [self] vc, e in
            print("Test")
            if let viewController = vc {
                print("Test1")
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
 
    func playGame(playerChoice: WeaponOfChoice) {
        sendString(playerChoice.description)
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
            print("Scissors")
        case WeaponOfChoice.rock.description:
            print("Rock")
        case WeaponOfChoice.paper.description:
            print("Paper")
        case "strData:":
            break
            
        case "timer":
            print("Placeholder")
            
        default:
            break
        }
    }
}
