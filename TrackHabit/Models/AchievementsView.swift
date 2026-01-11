import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var achievementManager: AchievementManager
    
    @Query private var habits: [Habit]
    @Query private var checkIns: [CheckIn]
    
    @State private var selectedCategory: AchievementDefinition.AchievementCategory?
    @State private var showingDetail: AchievementDefinition?
    
    init(modelContext: ModelContext) {
        _achievementManager = StateObject(wrappedValue: AchievementManager(modelContext: modelContext))
    }
    
    private var categories: [AchievementDefinition.AchievementCategory] {
        AchievementDefinition.AchievementCategory.allCases
    }
    
    private var filteredAchievements: [AchievementDefinition] {
        if let category = selectedCategory {
            return AchievementDefinition.allAchievements.filter { $0.category == category }
        }
        return AchievementDefinition.allAchievements
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with stats
                headerSection
                
                // Category filter
                categoryFilter
                
                // Achievements grid
                achievementsGrid
            }
            .padding()
        }
        .navigationTitle("achievements.title")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            achievementManager.checkAllAchievements(habits: habits, checkIns: checkIns)
        }
        .sheet(item: $showingDetail) { definition in
            achievementDetailSheet(for: definition)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: completionPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1, dampingFraction: 0.8), value: completionPercentage)
                
                VStack(spacing: 4) {
                    Text("\(unlockedCount)")
                        .font(.system(size: 32, weight: .bold))
                    Text("achievements.of")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(totalCount)")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            
            // Stats
            HStack(spacing: 32) {
                StatItem(
                    title: "achievements.common",
                    value: countByRarity(.common),
                    color: .gray
                )
                StatItem(
                    title: "achievements.rare",
                    value: countByRarity(.rare),
                    color: .blue
                )
                StatItem(
                    title: "achievements.legendary",
                    value: countByRarity(.legendary),
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All category
                CategoryButton(
                    title: "achievements.category.all",
                    isSelected: selectedCategory == nil
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedCategory = nil
                    }
                }
                
                // Individual categories
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var achievementsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 16
        ) {
            ForEach(filteredAchievements) { definition in
                Button {
                    showingDetail = definition
                } label: {
                    AchievementCardView(
                        definition: definition,
                        achievement: achievementManager.getAchievementProgress(id: definition.id),
                        compact: false
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func achievementDetailSheet(for definition: AchievementDefinition) -> some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Large icon
                    ZStack {
                        Circle()
                            .fill(Color(hex: definition.color).opacity(0.2))
                            .frame(width: 150, height: 150)
                        
                        Image(systemName: definition.icon)
                            .font(.system(size: 70))
                            .foregroundStyle(Color(hex: definition.color))
                    }
                    .padding(.top, 32)
                    
                    // Title and description
                    VStack(spacing: 8) {
                        Text(LocalizedStringKey(definition.titleKey))
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(LocalizedStringKey(definition.descriptionKey))
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    // Progress
                    if let achievement = achievementManager.getAchievementProgress(id: definition.id) {
                        VStack(spacing: 12) {
                            if let unlockedAt = achievement.unlockedAt {
                                // Unlocked info
                                VStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.green)
                                    
                                    Text("achievements.unlocked_on")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(formatDate(unlockedAt))
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.green.opacity(0.1))
                                )
                            } else {
                                // Progress bar
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("achievements.progress")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        
                                        Text("\(achievement.progress)/\(definition.requirement)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                            
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: definition.color))
                                                .frame(
                                                    width: geometry.size.width * min(Double(achievement.progress) / Double(definition.requirement), 1.0)
                                                )
                                                .animation(.spring(response: 0.6), value: achievement.progress)
                                        }
                                    }
                                    .frame(height: 12)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Details
                    VStack(spacing: 16) {
                        DetailRow(
                            icon: "tag.fill",
                            title: "achievements.category",
                            value: LocalizedStringKey(definition.category.rawValue)
                        )
                        
                        DetailRow(
                            icon: "star.fill",
                            title: "achievements.rarity",
                            value: rarityText(definition.rarity)
                        )
                        
                        DetailRow(
                            icon: "target",
                            title: "achievements.requirement",
                            value: "\(definition.requirement)"
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("achievements.done") {
                        showingDetail = nil
                    }
                }
            }
        }
    }
    
    private func countByRarity(_ rarity: AchievementDefinition.AchievementRarity) -> Int {
        let unlockedIds = Set(achievementManager.unlockedAchievements.compactMap { $0.unlockedAt != nil ? $0.id : nil })
        return AchievementDefinition.allAchievements.filter {
            $0.rarity == rarity && unlockedIds.contains($0.id)
        }.count
    }
    
    private func rarityText(_ rarity: AchievementDefinition.AchievementRarity) -> LocalizedStringKey {
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
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let title: LocalizedStringKey
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct CategoryButton: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color(.systemGray5))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: LocalizedStringKey
    let value: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, CheckIn.self, Achievement.self, configurations: config)
    
    // Add sample data
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
