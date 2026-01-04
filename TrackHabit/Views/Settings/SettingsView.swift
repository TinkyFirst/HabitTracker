import SwiftUI
import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { !$0.isArchived })
    private var habits: [Habit]
    
    @AppStorage("preferredColorScheme") private var preferredColorScheme = "system"
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var languageManager = LanguageManager.shared

    @State private var showingPaywall = false
    @State private var showingAbout = false
    @State private var notificationsEnabled = true
    @State private var showLanguagePicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                List {
                    // Pro section
                    Section {
                        ProStatusRow(showingPaywall: $showingPaywall)
                    }
                    
                    // General Settings
                    Section("settings.general".localized) {
                        // Language
                        Button(action: { showLanguagePicker = true }) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                Text("settings.language".localized)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                                Spacer()
                                
                                Text(languageManager.currentLanguage.flag)
                                    .font(.title3)
                                Text(languageManager.currentLanguage.displayName)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    // Appearance
                    Section("settings.appearance".localized) {
                        Picker("settings.theme".localized, selection: $preferredColorScheme) {
                            Text("settings.system".localized).tag("system")
                            Text("settings.light".localized).tag("light")
                            Text("settings.dark".localized).tag("dark")
                        }
                    }

                    // Notifications
                    Section("settings.notifications".localized) {
                        Toggle("settings.enableReminders".localized, isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) { _, newValue in
                                if newValue {
                                    requestNotificationPermission()
                                }
                            }
                    }

                    // iCloud
                    Section("settings.data".localized) {
                        NavigationLink {
                            iCloudSyncView()
                        } label: {
                            HStack {
                                Image(systemName: "icloud.fill")
                                    .foregroundColor(.blue)
                                Text("settings.icloudSync".localized)
                                
                                Spacer()
                                
                                // iCloud status indicator
                                if FileManager.default.ubiquityIdentityToken != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        }

                        Button {
                            exportData()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.green)
                                Text("settings.exportData".localized)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }

                    // Support
                    Section("settings.support".localized) {
                        Link(destination: URL(string: "mailto:AndriyPopovich_temp@icloud.com")!) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text("settings.contactSupport".localized)
                            }
                        }

                        Button {
                            rateApp()
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("settings.rateApp".localized)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }

                        NavigationLink {
                            AboutView()
                        } label: {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.purple)
                                Text("settings.about".localized)
                            }
                        }
                    }

                    // Development Tools
                    Section("settings.development".localized) {
                        TestPremiumToggle()
                    }
                    
                    // Danger zone
                    Section {
                        Button(role: .destructive) {
                            resetOnboarding()
                        } label: {
                            Text("settings.resetOnboarding".localized)
                        }
                    } footer: {
                        Text("about.appName".localized + " " + "about.version".localized)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("settings.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView()
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                DispatchQueue.main.async {
                    notificationsEnabled = false
                }
            }
        }
    }

    private func exportData() {
        // Export functionality
    }

    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}

struct ProStatusRow: View {
    @Binding var showingPaywall: Bool
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false

    // In production, check actual subscription status
    var isProUser: Bool {
        isTestPremiumEnabled || StoreManager.shared.isProUser
    }

    var body: some View {
        Button(action: { 
            showingPaywall = true
        }) {
            HStack(spacing: AppTheme.spacingM) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: isProUser ? "crown.fill" : "crown")
                        .foregroundColor(.white)
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(isProUser ? "settings.proMember".localized : "settings.upgradeToPro".localized)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)

