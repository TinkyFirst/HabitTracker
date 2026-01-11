import Foundation
import SwiftData

@Model
final class Achievement {
    var id: String // Unique identifier (e.g., "first_checkin", "streak_7")
    var unlockedAt: Date?
    var progress: Int // Current progress towards achievement
    var notified: Bool // Whether user was notified about unlock
    
    init(id: String, progress: Int = 0) {
        self.id = id
        self.progress = progress
        self.unlockedAt = nil
        self.notified = false
    }
}

// MARK: - Achievement Definition
struct AchievementDefinition: Identifiable {
    let id: String
    let titleKey: String
    let descriptionKey: String
    let icon: String
    let color: String // Hex color
    let category: AchievementCategory
    let requirement: Int
    let rarity: AchievementRarity
    
    enum AchievementCategory: String, CaseIterable {
        case streaks = "achievement.category.streaks"
        case completions = "achievement.category.completions"
        case habits = "achievement.category.habits"
        case consistency = "achievement.category.consistency"
        case milestones = "achievement.category.milestones"
        case special = "achievement.category.special"
    }
    
    enum AchievementRarity: Int {
        case common = 1
        case uncommon = 2
        case rare = 3
        case epic = 4
        case legendary = 5
    }
}

// MARK: - All Achievements
extension AchievementDefinition {
    static let allAchievements: [AchievementDefinition] = [
        // MARK: - First Steps (5)
        AchievementDefinition(
            id: "first_habit",
            titleKey: "achievement.first_habit.title",
            descriptionKey: "achievement.first_habit.description",
            icon: "star.fill",
            color: "FFD700",
            category: .habits,
            requirement: 1,
            rarity: .common
        ),
        AchievementDefinition(
            id: "first_checkin",
            titleKey: "achievement.first_checkin.title",
            descriptionKey: "achievement.first_checkin.description",
            icon: "checkmark.circle.fill",
            color: "4CAF50",
            category: .completions,
            requirement: 1,
            rarity: .common
        ),
        AchievementDefinition(
            id: "three_habits",
            titleKey: "achievement.three_habits.title",
            descriptionKey: "achievement.three_habits.description",
            icon: "3.circle.fill",
            color: "2196F3",
            category: .habits,
            requirement: 3,
            rarity: .common
        ),
        AchievementDefinition(
            id: "five_habits",
            titleKey: "achievement.five_habits.title",
            descriptionKey: "achievement.five_habits.description",
            icon: "5.circle.fill",
            color: "9C27B0",
            category: .habits,
            requirement: 5,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "ten_habits",
            titleKey: "achievement.ten_habits.title",
            descriptionKey: "achievement.ten_habits.description",
            icon: "sparkles",
            color: "FF9800",
            category: .habits,
            requirement: 10,
            rarity: .rare
        ),
        
        // MARK: - Streaks (10)
        AchievementDefinition(
            id: "streak_3",
            titleKey: "achievement.streak_3.title",
            descriptionKey: "achievement.streak_3.description",
            icon: "flame.fill",
            color: "FF5722",
            category: .streaks,
            requirement: 3,
            rarity: .common
        ),
        AchievementDefinition(
            id: "streak_7",
            titleKey: "achievement.streak_7.title",
            descriptionKey: "achievement.streak_7.description",
            icon: "flame.fill",
            color: "FF6F00",
            category: .streaks,
            requirement: 7,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "streak_14",
            titleKey: "achievement.streak_14.title",
            descriptionKey: "achievement.streak_14.description",
            icon: "flame.fill",
            color: "E65100",
            category: .streaks,
            requirement: 14,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "streak_21",
            titleKey: "achievement.streak_21.title",
            descriptionKey: "achievement.streak_21.description",
            icon: "flame.fill",
            color: "D84315",
            category: .streaks,
            requirement: 21,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "streak_30",
            titleKey: "achievement.streak_30.title",
            descriptionKey: "achievement.streak_30.description",
            icon: "flame.fill",
            color: "BF360C",
            category: .streaks,
            requirement: 30,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "streak_50",
            titleKey: "achievement.streak_50.title",
            descriptionKey: "achievement.streak_50.description",
            icon: "flame.fill",
            color: "FF1744",
            category: .streaks,
            requirement: 50,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "streak_100",
            titleKey: "achievement.streak_100.title",
            descriptionKey: "achievement.streak_100.description",
            icon: "flame.fill",
            color: "C51162",
            category: .streaks,
            requirement: 100,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "streak_200",
            titleKey: "achievement.streak_200.title",
            descriptionKey: "achievement.streak_200.description",
            icon: "sparkles",
            color: "AA00FF",
            category: .streaks,
            requirement: 200,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "streak_365",
            titleKey: "achievement.streak_365.title",
            descriptionKey: "achievement.streak_365.description",
            icon: "crown.fill",
            color: "FFD700",
            category: .streaks,
            requirement: 365,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "streak_500",
            titleKey: "achievement.streak_500.title",
            descriptionKey: "achievement.streak_500.description",
            icon: "crown.fill",
            color: "FFB300",
            category: .streaks,
            requirement: 500,
            rarity: .legendary
        ),
        
        // MARK: - Completions (10)
        AchievementDefinition(
            id: "checkins_10",
            titleKey: "achievement.checkins_10.title",
            descriptionKey: "achievement.checkins_10.description",
            icon: "checkmark.seal.fill",
            color: "4CAF50",
            category: .completions,
            requirement: 10,
            rarity: .common
        ),
        AchievementDefinition(
            id: "checkins_25",
            titleKey: "achievement.checkins_25.title",
            descriptionKey: "achievement.checkins_25.description",
            icon: "checkmark.seal.fill",
            color: "43A047",
            category: .completions,
            requirement: 25,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "checkins_50",
            titleKey: "achievement.checkins_50.title",
            descriptionKey: "achievement.checkins_50.description",
            icon: "checkmark.seal.fill",
            color: "388E3C",
            category: .completions,
            requirement: 50,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "checkins_100",
            titleKey: "achievement.checkins_100.title",
            descriptionKey: "achievement.checkins_100.description",
            icon: "checkmark.seal.fill",
            color: "2E7D32",
            category: .completions,
            requirement: 100,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "checkins_250",
            titleKey: "achievement.checkins_250.title",
            descriptionKey: "achievement.checkins_250.description",
            icon: "checkmark.seal.fill",
            color: "1B5E20",
            category: .completions,
            requirement: 250,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "checkins_500",
            titleKey: "achievement.checkins_500.title",
            descriptionKey: "achievement.checkins_500.description",
            icon: "rosette",
            color: "00C853",
            category: .completions,
            requirement: 500,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "checkins_1000",
            titleKey: "achievement.checkins_1000.title",
            descriptionKey: "achievement.checkins_1000.description",
            icon: "rosette",
            color: "00BFA5",
            category: .completions,
            requirement: 1000,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "checkins_2000",
            titleKey: "achievement.checkins_2000.title",
            descriptionKey: "achievement.checkins_2000.description",
            icon: "medal.fill",
            color: "00897B",
            category: .completions,
            requirement: 2000,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "checkins_5000",
            titleKey: "achievement.checkins_5000.title",
            descriptionKey: "achievement.checkins_5000.description",
            icon: "trophy.fill",
            color: "FFD700",
            category: .completions,
            requirement: 5000,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "checkins_10000",
            titleKey: "achievement.checkins_10000.title",
            descriptionKey: "achievement.checkins_10000.description",
            icon: "trophy.fill",
            color: "FFA000",
            category: .completions,
            requirement: 10000,
            rarity: .legendary
        ),
        
        // MARK: - Consistency (10)
        AchievementDefinition(
            id: "perfect_week",
            titleKey: "achievement.perfect_week.title",
            descriptionKey: "achievement.perfect_week.description",
            icon: "calendar.badge.checkmark",
            color: "2196F3",
            category: .consistency,
            requirement: 1,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "perfect_month",
            titleKey: "achievement.perfect_month.title",
            descriptionKey: "achievement.perfect_month.description",
            icon: "calendar.badge.checkmark",
            color: "1976D2",
            category: .consistency,
            requirement: 1,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "early_bird",
            titleKey: "achievement.early_bird.title",
            descriptionKey: "achievement.early_bird.description",
            icon: "sunrise.fill",
            color: "FFA726",
            category: .consistency,
            requirement: 7,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "night_owl",
            titleKey: "achievement.night_owl.title",
            descriptionKey: "achievement.night_owl.description",
            icon: "moon.stars.fill",
            color: "5C6BC0",
            category: .consistency,
            requirement: 7,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "weekend_warrior",
            titleKey: "achievement.weekend_warrior.title",
            descriptionKey: "achievement.weekend_warrior.description",
            icon: "sun.max.fill",
            color: "FF9800",
            category: .consistency,
            requirement: 10,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "all_habits_day",
            titleKey: "achievement.all_habits_day.title",
            descriptionKey: "achievement.all_habits_day.description",
            icon: "star.circle.fill",
            color: "FFD700",
            category: .consistency,
            requirement: 1,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "comeback_kid",
            titleKey: "achievement.comeback_kid.title",
            descriptionKey: "achievement.comeback_kid.description",
            icon: "arrow.uturn.forward.circle.fill",
            color: "9C27B0",
            category: .consistency,
            requirement: 1,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "no_skip_month",
            titleKey: "achievement.no_skip_month.title",
            descriptionKey: "achievement.no_skip_month.description",
            icon: "checkmark.circle.trianglebadge.exclamationmark",
            color: "4CAF50",
            category: .consistency,
            requirement: 1,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "goal_crusher",
            titleKey: "achievement.goal_crusher.title",
            descriptionKey: "achievement.goal_crusher.description",
            icon: "target",
            color: "E91E63",
            category: .consistency,
            requirement: 10,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "overachiever",
            titleKey: "achievement.overachiever.title",
            descriptionKey: "achievement.overachiever.description",
            icon: "chart.line.uptrend.xyaxis",
            color: "00BCD4",
            category: .consistency,
            requirement: 50,
            rarity: .epic
        ),
        
        // MARK: - Milestones (10)
        AchievementDefinition(
            id: "one_week",
            titleKey: "achievement.one_week.title",
            descriptionKey: "achievement.one_week.description",
            icon: "7.circle.fill",
            color: "03A9F4",
            category: .milestones,
            requirement: 7,
            rarity: .common
        ),
        AchievementDefinition(
            id: "one_month",
            titleKey: "achievement.one_month.title",
            descriptionKey: "achievement.one_month.description",
            icon: "30.circle.fill",
            color: "0288D1",
            category: .milestones,
            requirement: 30,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "three_months",
            titleKey: "achievement.three_months.title",
            descriptionKey: "achievement.three_months.description",
            icon: "90.circle.fill",
            color: "0277BD",
            category: .milestones,
            requirement: 90,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "six_months",
            titleKey: "achievement.six_months.title",
            descriptionKey: "achievement.six_months.description",
            icon: "calendar.badge.clock",
            color: "01579B",
            category: .milestones,
            requirement: 180,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "one_year",
            titleKey: "achievement.one_year.title",
            descriptionKey: "achievement.one_year.description",
            icon: "calendar.circle.fill",
            color: "FFD700",
            category: .milestones,
            requirement: 365,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "two_years",
            titleKey: "achievement.two_years.title",
            descriptionKey: "achievement.two_years.description",
            icon: "hourglass.circle.fill",
            color: "FFC107",
            category: .milestones,
            requirement: 730,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "habit_master",
            titleKey: "achievement.habit_master.title",
            descriptionKey: "achievement.habit_master.description",
            icon: "graduationcap.fill",
            color: "9C27B0",
            category: .milestones,
            requirement: 1,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "dedication",
            titleKey: "achievement.dedication.title",
            descriptionKey: "achievement.dedication.description",
            icon: "heart.fill",
            color: "E91E63",
            category: .milestones,
            requirement: 1,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "resilient",
            titleKey: "achievement.resilient.title",
            descriptionKey: "achievement.resilient.description",
            icon: "shield.fill",
            color: "607D8B",
            category: .milestones,
            requirement: 1,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "legendary_status",
            titleKey: "achievement.legendary_status.title",
            descriptionKey: "achievement.legendary_status.description",
            icon: "crown.fill",
            color: "FFD700",
            category: .milestones,
            requirement: 1,
            rarity: .legendary
        ),
        
        // MARK: - Special (10)
        AchievementDefinition(
            id: "new_year_new_me",
            titleKey: "achievement.new_year_new_me.title",
            descriptionKey: "achievement.new_year_new_me.description",
            icon: "sparkles",
            color: "FFD700",
            category: .special,
            requirement: 1,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "birthday_celebration",
            titleKey: "achievement.birthday_celebration.title",
            descriptionKey: "achievement.birthday_celebration.description",
            icon: "birthday.cake.fill",
            color: "FF69B4",
            category: .special,
            requirement: 1,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "leap_day",
            titleKey: "achievement.leap_day.title",
            descriptionKey: "achievement.leap_day.description",
            icon: "calendar.badge.exclamationmark",
            color: "00BCD4",
            category: .special,
            requirement: 1,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "midnight_warrior",
            titleKey: "achievement.midnight_warrior.title",
            descriptionKey: "achievement.midnight_warrior.description",
            icon: "moon.fill",
            color: "3F51B5",
            category: .special,
            requirement: 1,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "multitasker",
            titleKey: "achievement.multitasker.title",
            descriptionKey: "achievement.multitasker.description",
            icon: "square.grid.2x2.fill",
            color: "FF5722",
            category: .special,
            requirement: 5,
            rarity: .rare
        ),
        AchievementDefinition(
            id: "speed_demon",
            titleKey: "achievement.speed_demon.title",
            descriptionKey: "achievement.speed_demon.description",
            icon: "hare.fill",
            color: "FF9800",
            category: .special,
            requirement: 10,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "social_butterfly",
            titleKey: "achievement.social_butterfly.title",
            descriptionKey: "achievement.social_butterfly.description",
            icon: "person.2.fill",
            color: "E91E63",
            category: .special,
            requirement: 1,
            rarity: .uncommon
        ),
        AchievementDefinition(
            id: "collector",
            titleKey: "achievement.collector.title",
            descriptionKey: "achievement.collector.description",
            icon: "square.stack.3d.up.fill",
            color: "9C27B0",
            category: .special,
            requirement: 25,
            rarity: .epic
        ),
        AchievementDefinition(
            id: "perfectionist",
            titleKey: "achievement.perfectionist.title",
            descriptionKey: "achievement.perfectionist.description",
            icon: "sparkle.magnifyingglass",
            color: "00BCD4",
            category: .special,
            requirement: 1,
            rarity: .legendary
        ),
        AchievementDefinition(
            id: "unlock_all",
            titleKey: "achievement.unlock_all.title",
            descriptionKey: "achievement.unlock_all.description",
            icon: "trophy.fill",
            color: "FFD700",
            category: .special,
            requirement: 49,
            rarity: .legendary
        ),
    ]
    
    static func definition(for id: String) -> AchievementDefinition? {
        allAchievements.first { $0.id == id }
    }
}
