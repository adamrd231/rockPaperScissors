import SwiftUI

enum GameResult: CustomStringConvertible {
    case win
    case lose
    case tie
    
    var description: String {
        switch self {
        case .win: return "win"
        case .lose: return "lose"
        case .tie: return "tie"
        }
    }
}
