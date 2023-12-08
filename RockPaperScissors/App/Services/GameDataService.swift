import Foundation
import CoreData

class GameDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "GameDataHistory"
    private let entityName: String = "GameHistory"
    
    @Published var savedGameEntities: [GameHistory] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("""
                    Error loading core data:
                    \(error)
                """)
            }
        }
        getGameHistory()
    }
    
    var streak: Int {
        var consecutiveWins = 0
        for match in savedGameEntities.reversed() {
            if match.result == GameOutcome.win.description {
                consecutiveWins += 1
            } else if match.result == GameOutcome.tie.description {
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

        for match in savedGameEntities {
            if match.result == GameOutcome.win.description {
                consecutiveWins += 1
                if consecutiveWins >= longestStreak {
                    longestStreak = consecutiveWins
                }
            } else if match.result == GameOutcome.tie.description {
                
            } else {
                consecutiveWins = 0
            }
        }
        return longestStreak
    }
    
    func getGameHistory() {
        let request = NSFetchRequest<GameHistory>(entityName: entityName)
        
        do {
            savedGameEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio: \(error)")
        }
    }
    // MARK: GAME History ----------
    func deleteGameHistory() {
        for item in savedGameEntities {
            container.viewContext.delete(item)
        }
        applyChanges()
    }
    
    func addGameToHistory(match: RPSMatch) {
        if let existingEntity = savedGameEntities.first(where: ({ $0.id == match.id })) {
            // TODO: Maybe we allow the games to be updated or rematched somehow?
            print("Existing entity: \(existingEntity)")
        } else {
            let newGame = GameHistory(context: container.viewContext)
            // Update the model with info from game
            newGame.playerOneName = match.player1.name
            newGame.playerOneChoice = match.player1.weaponOfChoice?.description
            newGame.playerTwoName = match.player2.name
            newGame.playerTwoChoice = match.player2.weaponOfChoice?.description
            newGame.result = match.result?.description
            // Save
            applyChanges()
        }
    }
    
    // MARK: Saving Coredata state
    private func save() {
        do {
            try container.viewContext.save()
            
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    func applyChanges() {
        save()
        getGameHistory()
    }
}
