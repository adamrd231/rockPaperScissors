import Foundation
import SwiftUI
import GameKit

class ViewModel: NSObject, ObservableObject {
    
    // Game Center
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating

    // Game
    let choices:[WeaponOfChoice] = [.rock, .scissors, .paper]
    @Published var gameResult: GameResult? = nil
    @Published var computerChoice: WeaponOfChoice? = nil
    @Published var userChoice: WeaponOfChoice? = nil
    @AppStorage("bestStreak") var streak: Int = 0
    @Published var lastReceivedData: WeaponOfChoice? = nil
    
    @Published var isTimeKeeper: Bool = false
    @Published var remainingTime = 30
    
    // GameKit
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
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
    
    func startMatch(newMatch: GKMatch) {
        print("Starting new match")
        inGame = true
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        
        sendString("Began: \(playerUUIDKey)")
    }
    
    // Functions
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
            isTimeKeeper = true
            if isTimeKeeper {
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        case "strData:":
            break
            
        default:
            break
        }
        
    }
}
