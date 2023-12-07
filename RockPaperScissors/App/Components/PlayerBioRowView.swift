import SwiftUI

struct PlayerBioRowView: View {
    let player1: PlayerBio
    let player2: PlayerBio
    var body: some View {
        HStack {
            PlayerBioView(playerBio: player1)
            Spacer()
            Text("VS")
                .font(.callout)
                .fontWeight(.heavy)
            Spacer()
            PlayerBioView(playerBio: player2)
        }
        .foregroundColor(Color.theme.backgroundColor)
        .background(Color.theme.text.opacity(0.8))
    }
}

struct PlayerBioRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerBioRowView(
            player1: PlayerBio(name: "Test", image: "", count: 3),
            player2: PlayerBio(name: "Becky", image: "", count: 69)
        )
    }
}
