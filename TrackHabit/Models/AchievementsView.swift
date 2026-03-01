import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var achievementManager: AchievementManager

    @Query private var habits: [Habit]
    @Query private var checkIns: [CheckIn]

    @State private var selectedCategory: AchievementDefinition.AchievementCategory?
    @State private var showingDetail: AchievementDefinition?
    @State private var headerAppeared = false
    @State private var cardsAppeared = false

    init(modelContext: ModelContext) {
        _achievementManager = StateObject(wrappedValue: AchievementManager(modelContext: modelContext))
    }

    private var categories: [AchievementDefinition.AchievementCategory] {
        AchievementDefinition.AchievementCategory.allCases
    }

    private var filteredAchievements: [AchievementDefinition] {
        let achievements: [AchievementDefinition]
        if let category = selectedCategory {
            achievements = AchievementDefinition.allAchievements.filter { $0.category == category }
        } else {
            achievements = AchievementDefinition.allAchievements
        }

        // Sort: unlocked first (most recent first), then locked sorted by progress descending
        return achievements.sorted { a, b in
            let aProgress = achievementManager.getAchievementProgress(id: a.id)
            let bProgress = achievementManager.getAchievementProgress(id: b.id)
            let aUnlocked = aProgress.unlockedAt != nil
            let bUnlocked = bProgress.unlockedAt != nil

            if aUnlocked && !bUnlocked { return true }
            if !aUnlocked && bUnlocked { return false }
            if aUnlocked && bUnlocked {
                return (aProgress.unlockedAt ?? .distantPast) > (bProgress.unlockedAt ?? .distantPast)
            }
            return aProgress.progress > bProgress.progress
        }
    }

    private var unlockedCount: Int {
        achievementManager.unlockedAchievements.filter { $0.unlockedAt != nil }.count
    }

    private var totalCount: Int {
        AchievementDefinition.allAchievements.count
    }

    private var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }

    private let accentStart = Color(red: 0.24, green: 0.47, blue: 0.96)
    private let accentEnd = Color(red: 0.42, green: 0.80, blue: 0.72)

    private var pageBackground: some View {
        LinearGradient(
            colors: [
                colorScheme == .dark
                    ? Color(red: 0.06, green: 0.07, blue: 0.10)
                    : Color(red: 0.95, green: 0.96, blue: 0.98),
                colorScheme == .dark
                    ? Color(red: 0.08, green: 0.09, blue: 0.13)
                    : Color(red: 0.92, green: 0.94, blue: 0.97)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with stats
                headerSection
                    .scaleEffect(headerAppeared ? 1 : 0.9)
                    .opacity(headerAppeared ? 1 : 0)

                // Category filter
                categoryFilter
                    .opacity(headerAppeared ? 1 : 0)
                    .offset(y: headerAppeared ? 0 : 10)

                // Achievements grid
                achievementsGrid
            }
            .padding()
        }
        .background(pageBackground)
        .navigationTitle("achievements.title".localized)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            achievementManager.checkAllAchievements(habits: habits, checkIns: checkIns)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                headerAppeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    cardsAppeared = true
                }
            }
        }
        .sheet(item: $showingDetail) { definition in
            achievementDetailSheet(for: definition)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Progress circle with animated gradient
            ZStack {
                // Outer decorative ring
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                accentStart.opacity(0.1),
                                accentEnd.opacity(0.05),
                                accentStart.opacity(0.1)
                            ],
                            center: .center
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)

                // Track circle
                Circle()
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.06)
                            : Color.black.opacity(0.05),
                        lineWidth: 10
                    )
                    .frame(width: 120, height: 120)

                // Progress ring with gradient
                Circle()
                    .trim(from: 0, to: headerAppeared ? completionPercentage : 0)
                    .stroke(
                        AngularGradient(
                            colors: [accentStart, accentEnd, Color(hex: "A78BFA"), accentStart],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3), value: headerAppeared)

                // Center content
                VStack(spacing: 2) {
                    Text("\(unlockedCount)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [accentStart, accentEnd], startPoint: .leading, endPoint: .trailing)
                        )
                    Text("achievements.of".localized)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)
                    Text("\(totalCount)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            // Stats row
            HStack(spacing: 0) {
                RarityStatItem(
                    title: "achievements.common",
                    value: countByRarity(.common),
                    icon: "star.fill",
                    gradient: [Color(red: 0.42, green: 0.49, blue: 0.54), Color(red: 0.55, green: 0.61, blue: 0.66)]
                )

                Divider()
                    .frame(height: 30)
                    .opacity(0.3)

                RarityStatItem(
                    title: "achievements.rare",
                    value: countByRarity(.rare),
                    icon: "star.fill",
                    gradient: [Color(red: 0.16, green: 0.50, blue: 0.83), Color(hex: "6C63FF")]
                )

                Divider()
                    .frame(height: 30)
                    .opacity(0.3)

                RarityStatItem(
                    title: "achievements.legendary",
                    value: countByRarity(.legendary),
                    icon: "crown.fill",
                    gradient: [Color(hex: "F59E0B"), Color(hex: "EF4444")]
                )
            }
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        colorScheme == .dark
                            ? Color(red: 0.10, green: 0.12, blue: 0.16)
                            : Color.white.opacity(0.85)
                    )

                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentStart.opacity(0.04),
                                accentEnd.opacity(0.02),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            colorScheme == .dark ? Color.white.opacity(0.10) : Color.white.opacity(0.7),
                            colorScheme == .dark ? Color.white.opacity(0.03) : Color.white.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: accentStart.opacity(0.08), radius: 20, y: 8)
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 14, alignment: .top),
            GridItem(.flexible(), spacing: 14, alignment: .top)
        ]
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                AchievementCategoryChip(
                    title: "achievement.category.all",
                    isSelected: selectedCategory == nil,
                    gradient: [accentStart, accentEnd]
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedCategory = nil
                    }
                }

                ForEach(categories, id: \.self) { category in
                    AchievementCategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        gradient: [accentStart, accentEnd]
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Achievements Grid
    private var achievementsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 14) {
            ForEach(Array(filteredAchievements.enumerated()), id: \.element.id) { index, definition in
                Button {
                    showingDetail = definition
                } label: {
                    AchievementCardView(
                        definition: definition,
                        achievement: achievementManager.getAchievementProgress(id: definition.id),
                        compact: false
                    )
                }
                .buttonStyle(AchievementCardButtonStyle())
                .opacity(cardsAppeared ? 1 : 0)
                .offset(y: cardsAppeared ? 0 : 20)
                .animation(
                    .spring(response: 0.45, dampingFraction: 0.8)
                    .delay(Double(index) * 0.04),
                    value: cardsAppeared
                )
            }
        }
    }

    // MARK: - Detail Sheet
    private func achievementDetailSheet(for definition: AchievementDefinition) -> some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Large animated icon
                    AchievementDetailIcon(definition: definition)
                        .padding(.top, 24)

                    // Title and description
                    VStack(spacing: 10) {
                        Text(definition.titleKey.localized)
                            .font(.system(size: 26, weight: .bold))
                            .multilineTextAlignment(.center)

                        Text(definition.descriptionKey.localized)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        // Rarity badge
                        HStack(spacing: 5) {
                            ForEach(0..<definition.rarity.rawValue, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundStyle(detailRarityGradient(definition))
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)

                    // Progress
                    let achievement = achievementManager.getAchievementProgress(id: definition.id)
                    detailProgressSection(definition: definition, achievement: achievement)

                    // Details card
                    detailInfoCard(definition: definition)
                }
                .padding(.bottom, 32)
            }
            .background(
                LinearGradient(
                    colors: [
                        colorScheme == .dark
                            ? Color(red: 0.06, green: 0.07, blue: 0.10)
                            : Color(red: 0.95, green: 0.96, blue: 0.98),
                        colorScheme == .dark
                            ? Color(red: 0.08, green: 0.09, blue: 0.13)
                            : Color(red: 0.92, green: 0.94, blue: 0.97)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("achievements.done".localized) {
                        showingDetail = nil
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private func detailProgressSection(definition: AchievementDefinition, achievement: Achievement) -> some View {
        let accentColor = Color(hex: definition.color)

        if let unlockedAt = achievement.unlockedAt {
            // Unlocked state
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(.green)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("achievements.unlocked_on".localized)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(formatDate(unlockedAt))
                        .font(.headline)
                }

                Spacer()
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.green.opacity(colorScheme == .dark ? 0.08 : 0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.green.opacity(0.15), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
        } else {
            // Progress state
            VStack(spacing: 12) {
                HStack {
                    Text("achievements.progress".localized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(achievement.progress)/\(definition.requirement)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(accentColor)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(accentColor.opacity(0.10))

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * min(Double(achievement.progress) / Double(definition.requirement), 1.0)
                            )
                            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: achievement.progress)
                    }
                }
                .frame(height: 10)
                .clipShape(Capsule())
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        colorScheme == .dark
                            ? Color(red: 0.12, green: 0.14, blue: 0.18)
                            : Color(red: 0.96, green: 0.97, blue: 0.98)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04),
                                lineWidth: 1
                            )
                    )
            )
            .padding(.horizontal)
        }
    }

    private func detailInfoCard(definition: AchievementDefinition) -> some View {
        VStack(spacing: 0) {
            DetailInfoRow(
                icon: "tag.fill",
                iconColor: .blue,
                title: "achievements.category",
                value: definition.category.rawValue
            )

            Divider().padding(.horizontal)

            DetailInfoRow(
                icon: "star.fill",
                iconColor: .orange,
                title: "achievements.rarity",
                value: rarityText(definition.rarity)
            )

            Divider().padding(.horizontal)

            DetailInfoRow(
                icon: "target",
                iconColor: .green,
                title: "achievements.requirement",
                value: "\(definition.requirement)",
                isValueLocalized: false
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    colorScheme == .dark
                        ? Color(red: 0.12, green: 0.14, blue: 0.18)
                        : Color(red: 0.96, green: 0.97, blue: 0.98)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal)
    }

    private func detailRarityGradient(_ definition: AchievementDefinition) -> LinearGradient {
        let colors: [Color]
        switch definition.rarity {
        case .common: colors = [Color(red: 0.43, green: 0.49, blue: 0.54), Color(red: 0.55, green: 0.61, blue: 0.66)]
        case .uncommon: colors = [Color(red: 0.26, green: 0.61, blue: 0.49), Color(red: 0.20, green: 0.74, blue: 0.55)]
        case .rare: colors = [Color(red: 0.16, green: 0.50, blue: 0.83), Color(hex: "6C63FF")]
        case .epic: colors = [Color(hex: "8B5CF6"), Color(hex: "EC4899")]
        case .legendary: colors = [Color(hex: "F59E0B"), Color(hex: "EF4444")]
        }
        return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }

    private func countByRarity(_ rarity: AchievementDefinition.AchievementRarity) -> Int {
        let unlockedIds = Set(achievementManager.unlockedAchievements.compactMap { $0.unlockedAt != nil ? $0.id : nil })
        return AchievementDefinition.allAchievements.filter {
            $0.rarity == rarity && unlockedIds.contains($0.id)
        }.count
    }

    private func rarityText(_ rarity: AchievementDefinition.AchievementRarity) -> String {
        switch rarity {
        case .common: return "achievements.rarity.common"
        case .uncommon: return "achievements.rarity.uncommon"
        case .rare: return "achievements.rarity.rare"
        case .epic: return "achievements.rarity.epic"
        case .legendary: return "achievements.rarity.legendary"
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = LanguageManager.shared.selectedLanguage == "uk"
            ? Locale(identifier: "uk_UA")
            : Locale(identifier: "en_US")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Achievement Card Button Style
struct AchievementCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Rarity Stat Item
struct RarityStatItem: View {
    let title: String
    let value: Int
    let icon: String
    let gradient: [Color]

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundStyle(
                        LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing)
                    )

                Text("\(value)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing)
                    )
            }

            Text(title.localized)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Achievement Category Chip
struct AchievementCategoryChip: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let isSelected: Bool
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title.localized)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, 16)
                .frame(height: 36)
                .fixedSize(horizontal: true, vertical: false)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: gradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                : AnyShapeStyle(
                                    colorScheme == .dark
                                        ? Color(red: 0.14, green: 0.16, blue: 0.20)
                                        : Color.white.opacity(0.8)
                                )
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected
                                ? Color.white.opacity(0.20)
                                : (colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)),
                            lineWidth: 1
                        )
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .shadow(
                    color: isSelected ? gradient.first!.opacity(0.25) : .clear,
                    radius: 8,
                    y: 3
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Achievement Detail Icon
struct AchievementDetailIcon: View {
    let definition: AchievementDefinition
    @State private var ringRotation: Double = 0
    @State private var iconScale: CGFloat = 0.5
    @State private var glowPulse = false

    private var accentColor: Color { Color(hex: definition.color) }

    private var rarityGradient: [Color] {
        switch definition.rarity {
        case .common: return [accentColor, accentColor.opacity(0.7)]
        case .uncommon: return [accentColor, accentColor.opacity(0.8)]
        case .rare: return [accentColor, Color(hex: "6C63FF")]
        case .epic: return [Color(hex: "8B5CF6"), Color(hex: "EC4899")]
        case .legendary: return [Color(hex: "F59E0B"), Color(hex: "EF4444"), Color(hex: "F59E0B")]
        }
    }

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [accentColor.opacity(0.2), .clear],
                        center: .center,
                        startRadius: 40,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(glowPulse ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowPulse)

            // Decorative ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: rarityGradient + [rarityGradient.first ?? accentColor],
                        center: .center
                    ),
                    lineWidth: 2.5
                )
                .frame(width: 155, height: 155)
                .rotationEffect(.degrees(ringRotation))

            // Background circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [accentColor.opacity(0.15), accentColor.opacity(0.03)],
                        center: .center,
                        startRadius: 10,
                        endRadius: 70
                    )
                )
                .frame(width: 140, height: 140)

            // Icon
            Image(systemName: definition.icon)
                .font(.system(size: 60, weight: .medium))
                .foregroundStyle(
                    LinearGradient(colors: rarityGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .scaleEffect(iconScale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                iconScale = 1
            }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
            glowPulse = true
        }
    }
}

