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

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }

    init(modelContext: ModelContext) {}

    var body: some View {
        HStack(spacing: 6) {
            // Mini progress ring
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.15), lineWidth: 2)
                    .frame(width: 18, height: 18)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.orange, Color(hex: "EF4444")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 18, height: 18)
                    .rotationEffect(.degrees(-90))

                Image(systemName: "trophy.fill")
                    .font(.system(size: 7))
                    .foregroundStyle(.orange)
            }

            Text("\(unlockedCount)/\(totalCount)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.orange.opacity(0.08))
                .overlay(
                    Capsule()
                        .stroke(Color.orange.opacity(0.12), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Achievement Quick Preview (for Today View)
struct AchievementQuickView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var achievementManager: AchievementManager

    @Query private var habits: [Habit]
    @Query private var checkIns: [CheckIn]

    @State private var recentAchievements: [AchievementDefinition] = []
    @State private var appeared = false

    init(modelContext: ModelContext) {
        _achievementManager = StateObject(wrappedValue: AchievementManager(modelContext: modelContext))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.15), Color(hex: "EF4444").opacity(0.10)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 30, height: 30)

                        Image(systemName: "trophy.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, Color(hex: "EF4444")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }

                    Text("achievements.title".localized)
                        .font(.headline)
                }

                Spacer()

                NavigationLink {
                    AchievementsView(modelContext: modelContext)
                } label: {
                    HStack(spacing: 4) {
                        Text("achievements.viewAll".localized)
                            .font(.caption)
                            .fontWeight(.medium)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundStyle(.blue)
                }
            }

            // Recent achievements
            if recentAchievements.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundStyle(.tertiary)

                    Text("achievements.keepGoing".localized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(recentAchievements.prefix(4).enumerated()), id: \.element.id) { index, definition in
                            CompactAchievementCard(
                                definition: definition,
                                achievement: achievementManager.getAchievementProgress(id: definition.id)
                            )
                            .opacity(appeared ? 1 : 0)
                            .offset(x: appeared ? 0 : 20)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(index) * 0.08),
                                value: appeared
                            )
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    colorScheme == .dark
                        ? Color(red: 0.10, green: 0.12, blue: 0.16)
                        : Color.white.opacity(0.85)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 12, y: 4)
        )
        .onAppear {
            loadRecentAchievements()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2)) {
                appeared = true
            }
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
    @Environment(\.colorScheme) private var colorScheme
    let definition: AchievementDefinition
    let achievement: Achievement?

    @State private var iconScale: CGFloat = 0.7

    private var isUnlocked: Bool {
        achievement?.unlockedAt != nil
    }

    private var cardColor: Color {
        Color(hex: definition.color)
    }

    private var rarityGradient: [Color] {
        switch definition.rarity {
        case .common: return [cardColor, cardColor.opacity(0.7)]
        case .uncommon: return [cardColor, cardColor.opacity(0.8)]
        case .rare: return [cardColor, Color(hex: "6C63FF")]
        case .epic: return [Color(hex: "8B5CF6"), Color(hex: "EC4899")]
        case .legendary: return [Color(hex: "F59E0B"), Color(hex: "EF4444")]
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Icon with glow
            ZStack {
                // Subtle glow for unlocked
                if isUnlocked {
                    Circle()
                        .fill(cardColor.opacity(0.12))
                        .frame(width: 68, height: 68)
                        .blur(radius: 6)
                }

                // Background
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                cardColor.opacity(isUnlocked ? 0.20 : 0.08),
                                cardColor.opacity(isUnlocked ? 0.06 : 0.02)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 56, height: 56)

                // Border ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: isUnlocked ? rarityGradient : [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 56, height: 56)

                // Icon
                Image(systemName: definition.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(
                        isUnlocked
                        ? AnyShapeStyle(
                            LinearGradient(colors: rarityGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        : AnyShapeStyle(Color.gray.opacity(0.4))
                    )
                    .scaleEffect(iconScale)
            }

            // Title
            Text(definition.titleKey.localized)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(isUnlocked ? .primary : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
        .frame(width: 100)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    colorScheme == .dark
                        ? Color(red: 0.12, green: 0.14, blue: 0.18)
                        : Color.white.opacity(0.6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isUnlocked
                                ? cardColor.opacity(0.20)
                                : (colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.04)),
                            lineWidth: 1
                        )
                )
                .shadow(color: cardColor.opacity(isUnlocked ? 0.10 : 0), radius: 8, y: 3)
        )
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1)) {
                iconScale = 1
            }
        }
    }
}
