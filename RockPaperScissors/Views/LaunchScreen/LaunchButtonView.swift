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
                    .foregroundColor(Color(.systemGray))
                    .frame(minWidth: 230)
                Text(title)
                    .foregroundColor(Color(.systemGray6))
                    .padding()
            }
            .fixedSize()
        }
    }
}
