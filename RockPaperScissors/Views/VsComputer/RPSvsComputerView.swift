import SwiftUI
import GameKit

struct RPSvsComputerView: View {
    @ObservedObject var computerVM: VsComputerViewModel
    @ObservedObject var vm: ViewModel
    @ObservedObject var admobVM: AdsViewModel

    
    var body: some View {
        VStack {
            HStack {
                Button {
                    computerVM.inGame = false
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "arrowtriangle.backward.fill")
                            .resizable()
                            .frame(width: 20, height: 25)
                        Text("Go back")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .foregroundColor(Color(.systemGray))
                    .cornerRadius(12)
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.33)
     
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
                    computerVM.isResettingStreak.toggle()
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Reset streak")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .foregroundColor(Color(.systemGray))
                    .cornerRadius(12)
          
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.33)
//                .disabled(admobVM.rewarded.rewardedAd == nil)
                .alert("Watch ad to reset streak?", isPresented: $computerVM.isResettingStreak) {
                    Button {
                        computerVM.showRewardedAd()
                    } label: {
                        Text("Im sure")
                    }
                    Button {
                        
                    } label: {
                        Text("Cancel")
                    }
                } message: {
                    Text("Are you sure, this can not be un-done?")
                }
                .statusBar(hidden: true)

            }
            .padding()
            .padding(.top, 35)
          
           
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
                            computerVM.resetGame()
                            admobVM.interstitialCounter += 1
                        }
                        .buttonStyle(.bordered)
                    }
                    .onTapGesture {
                        computerVM.resetGame()
                        admobVM.interstitialCounter += 1
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
            computerVM.loadRewardedAd()
        }
        .onDisappear {
            // TODO: Only send this if it's a high score?
            // If score is better than leaderboard overall, submit to overall
            // Update score for player of the week
            vm.submitScoreToLeaderBoard(newHighScore: computerVM.streak)
        }

    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsComputerView(
            computerVM: VsComputerViewModel(),
            vm: ViewModel(),
            admobVM: AdsViewModel()
        )
        .preferredColorScheme(.dark)
    }
}
