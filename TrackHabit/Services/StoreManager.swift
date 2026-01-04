import Foundation
import StoreKit

// Use full StoreKit namespace to avoid conflicts with other types named Product, Transaction, VerificationResult.
@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()

    @Published private(set) var products: [StoreKit.Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var isProUser = false
    
    // Test premium for development
    private var isTestPremiumEnabled: Bool {
        UserDefaults.standard.bool(forKey: "isTestPremiumEnabled")
    }

    private var updateListenerTask: Task<Void, Error>?

    // Product IDs (configure these in App Store Connect)
    private let productIDs = [
        "com.trackhabit.pro.monthly",
        "com.trackhabit.pro.yearly",
        "com.trackhabit.pro.lifetime"
    ]

    private init() {
        updateListenerTask = listenForTransactions()

        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products
    func loadProducts() async {
        do {
            let loadedProducts = try await StoreKit.Product.products(for: productIDs)
            self.products = loadedProducts.sorted { product1, product2 in
                // Sort: monthly, yearly, lifetime
                let order = ["monthly": 0, "yearly": 1, "lifetime": 2]
                let id1 = product1.id.components(separatedBy: ".").last ?? ""
                let id2 = product2.id.components(separatedBy: ".").last ?? ""

                return (order[id1] ?? 99) < (order[id2] ?? 99)
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    // MARK: - Purchase Product
    func purchase(_ product: StoreKit.Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedProducts()
            await transaction.finish()
            return transaction

        case .userCancelled, .pending:
            return nil

        @unknown default:
            return nil
        }
    }

    // MARK: - Restore Purchases
    func restorePurchases() async throws {
        // Синхронізуємо з App Store (включає iCloud)
        try await AppStore.sync()
        
        // Оновлюємо локальний стан покупок
        await updatePurchasedProducts()
    }

    // MARK: - Update Purchased Products
    func updatePurchasedProducts() async {
        var purchasedIDs = Set<String>()

        // Перевіряємо всі поточні entitlements (включає покупки з iCloud)
        for await result in StoreKit.Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                // Перевіряємо чи транзакція не відкликана
                if transaction.revocationDate == nil {
                    purchasedIDs.insert(transaction.productID)
                    
                    // Перевіряємо чи підписка не закінчилась
                    if let expirationDate = transaction.expirationDate,
                       expirationDate < Date() {
                        continue // Підписка закінчилась
                    }
                    
                    purchasedIDs.insert(transaction.productID)
                }
            }
        }

        self.purchasedProductIDs = purchasedIDs
        // Check both real purchases and test premium
        self.isProUser = !purchasedIDs.isEmpty || isTestPremiumEnabled
    }

    // MARK: - Listen for Transactions
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in StoreKit.Transaction.updates {
                if case let .verified(transaction) = result {
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                }
            }
        }
    }

    // MARK: - Check Verified
    private func checkVerified<T>(_ result: StoreKit.VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Helpers
    func product(for id: String) -> StoreKit.Product? {
        products.first { $0.id.contains(id) }
    }

    var monthlyProduct: StoreKit.Product? {
        product(for: "monthly")
    }

    var yearlyProduct: StoreKit.Product? {
        product(for: "yearly")
    }

    var lifetimeProduct: StoreKit.Product? {
        product(for: "lifetime")
    }

    func isPurchased(_ product: StoreKit.Product) -> Bool {
        purchasedProductIDs.contains(product.id)
    }
    
    // MARK: - Test Premium
    func checkTestPremium() {
        Task {
            await updatePurchasedProducts()
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

// MARK: - Product Extensions
extension StoreKit.Product {
    var localizedPrice: String {
        displayPrice
    }

    var pricePerMonth: String? {
        guard let subscription = subscription else { return nil }

        let price = price

        switch subscription.subscriptionPeriod.unit {
        case .month:
            if subscription.subscriptionPeriod.value == 1 {
                return displayPrice + "/mo"
            } else {
                let perMonth = price / Decimal(subscription.subscriptionPeriod.value)
                return formatPrice(perMonth) + "/mo"
            }

        case .year:
            let perMonth = price / 12
            return formatPrice(perMonth) + "/mo"

        default:
            return nil
        }
    }

    private func formatPrice(_ price: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceFormatStyle.locale

        return formatter.string(from: price as NSDecimalNumber) ?? "\(price)"
    }
}
