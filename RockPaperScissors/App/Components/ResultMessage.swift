//
//  ResultMessage.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/7/23.
//

import SwiftUI

struct ResultMessage: View {
    let result: GameOutcome
    let choice: WeaponOfChoice
    
    var body: some View {
        switch result {
        case .win:
            switch choice {
            case .rock: Text("crushes")
            case .paper: Text("covers")
            case .scissors: Text("cuts")
            }
        case .lose:
            switch choice {
            case .rock: Text("covered")
            case .paper: Text("split")
            case .scissors: Text("crushed")
            }
        case .tie: Text("push")
        }
    }
}

struct ResultMessage_Previews: PreviewProvider {
    static var previews: some View {
        ResultMessage(result: .win, choice: .scissors)
    }
}
