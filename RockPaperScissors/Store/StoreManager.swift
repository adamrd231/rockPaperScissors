import Foundation
//import SwiftUI
import StoreKit
import Combine

struct StoreIDsConstant {
    static var platinumMember = "platinumMember"
}

@MainActor
class StoreManager: ObservableObject  {

    private var productIDs = [
        StoreIDsConstant.platinumMember
    ]
    
    @Published var isViewingStore: Bool = false
    @Published var products:[Product] = []
    
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoadingProducts: Bool = false
    @Published var productsLoaded: Bool = false
    
    // Listen for transactions that might be successful but not recorded
    var transactionListener: Task <Void, Error>?
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after products have already been fetched
            // Transactions do not contain product or product info
            await updateCurrentEntitlements()
        }
    }
    
    @MainActor
    func requestProducts() async {
        guard !self.productsLoaded else { return }
        do {
            products = try await Product.products(for: productIDs)
        } catch let error {
            print("Error requesting products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(.verified(let transaction)):
            await transaction.finish()
            purchasedProductIDs.insert(product.id)
        case let .success(.unverified(_, error)):
            print("Purchase error: success but unverified \(error)")
            // Success, but transaction / receipt can't be verified
            // Possibly a jailbroken phone?
            break
        case .pending:
            // Transaction waiting on SCA (Strong customer auth)
            // Needs approval from Ask to Buy
            break
        case .userCancelled:
            break
        default:
            break
        }
    }
    
    func listenForTransactions() -> Task <Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }
    
    @MainActor
    func restorePurchases() async throws {
        try await AppStore.sync()

    }

    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
            case let.verified(transaction):
                guard let product = self.products.first(where: { $0.id == transaction.productID }) else { return }
                if transaction.revocationDate == nil {
//                    self.purchasedNonConsumables.insert(product)
                    self.purchasedProductIDs.insert(product.id)
                } else {
                    self.purchasedProductIDs.remove(product.id)
                }
                await transaction.finish()
            default: return
        }
    }
}

