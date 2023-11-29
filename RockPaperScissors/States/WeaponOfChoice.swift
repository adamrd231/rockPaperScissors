import SwiftUI

enum WeaponOfChoice: CustomStringConvertible, Equatable, CaseIterable {
    case rock
    case scissors
    case paper
    var description: String {
        switch self {
        case .rock: return "rock"
        case .paper: return "paper"
        case .scissors: return "scissor"
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
