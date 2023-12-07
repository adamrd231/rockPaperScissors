import Foundation
import CoreData

class GameDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "GameDataHistory"
    private let entityName: String = "GameHistory"
    
    @Published var savedCartEntities: [GameHistory] = []
    
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
    }
    
    func getGameHistory() {
        let request = NSFetchRequest<GameHistory>(entityName: entityName)
        
        do {
            savedCartEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio: \(error)")
        }
    }
}
