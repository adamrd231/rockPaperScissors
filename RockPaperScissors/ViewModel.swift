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
    
    @Published var isTimeKeeper: Bool = false
    
    // GameKit
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    override init() {
        super.init()
        addSubscribers()
    }
    
    func addSubscribers() {
        $userChoice
            .combineLatest($computerChoice)
            .sink { [weak self] user, computer in
                print("Updated choices")
                if let u = user,
                   let c = computer {
                    print("Rock paper scrissors")
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
        streak -= 1
        gameResult = .lose
    }
    
    func playerTie() {
        print("Tied")
        gameResult = .tie
    }
    
    func resetGame() {
        print("reset game")
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
            print("SHould be updating time")
            
        default:
            break
        }
        
    }
}
