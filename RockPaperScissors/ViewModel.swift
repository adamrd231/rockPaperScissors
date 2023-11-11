import Foundation

class ViewModel: ObservableObject {
    @Published var authenticationState = PlayerAuthState.authenticating
}
