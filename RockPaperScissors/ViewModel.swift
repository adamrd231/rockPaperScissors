import Foundation
import SwiftUI
import GameKit
import Combine

class ViewModel: NSObject, ObservableObject {
    
    // Game Center
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isRoundOver = false
    @Published var authenticationState = PlayerAuthState.authenticating

    // Game
    let choices:[WeaponOfChoice] = [.rock, .scissors, .paper]
    @Published var gameResult: GameResult? = nil
    @Published var computerChoice: WeaponOfChoice? = nil
    @Published var userChoice: WeaponOfChoice? = nil
    @AppStorage("bestStreak") var streak: Int = 0
    @Published var lastReceivedData: WeaponOfChoice? = nil
    private var cancellable = Set<AnyCancellable>()
    var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var isTimeKeeper: Bool = false
    @Published var remainingTime = 30 {
        willSet {
            print("NewValue \(newValue)")
            if isTimeKeeper { sendString("timer:\(newValue)") }
            if newValue <= 0 { gameOver() }
        }
    }
    
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
    
    func gameOver() {
        countdownTimer.upstream.connect().cancel()
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
        print("received string: \(message)")
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
            print("PlayerYYUDIKEY \(playerUUIDKey)")
            print("Parameter: \(parameter)")
            print(playerUUIDKey > parameter)
            isTimeKeeper = playerUUIDKey > parameter
            if isTimeKeeper {

                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
            
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
            print("SHould be updating time")
//            remainingTime = Int(parameter) ?? 0
            
        default:
            break
        }
        
    }
}
