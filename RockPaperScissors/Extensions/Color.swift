import SwiftUI

extension Color {
    static var theme = ColorTheme()
}

struct ColorTheme {
    let text = Color("text")
    let backgroundColor = Color("backgroundColor")
    let tabViewBackground = Color("tabViewBackground")
}