// MARK: - Detail Info Row
struct DetailInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    var isValueLocalized: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)

                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }

            Text(title.localized)
                .foregroundStyle(.secondary)

            Spacer()

            Text(isValueLocalized ? value.localized : value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Legacy Supporting Views (kept for compatibility)
struct StatItem: View {
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text(title.localized)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct CategoryButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        AchievementCategoryChip(
            title: title,
            isSelected: isSelected,
            gradient: [Color(red: 0.24, green: 0.47, blue: 0.96), Color(red: 0.42, green: 0.80, blue: 0.72)],
            action: action
        )
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var isValueLocalized: Bool = true

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            Text(title.localized)
                .foregroundStyle(.secondary)

            Spacer()

            Text(isValueLocalized ? value.localized : value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, CheckIn.self, Achievement.self, configurations: config)

    let habit1 = Habit(title: "Morning Run", icon: "figure.run", colorHex: "4CAF50")
    let habit2 = Habit(title: "Read", icon: "book.fill", colorHex: "2196F3")
    container.mainContext.insert(habit1)
    container.mainContext.insert(habit2)

    for i in 0..<15 {
        let checkIn = CheckIn(date: Date().addingTimeInterval(-Double(i) * 86400))
        checkIn.habit = habit1
        container.mainContext.insert(checkIn)
    }

    return NavigationStack {
        AchievementsView(modelContext: container.mainContext)
    }
}
