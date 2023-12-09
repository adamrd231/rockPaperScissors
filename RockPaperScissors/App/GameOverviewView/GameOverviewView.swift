//
//  GameOverviewView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/9/23.
//

import SwiftUI

struct GameOverviewView: View {
    
    @ObservedObject var vsComputerViewModel: VsComputerViewModel
    @State var isResettingGame: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section("Vs Computer") {
                    HStack {
                        Text("Best Streak")
                        Spacer()
                        Text(vsComputerViewModel.gameDataService.bestStreak, format: .number)
                    }
                    HStack {
                        Text("Current Streak")
                        Spacer()
                        Text(vsComputerViewModel.gameDataService.streak, format: .number)
                    }
                    HStack {
                        Text("Win Percentage")
                        Spacer()
                        Text(vsComputerViewModel.gameDataService.winPercentage, format: .percent.precision(.fractionLength(0)))
                    }
                    HStack {
                        Text("Win Percentage")
                        Spacer()

                        Text(vsComputerViewModel.gameDataService.tiePercentage, format: .percent.precision(.fractionLength(0)))
                    }
                    
                }
                Section("VS Computer History") {
                    Button("Clear history") {
                        isResettingGame.toggle()
                    }
                    .alert("Reset game history?", isPresented: $isResettingGame) {
                        Button("I'm sure") {
                            vsComputerViewModel.gameDataService.deleteGameHistory()
                        }
                        Button("No thanks", role: .cancel) { }
                    }
                    ForEach(vsComputerViewModel.matchesPlayed, id: \.id) { match in
                        HStack {
                            Text(match.date, format: .dateTime)
                            Spacer()
                            VStack {
                                Text(match.player1.name)
                                Text(match.player1.weaponOfChoice?.description ?? "N/A")
                            }
                            Spacer()
                            Text("vs")
                            Spacer()
                            VStack {
                                Text(match.player2.name)
                                Text(match.player2.weaponOfChoice?.description ?? "N/A")
                            }
                            Spacer()
                            Text(match.result?.description ?? "N/A")
                            
                        }
                        .font(.caption)
                    }
                }
            }
        }
    }
}

struct GameOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverviewView(vsComputerViewModel: VsComputerViewModel())
    }
}
