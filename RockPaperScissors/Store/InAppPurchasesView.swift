import SwiftUI
import StoreKit

struct InAppPurchaseView: View {
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        NavigationView {
            List {
                availablePurchasesSection
                Section(header: Text("Restore")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Already made this purchase? Press the button to restore any purchases made on this account in the past.")
                        Button("Restore") {
                            Task {  try await storeManager.restorePurchases() }
                        }
                    }
                }
                explanationSection
                Section(header: Text("Feedback")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("This game is in it's MVP stage. Things will change, game dynamics will get updated, if you really like or really don't like something, feel free to email the link below and I read all the feedback I get.")
                        Link("contact@rdconcepts.design", destination: URL(string: "mailto:contact@rdconcepts.design")!)
                    }
                }
            }
            // Navigation Components
            .navigationTitle("In-App Purchases")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Link("Terms & conditions", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Link("Privacy policy", destination: URL(string: "https://rdconcepts.design/#/privacy")!)
                }
            }
            .listStyle(.sidebar)
        }
        .navigationViewStyle(.stack)
    }
}


struct InAppPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        InAppPurchaseView(storeManager: StoreManager())
//            .preferredColorScheme(.dark)
    }
}

extension InAppPurchaseView {
    var explanationSection: some View {
        Section(header: Text("About me")) {
            VStack(alignment: .leading, spacing: 10) {
                Text(
                    """
                    I am a software engineer working towards supporting myself with revenue from the apps I develop. I try to solve a unique problem every time I launch something to the app store, and would love to do this full-time. Advertising and in-app purchases are what will get me to that goal!
                    """
                )
                Text("This app uses banner advertising, (the small ads at the bottom of the screen) Interstitial (video ads that interrupt you while in the app) and Rewarded (video ads you request in order to reset game details.")
                Text("By subscribing to the app, all banner and interstitial advertising is removed.")
            }
            .padding(5)
        }
    }
    
    var availablePurchasesSection: some View {
        Section(header: Text("Available Purchases")) {
            VStack {
                if AppStore.canMakePayments {
                    ForEach(storeManager.products, id: \.id) { product in
                       // Show option to purchase
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .bold()
                                Text(product.description)
                                    .font(.caption)
                            }
                            Spacer()
                            if storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember) {
                                Image(systemName: "checkmark.circle")
                            } else {
                                Button("$\(product.price.description)") {
                                    // Make purchase
                                    Task {
                                        try await storeManager.purchase(product)
                                    }
                                }
                                .disabled(storeManager.purchasedProductIDs.contains(StoreIDsConstant.platinumMember))
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                } else {
                    Text("You apple account is not currently setup for making payments")
                }
            }
            .padding(5)
        }
    }
}