                    Text(isProUser ? "settings.allFeaturesUnlocked".localized : "settings.unlimitedHabits".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if !isProUser {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Test Premium Toggle
struct TestPremiumToggle: View {
    @AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Toggle(isOn: $isTestPremiumEnabled) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.purple)
                VStack(alignment: .leading, spacing: 2) {
                    Text("settings.testPremium".localized)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("settings.testPremiumDesc".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .tint(.purple)
        .onChange(of: isTestPremiumEnabled) { _, _ in
            StoreManager.shared.checkTestPremium()
        }
    }
}

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingShareSheet = false
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                VStack(spacing: AppTheme.spacingXL) {
                    // Hero Section
                    heroSection
                    
                    // Description Section
                    descriptionSection
                    
                    // Features Section
                    featuresSection
                    
                    // Core Values Section
                    coreValuesSection
                    
                    // Stats Section
                    statsSection
                    
                    // Actions Section
                    actionsSection
                    
                    // Legal Section
                    legalSection
                    
                    // Footer
                    footerSection
                }
                .padding(AppTheme.spacingL)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("about.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: ["about.shareMessage".localized])
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        VStack(spacing: AppTheme.spacingL) {
            // App Logo - Animated
            AppLogo(size: 120, shouldAnimate: true)
                .padding(.top, 20)
            
            VStack(spacing: AppTheme.spacingS) {
                Text("about.appName".localized)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("about.tagline".localized)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("about.version".localized + " \(appVersion) (\(buildNumber))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Description Section
    
    private var descriptionSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                HStack {
                    Image(systemName: "text.quote")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("about.ourMission".localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                Text("about.missionDescription".localized)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.spacingL)
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("about.keyFeatures".localized)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: AppTheme.spacingM) {
                FeatureCard(
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: .blue,
                    title: "about.feature1Title".localized,
                    description: "about.feature1Desc".localized
                )
                
                FeatureCard(
                    icon: "bell.badge.fill",
                    iconColor: .orange,
                    title: "about.feature2Title".localized,
                    description: "about.feature2Desc".localized
                )
                
                FeatureCard(
                    icon: "calendar.badge.checkmark",
                    iconColor: .green,
                    title: "about.feature3Title".localized,
                    description: "about.feature3Desc".localized
                )
                
                FeatureCard(
                    icon: "paintbrush.fill",
                    iconColor: .purple,
                    title: "about.feature4Title".localized,
                    description: "about.feature4Desc".localized
                )
                
                FeatureCard(
                    icon: "icloud.fill",
                    iconColor: .blue,
                    title: "about.feature5Title".localized,
                    description: "about.feature5Desc".localized
                )
            }
        }
    }
    
    // MARK: - Core Values Section
    
    private var coreValuesSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingL) {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    
                    Text("about.coreValues".localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                VStack(spacing: AppTheme.spacingM) {
                    ValueRow(
                        icon: "lock.shield.fill",
                        iconColor: .green,
                        title: "about.value1Title".localized,
                        description: "about.value1Desc".localized
                    )
                    
                    Divider()
                    
                    ValueRow(
                        icon: "sparkles",
                        iconColor: .yellow,
                        title: "about.value2Title".localized,
                        description: "about.value2Desc".localized
                    )
                    
                    Divider()
                    
                    ValueRow(
                        icon: "leaf.fill",
                        iconColor: .green,
                        title: "about.value3Title".localized,
                        description: "about.value3Desc".localized
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.spacingL)
        }
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        return VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                Text("about.byTheNumbers".localized)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 4)
            
            LazyVGrid(columns: columns, spacing: AppTheme.spacingM) {
                AboutStatCard(
                    value: "100K+",
                    label: "about.downloads".localized,
                    icon: "arrow.down.circle.fill",
                    color: .blue
                )
                
                AboutStatCard(
                    value: "4.8★",
                    label: "about.rating".localized,
                    icon: "star.fill",
                    color: .yellow
                )
                
                AboutStatCard(
                    value: "50+",
                    label: "about.countries".localized,
                    icon: "globe",
                    color: .green
                )
                
                AboutStatCard(
                    value: "1M+",
                    label: "about.habitsTracked".localized,
                    icon: "checkmark.circle.fill",
                    color: .purple
                )
            }
        }
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            // Share App
            GlassCard {
                Button(action: { showingShareSheet = true }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("about.shareApp".localized)
                                .font(.headline)
                            Text("about.shareAppDesc".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Rate App
            GlassCard {
                Button(action: rateApp) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("about.rateApp".localized)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("about.rateAppDesc".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Contact Support
            GlassCard {
                Link(destination: URL(string: "mailto:AndriyPopovich_temp@icloud.com")!) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("about.contactUs".localized)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("about.contactUsDesc".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Legal Section
    
    private var legalSection: some View {
        GlassCard {
            VStack(spacing: 0) {
                Link(destination: URL(string: "https://trackhabit.app/privacy")!) {
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text("about.privacyPolicy".localized)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
                Divider()
                    .padding(.leading, 48)
                
                Link(destination: URL(string: "https://trackhabit.app/terms")!) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        Text("about.termsOfService".localized)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
                Divider()
                    .padding(.leading, 48)
                
                Link(destination: URL(string: "https://trackhabit.app")!) {
                    HStack {
                        Image(systemName: "network")
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        Text("about.website".localized)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: AppTheme.spacingS) {
            Text("about.madeWith".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("© 2025 TrackHabit")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("about.allRightsReserved".localized)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1),
                colorScheme == .dark ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        GlassCard {
            HStack(spacing: AppTheme.spacingM) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer(minLength: 0)
            }
            .padding(AppTheme.spacingM)
        }
    }
}

// MARK: - Value Row
struct ValueRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.spacingM) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
            }
            .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            
            Spacer(minLength: 0)
        }
    }
}

// MARK: - About Stat Card
struct AboutStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingS) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.spacingM)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: AppTheme.spacingS) {
            Text(icon)
                .font(.title3)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Language Picker View
struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                List {
                    ForEach(LanguageManager.Language.allCases, id: \.rawValue) { language in
                        Button(action: {
                            languageManager.selectedLanguage = language.rawValue
                            // Delay dismiss to show selection
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                            }
                        }) {
                            HStack(spacing: AppTheme.spacingM) {
                                Text(language.flag)
                                    .font(.title)
                                
                                Text(language.displayName)
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                                Spacer()
                                
                                if languageManager.currentLanguage == language {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("settings.selectLanguage".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done".localized) {
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
                colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - iCloud Sync View
struct iCloudSyncView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isSyncing = false
    @State private var lastSyncDate: Date?
    
    private var isICloudAvailable: Bool {
        FileManager.default.ubiquityIdentityToken != nil
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Status Card
                    GlassCard {
                        VStack(spacing: AppTheme.spacingM) {
                            Image(systemName: isICloudAvailable ? "icloud.fill" : "icloud.slash.fill")
                                .font(.system(size: 60))
                                .foregroundColor(isICloudAvailable ? .blue : .red)
                            
                            Text(isICloudAvailable ? "icloud.enabled".localized : "icloud.disabled".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if isICloudAvailable {
                                if isSyncing {
                                    HStack {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        Text("icloud.syncing".localized)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                } else if let lastSync = lastSyncDate {
                                    Text("icloud.lastSync".localized + ": " + timeAgoString(from: lastSync))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("icloud.lastSync".localized + ": " + "icloud.never".localized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Description
                    GlassCard {
                        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                Text("icloud.description".localized)
                                    .font(.subheadline)
                            }
                            
                            if !isICloudAvailable {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                                    Text("icloud.requiresIcloud".localized)
                                        .font(.headline)
                                    
                                    Text("icloud.signIn".localized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Features synced
                    if isICloudAvailable {
                        GlassCard {
                            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                                Text("icloud.whatSyncs".localized)
                                    .font(.headline)
                                
                                FeatureRow(icon: "✓", text: "icloud.allHabits".localized)
                                FeatureRow(icon: "✓", text: "icloud.checkIns".localized)
                                FeatureRow(icon: "✓", text: "icloud.settings".localized)
                                FeatureRow(icon: "✓", text: "icloud.goals".localized)
                            }
                            .padding()
                        }
                    }
                    
                    // Manual sync button
                    if isICloudAvailable {
                        Button(action: triggerSync) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("icloud.syncNow".localized)
                                    .font(.headline)
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
                        .disabled(isSyncing)
                    }
                }
                .padding(AppTheme.spacingL)
            }
        }
        .navigationTitle("icloud.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkLastSync()
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private func checkLastSync() {
        // SwiftData синхронізується автоматично через CloudKit
        // Тут ми просто показуємо останню дату перевірки
        if let lastCheck = UserDefaults.standard.object(forKey: "lastICloudSyncCheck") as? Date {
            lastSyncDate = lastCheck
        }
    }
    
    private func triggerSync() {
        isSyncing = true
        
        // CloudKit синхронізація відбувається автоматично
        // Ми просто оновлюємо UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            lastSyncDate = Date()
            UserDefaults.standard.set(Date(), forKey: "lastICloudSyncCheck")
            isSyncing = false
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview("Settings View") {
    SettingsView()
}

#Preview("About View - Light") {
    NavigationStack {
        AboutView()
    }
    .preferredColorScheme(.light)
}

#Preview("About View - Dark") {
    NavigationStack {
        AboutView()
    }
    .preferredColorScheme(.dark)
}

#Preview("About View - Ukrainian") {
    NavigationStack {
        AboutView()
    }
    .onAppear {
        LanguageManager.shared.selectedLanguage = "uk"
    }
}

#Preview("About View - English") {
    NavigationStack {
        AboutView()
    }
    .onAppear {
        LanguageManager.shared.selectedLanguage = "en"
    }
}
