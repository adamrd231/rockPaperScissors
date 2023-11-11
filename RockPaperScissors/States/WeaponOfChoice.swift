import SwiftUI

enum WeaponOfChoice: CustomStringConvertible, Comparable {
    case rock
    case scissors
    case paper
    var description: String {
        switch self {
        case .rock: return "rock"
        case .paper: return "paper"
        case .scissors: return "scissors"
        }
    }
    
    var emoji: String {
        switch self {
        case .rock: return "🪨"
        case .paper: return "📄"
        case .scissors: return "✂"
        }
    }
}
