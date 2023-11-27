import SwiftUI

struct LaunchButtonView: View {
    
    var title: String
    var function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            ZStack {
                Capsule()
                    .foregroundColor(Color.theme.backgroundColor)
                    .frame(minWidth: 230)
                Text(title)
                    .foregroundColor(Color.theme.text)
                    .padding()
            }
            .fixedSize()
        }
    }
}
