//
//  VSComputerViewModel.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 11/13/23.
//

import Foundation

class VsComputerViewModel: ObservableObject {
    // Game
    let choices:[WeaponOfChoice] = [.rock, .paper, .scissors]
    @Published var gameResult: GameResult? = nil
    @Published var computerChoice: WeaponOfChoice
    @Published var userChoice: WeaponOfChoice? = nil
    @Published var streak: Int = 0
    
    @Published var inGame: Bool = false
    
    
    init() {
        computerChoice = choices[Int.random(in: 0..<3)]
    }
}
