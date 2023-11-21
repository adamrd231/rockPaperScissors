import SwiftUI
import StoreKit

struct InAppPurchaseView: View {
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        List {
            HStack {
                Button {
                    storeManager.isViewingStore = false
                    
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                }
                Spacer()
                Text("In-App Purchases")
                    .font(.title3)
                    .bold()
                Spacer()
                Button {
                    //
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.clear)
                }
            }
            .padding()

            explanationSection
            availablePurchasesSection
            restorePurchasesSection
            
        }
        .padding(.horizontal)
        .padding(.top, 25)
        .scrollContentBackground(.hidden)
    }
}


struct InAppPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        InAppPurchaseView(storeManager: StoreManager())
    }
}

extension InAppPurchaseView {
    var explanationSection: some View {
        Section(header: Text("About me").foregroundColor(.white).bold()) {
            VStack(alignment: .leading) {
                Text("Why?")
                    .font(.title3)
                    .bold()
                Text(
                    """
                    I am a software engineer working towards supporting myself with revenue from the apps I develop. I use google admob to advertise on
                    my platforms, and by advertising and offering in-app purchases, I can afford to spend more time on new features and apps. Thank you
                    for supporting my on my journey!
                    """
                )
            }
            .padding(5)
            .padding(.vertical, 5)
        }
    }
    
    var availablePurchasesSection: some View {
        Section(header: Text("Available Purchases").foregroundColor(.white).bold()) {
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
            .padding(.vertical, 5)
        }
    }
    
    var restorePurchasesSection: some View {
        Section(header: Text("Restore").foregroundColor(.white).bold()) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Missing something?")
                    .bold()
                Text("Already purchased these? Just click below to restore all the things.")
                Button("Restore purchases") {
                    Task {
                        try await storeManager.restorePurchases()
                    }
                }
                .buttonStyle(.bordered)
                .padding(.vertical, 5)
            }
            .padding(5)
            .padding(.vertical, 5)
        }
    }
}
