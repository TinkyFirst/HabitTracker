import SwiftUI
import SwiftData

// MARK: - Achievement Badge for Settings
struct AchievementBadge: View {
    @Query private var achievements: [Achievement]
    
    private var unlockedCount: Int {
        achievements.filter { $0.unlockedAt != nil }.count
    }
    
    private var totalCount: Int {
        AchievementDefinition.allAchievements.count
    }
    
    init(modelContext: ModelContext) {
        // No special initialization needed
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text("\(unlockedCount)/\(totalCount)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Image(systemName: "trophy.fill")
                .font(.caption2)
                .foregroundStyle(.orange)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.orange.opacity(0.15))
        )
    }
}

// MARK: - Achievement Quick Preview (for Today View)
struct AchievementQuickView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var achievementManager: AchievementManager
    
    @Query private var habits: [Habit]
    @Query private var checkIns: [CheckIn]
    
    @State private var recentAchievements: [AchievementDefinition] = []
    
    init(modelContext: ModelContext) {
        _achievementManager = StateObject(wrappedValue: AchievementManager(modelContext: modelContext))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.orange)
                
                Text("achievements.title")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink {
                    AchievementsView(modelContext: modelContext)
                } label: {
                    Text("achievements.viewAll")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            
            // Recent achievements
            if recentAchievements.isEmpty {
                Text("achievements.keepGoing")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(recentAchievements.prefix(3)) { definition in
                            CompactAchievementCard(
                                definition: definition,
                                achievement: achievementManager.getAchievementProgress(id: definition.id)
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .onAppear {
            loadRecentAchievements()
        }
    }
    
    private func loadRecentAchievements() {
        let unlocked = achievementManager.unlockedAchievements
            .filter { $0.unlockedAt != nil }
            .sorted { ($0.unlockedAt ?? Date.distantPast) > ($1.unlockedAt ?? Date.distantPast) }
        
        recentAchievements = unlocked.compactMap { achievement in
            AchievementDefinition.definition(for: achievement.id)
        }
    }
}

// MARK: - Compact Achievement Card
struct CompactAchievementCard: View {
    let definition: AchievementDefinition
    let achievement: Achievement?
    
    private var isUnlocked: Bool {
        achievement?.unlockedAt != nil
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: definition.color).opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: definition.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(Color(hex: definition.color))
            }
            
            // Title
            Text(LocalizedStringKey(definition.titleKey))
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
        .frame(width: 100)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: definition.color).opacity(0.1))
        )
    }
}
