//
//  ExplanationView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/6/23.
//

import SwiftUI

struct ExplanationView: View {
    let matchesPlayed:[RPSMatch]
    var body: some View {
        VStack {
            VStack {
                Text("It's the rock, the paper, the scissors!")
                    .font(.title)
                Text("Pick a option, and the computer will randomly pick one as well. Try to get as many wins in a row as possible!")
            }
            .frame(height: UIScreen.main.bounds.height * 0.3)
   
            Divider()
            ScrollView {
                HStack {
                    Text("Record")
                        .bold()
                    Spacer()
                }
                ForEach(Array(zip(matchesPlayed.indices, matchesPlayed)), id: \.0) { index, match in
                    HStack {
                        Text(index + 1, format: .number)
                        Text("Vs \(match.player2.name)")
                        Spacer()
                        Text(match.player1.result?.description ?? "N/A")
                    }
                }
            }
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
        
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView(matchesPlayed: [])
    }
}
