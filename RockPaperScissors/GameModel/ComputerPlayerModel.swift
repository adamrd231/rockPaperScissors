import Foundation

protocol RPSgamePlayer {
    var id: String { get set }
    var name: String { get set }
}

struct ComputerPlayer: RPSgamePlayer {
    var id: String
    var name: String
    var weaponOfChoice: WeaponOfChoice = WeaponOfChoice.allCases[Int.random(in: 0..<3)]
}

struct PersonPlayer: RPSgamePlayer {
    var id: String
    var name: String
    var weaponOfChoice: WeaponOfChoice? = nil
}
