import SwiftUI
import StoreKit

struct PaywallViewWithStore: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var store = StoreManager.shared

    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                if store.products.isEmpty {
                    ProgressView("Loading products...")
                } else {
                    ScrollView {
                        VStack(spacing: AppTheme.spacingL) {
                            headerSection
                            featuresSection
                            productsSection

                            if let product = selectedProduct, product.subscription != nil {
                                Text("Start with 7 days free trial")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            purchaseButton
                            restoreButton

                            if let error = errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }

                            legalSection
                        }
                        .padding(AppTheme.spacingL)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if selectedProduct == nil {
                    selectedProduct = store.yearlyProduct
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.purple.opacity(0.3) : Color.purple.opacity(0.15)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var headerSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            Text("👑")
                .font(.system(size: 60))

            Text("Upgrade to Pro")
                .font(.title)
                .fontWeight(.bold)

            Text("Unlock unlimited habits and advanced insights")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                FeatureBullet(icon: "infinity", title: "Unlimited Habits", description: "Track as many habits as you want")
                Divider()
                FeatureBullet(icon: "chart.bar.fill", title: "Advanced Insights", description: "Detailed analytics and trends")
                Divider()
                FeatureBullet(icon: "bell.badge.fill", title: "Multiple Reminders", description: "Set multiple reminders per habit")
                Divider()
                FeatureBullet(icon: "icloud.fill", title: "iCloud Sync", description: "Sync across all your devices")
                Divider()
                FeatureBullet(icon: "tag.fill", title: "Tags & Notes", description: "Organize with tags and notes")
                Divider()
                FeatureBullet(icon: "square.and.arrow.up.fill", title: "Export Data", description: "Export your data anytime")
            }
            .padding()
        }
    }

    private var productsSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            ForEach(store.products, id: \.id) { product in
                ProductCard(
                    product: product,
                    isSelected: selectedProduct?.id == product.id
                ) {
                    selectedProduct = product
                }
            }
        }
    }

    private var purchaseButton: some View {
        Button(action: purchase) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(selectedProduct?.subscription != nil ? "Start Free Trial" : "Continue")
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(AppTheme.cornerRadiusM)
        }
        .disabled(isPurchasing || selectedProduct == nil)
    }

    private var restoreButton: some View {
        Button(action: restorePurchases) {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }

    private var legalSection: some View {
        VStack(spacing: AppTheme.spacingXS) {
            Text("Auto-renewable subscription")
                .font(.caption2)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                Link("Terms", destination: URL(string: "https://trackhabit.app/terms")!)
                    .font(.caption2)
                    .foregroundColor(.blue)

                Text("•")
                    .foregroundColor(.secondary)

                Link("Privacy", destination: URL(string: "https://trackhabit.app/privacy")!)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom)
    }

    private func purchase() {
        guard let product = selectedProduct else { return }

        isPurchasing = true
        errorMessage = nil

        Task {
            do {
                let transaction = try await store.purchase(product)
                isPurchasing = false

                if transaction != nil {
                    dismiss()
                }
            } catch {
                isPurchasing = false
                errorMessage = "Purchase failed. Please try again."
            }
        }
    }

    private func restorePurchases() {
        Task {
            do {
                try await store.restorePurchases()
                // Можна додати feedback після успішного відновлення
            } catch {
                errorMessage = "Failed to restore purchases. Please try again."
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var badge: String? {
        if product.id.contains("yearly") { return "POPULAR" }
        if product.id.contains("lifetime") { return "BEST VALUE" }
        return nil
    }

    private var savings: String? {
        if product.id.contains("yearly") { return "Save 48%" }
        if product.id.contains("lifetime") { return "Best Value" }
        return nil
    }

    private var planTitle: String {
        if product.id.contains("monthly") { return "Monthly" }
        if product.id.contains("yearly") { return "Yearly" }
        return "Lifetime"
    }

    var body: some View {
        Button(action: action) {
            GlassCard {
                HStack(spacing: AppTheme.spacingM) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(planTitle)
                                .font(.headline)

                            if let badge = badge {
                                Text(badge)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                            }
                        }

                        if let pricePerMonth = product.pricePerMonth {
                            Text(pricePerMonth)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Text("One-time payment")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let savings = savings {
                            Text(savings)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(product.displayPrice)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)

                        if product.subscription == nil {
                            Text("One-time")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .blue : .gray)
                        .font(.title3)
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusL)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    PaywallViewWithStore()
}
