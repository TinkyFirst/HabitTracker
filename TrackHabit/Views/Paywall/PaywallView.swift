import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var isPurchasing = false

    enum SubscriptionPlan {
        case monthly
        case yearly
        case lifetime

        var title: String {
            switch self {
            case .monthly: return "paywall.monthly".localized
            case .yearly: return "paywall.yearly".localized
            case .lifetime: return "paywall.lifetime".localized
            }
        }

        var price: String {
            switch self {
            case .monthly: return "$2.99"
            case .yearly: return "$19.99"
            case .lifetime: return "$59.99"
            }
        }

        var pricePerMonth: String {
            switch self {
            case .monthly: return "$2.99" + "paywall.perMonth".localized
            case .yearly: return "$2.08" + "paywall.perMonth".localized
            case .lifetime: return "paywall.oneTime".localized
            }
        }

        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "paywall.save".localized
            case .lifetime: return "paywall.bestValue".localized
            }
        }

        var badge: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "paywall.popular".localized
            case .lifetime: return "paywall.bestValue".localized
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        // Header
                        VStack(spacing: AppTheme.spacingM) {
                            Text("👑")
                                .font(.system(size: 60))

                            Text("paywall.title".localized)
                                .font(.title)
                                .fontWeight(.bold)

                            Text("paywall.subtitle".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)

                        // Features
                        featuresSection

                        // Plans
                        plansSection

                        // Trial info
                        if selectedPlan == .yearly {
                            Text("paywall.trialInfo".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // CTA Button
                        Button(action: purchase) {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(selectedPlan == .yearly ? "paywall.startTrial".localized : "paywall.continue".localized)
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
                        .disabled(isPurchasing)

                        // Restore purchases
                        Button(action: restorePurchases) {
                            Text("settings.restorePurchases".localized)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }

                        // Legal
                        legalSection
                    }
                    .padding(AppTheme.spacingL)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("paywall.close".localized) {
                        dismiss()
                    }
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

    private var featuresSection: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                FeatureBullet(
                    icon: "infinity",
                    title: "paywall.featureUnlimited".localized,
                    description: "paywall.featureUnlimitedDesc".localized
                )

                Divider()

                FeatureBullet(
                    icon: "chart.bar.fill",
                    title: "paywall.featureInsights".localized,
                    description: "paywall.featureInsightsDesc".localized
                )

                Divider()

                FeatureBullet(
                    icon: "bell.badge.fill",
                    title: "paywall.featureReminders".localized,
                    description: "paywall.featureRemindersDesc".localized
                )

                Divider()

                FeatureBullet(
                    icon: "icloud.fill",
                    title: "paywall.featureIcloud".localized,
                    description: "paywall.featureIcloudDesc".localized
                )

                Divider()

                FeatureBullet(
                    icon: "tag.fill",
                    title: "paywall.featureTags".localized,
                    description: "paywall.featureTagsDesc".localized
                )

                Divider()

                FeatureBullet(
                    icon: "square.and.arrow.up.fill",
                    title: "paywall.featureExport".localized,
                    description: "paywall.featureExportDesc".localized
                )
            }
            .padding()
        }
    }

    private var plansSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            PlanCard(
                plan: .yearly,
                isSelected: selectedPlan == .yearly
            ) {
                selectedPlan = .yearly
            }

            PlanCard(
                plan: .monthly,
                isSelected: selectedPlan == .monthly
            ) {
                selectedPlan = .monthly
            }

            PlanCard(
                plan: .lifetime,
                isSelected: selectedPlan == .lifetime
            ) {
                selectedPlan = .lifetime
            }
        }
    }

    private var legalSection: some View {
        VStack(spacing: AppTheme.spacingXS) {
            Text("paywall.autoRenewable".localized)
                .font(.caption2)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                Link("paywall.terms".localized, destination: URL(string: "https://trackhabit.app/terms")!)
                    .font(.caption2)
                    .foregroundColor(.blue)

                Text("•")
                    .foregroundColor(.secondary)

                Link("paywall.privacy".localized, destination: URL(string: "https://trackhabit.app/privacy")!)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom)
    }

    private func purchase() {
        isPurchasing = true

        // Integrate with StoreKit 2 here
        // For now, just simulate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPurchasing = false
            // On success, dismiss
            // dismiss()
        }
    }

    private func restorePurchases() {
        // Restore purchases logic
    }
}

struct FeatureBullet: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: AppTheme.spacingM) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct PlanCard: View {
    let plan: PaywallView.SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            GlassCard {
                HStack(spacing: AppTheme.spacingM) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(plan.title)
                                .font(.headline)

                            if let badge = plan.badge {
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

                        Text(plan.pricePerMonth)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let savings = plan.savings {
                            Text(savings)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(plan.price)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)

                        if plan == .lifetime {
                            Text("paywall.oneTime".localized)
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
    PaywallView()
}
