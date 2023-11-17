import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var computerVM: VsComputerViewModel
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            HStack {
                Button {
                    computerVM.inGame = false
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
                Spacer()
                VStack {
                    Text(computerVM.streak > -1 ? "Wins" : "Loses")
                    Text(computerVM.streak, format: .number)
                        .font(.largeTitle)
                }
                .bold()

                Spacer()
                Button {
                    // Reset streak counter to 0
                    computerVM.streak = 0
                    // TODO: Make user watch an ad to do this
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
            }
            .padding()
            .padding(.top, 35)
          
            Spacer()
           
            if let result = computerVM.gameResult {
                if let choice = computerVM.userChoice,
                   let computerChoice = computerVM.computerChoice {
                    VStack {
                        Text(result.description)
                            .font(.largeTitle)
                            .padding()
                            .textCase(.uppercase)
                        HStack {
                            VStack {
                                Text("You chose:")
                                Image(choice.description)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            VStack {
                                Text("Computer chose:")
                                Image(computerChoice.description)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        Button("Play Again") {
                            computerVM.userChoice = nil
                            computerVM.gameResult = nil
                            computerVM.computerChoice = computerVM.choices[Int.random(in: 0..<3)]
                        }
                        .buttonStyle(.bordered)
                    }
                    .onTapGesture {
                        computerVM.userChoice = nil
                        computerVM.gameResult = nil
                        computerVM.computerChoice = computerVM.choices[Int.random(in: 0..<3)]
                    }
                }
            } else {
                VStack {
                    ForEach(computerVM.choices, id: \.self) { choice in
                        Button {
                            // Play game
                            computerVM.userChoice = choice
                            computerVM.rockPaperScissors(choice, computerVM.computerChoice)
                        } label: {
                            ZStack {
                                Capsule()
                                    .foregroundColor(choice == computerVM.userChoice ? Color(.systemGray4) : Color(.systemGray6))
                                
                                VStack(spacing: 0) {
                                    
                                    Image(choice.description)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .font(.largeTitle)
                                    Text(choice.description)
                                }
                                .padding()
                                .frame(minWidth: 250, minHeight: 90)
                                .foregroundColor(Color(.systemGray))
                            }
                            .fixedSize()
                        }
                        .disabled(computerVM.gameResult != nil)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .onAppear {
            print("Loading achievements \(computerVM.gamesPlayed)")
            vm.loadAchievements(gamesPlayed: computerVM.gamesPlayed)
        }
        .onDisappear {
            print("Saving game to leaderboard")
            // TODO: implement both below
            // If score is better than leaderboard overall, submit to overall
            
            // Update score for player of the week
            
            print("Authenticated")
            vm.submitScoreToLeaderBoard(newHighScore: computerVM.streak)
        }

    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(
            computerVM: VsComputerViewModel(),
            vm: ViewModel()
        )
    }
}
