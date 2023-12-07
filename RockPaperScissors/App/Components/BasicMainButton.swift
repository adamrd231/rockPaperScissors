import SwiftUI

struct BasicMainButton: View {
    var title: String
    var icon: String
    let textColor: Color?
    let background: Color?
    var function: () -> Void
    
    init(title: String, icon: String, textColor: Color = Color.theme.text, background: Color = Color.theme.backgroundColor, function: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.textColor = textColor
        self.background = background
        self.function = function
    }
    
    var body: some View {
        Button {
            function()
        } label: {
            ZStack {
                Capsule()
                    .foregroundColor(background)
                HStack {
                    Image(systemName: icon)
                    Text(title)
                }
                .bold()
                .foregroundColor(textColor)
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
