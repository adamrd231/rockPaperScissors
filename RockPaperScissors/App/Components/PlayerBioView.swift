//
//  PlayerBioView.swift
//  RockPaperScissors
//
//  Created by Adam Reed on 12/6/23.
//

import SwiftUI

struct PlayerBio {
    let name: String
    let image: String
    let count: Int
}

struct PlayerBioView: View {
    let playerBio: PlayerBio
    let imageArray = ["paper", "rock", "scissor"]
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.theme.backgroundColor)
                    .cornerRadius(10)
                Image(imageArray.randomElement() ?? "")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .opacity(0.66)
            }
            .fixedSize()
            
            
            VStack(alignment: .leading) {
                Text(playerBio.name)
                    .font(.caption2)
                    .bold()
                HStack(spacing: 1) {
                    if playerBio.count > 0 {
                        Text("+")
                    }
                    Text(playerBio.count, format: .number)
                        .fontWeight(.heavy)
                }
            }
        }
        .padding()
    }
}

struct PlayerBioView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerBioView(
            playerBio: PlayerBio(
                name: "Awesom-0123",
                image: "",
                count: 3
            )
        )
    }
}
