import Foundation
import SwiftData
import SwiftUI

@MainActor
class AchievementManager: ObservableObject {
    private var modelContext: ModelContext
    @Published var unlockedAchievements: [Achievement] = []
    @Published var showingUnlockAnimation: Bool = false
    @Published var recentlyUnlockedAchievement: AchievementDefinition?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadAchievements()
    }
    
    // MARK: - Load Achievements
    
    private func loadAchievements() {
        let descriptor = FetchDescriptor<Achievement>()
        do {
            unlockedAchievements = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load achievements: \(error)")
        }
    }
    
    // MARK: - Get or Create Achievement
    
    private func getOrCreateAchievement(id: String) -> Achievement {
        let predicate = #Predicate<Achievement> { achievement in
            achievement.id == id
        }
        
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            if let existing = try modelContext.fetch(descriptor).first {
                return existing
            }
        } catch {
            print("Error fetching achievement: \(error)")
        }
        
        // Create new achievement
        let newAchievement = Achievement(id: id)
        modelContext.insert(newAchievement)
        return newAchievement
    }
    
    // MARK: - Check All Achievements
    
    func checkAllAchievements(habits: [Habit], checkIns: [CheckIn]) {
        // First Steps
        checkFirstHabit(habits: habits)
        checkFirstCheckIn(checkIns: checkIns)
        checkMultipleHabits(habits: habits)
        
        // Streaks
        checkStreakAchievements(habits: habits)
        
        // Completions
        checkCompletionAchievements(checkIns: checkIns)
        
        // Consistency
        checkConsistencyAchievements(habits: habits, checkIns: checkIns)
        
        // Milestones
        checkMilestoneAchievements(habits: habits, checkIns: checkIns)
        
        // Special
        checkSpecialAchievements(habits: habits, checkIns: checkIns)
        
        // Save context
        try? modelContext.save()
        loadAchievements()
    }
    
    // MARK: - First Steps
    
    private func checkFirstHabit(habits: [Habit]) {
        guard !habits.isEmpty else { return }
        unlockAchievement(id: "first_habit", progress: habits.count)
    }
    
    private func checkFirstCheckIn(checkIns: [CheckIn]) {
        guard !checkIns.isEmpty else { return }
        unlockAchievement(id: "first_checkin", progress: checkIns.count)
    }
    
    private func checkMultipleHabits(habits: [Habit]) {
        let count = habits.count
        
        if count >= 3 {
            unlockAchievement(id: "three_habits", progress: count)
        }
        if count >= 5 {
            unlockAchievement(id: "five_habits", progress: count)
        }
        if count >= 10 {
            unlockAchievement(id: "ten_habits", progress: count)
        }
    }
    
    // MARK: - Streaks
    
    private func checkStreakAchievements(habits: [Habit]) {
        let maxStreak = habits.map { $0.currentStreak }.max() ?? 0
        let bestStreak = habits.map { $0.bestStreak }.max() ?? 0
        let streak = max(maxStreak, bestStreak)
        
        if streak >= 3 {
            unlockAchievement(id: "streak_3", progress: streak)
        }
        if streak >= 7 {
            unlockAchievement(id: "streak_7", progress: streak)
        }
        if streak >= 14 {
            unlockAchievement(id: "streak_14", progress: streak)
        }
        if streak >= 21 {
            unlockAchievement(id: "streak_21", progress: streak)
        }
        if streak >= 30 {
            unlockAchievement(id: "streak_30", progress: streak)
        }
        if streak >= 50 {
            unlockAchievement(id: "streak_50", progress: streak)
        }
        if streak >= 100 {
            unlockAchievement(id: "streak_100", progress: streak)
        }
        if streak >= 200 {
            unlockAchievement(id: "streak_200", progress: streak)
        }
        if streak >= 365 {
            unlockAchievement(id: "streak_365", progress: streak)
        }
        if streak >= 500 {
            unlockAchievement(id: "streak_500", progress: streak)
        }
    }
    
    // MARK: - Completions
    
    private func checkCompletionAchievements(checkIns: [CheckIn]) {
        let count = checkIns.count
        
        if count >= 10 {
            unlockAchievement(id: "checkins_10", progress: count)
        }
        if count >= 25 {
            unlockAchievement(id: "checkins_25", progress: count)
        }
        if count >= 50 {
            unlockAchievement(id: "checkins_50", progress: count)
        }
        if count >= 100 {
            unlockAchievement(id: "checkins_100", progress: count)
        }
        if count >= 250 {
            unlockAchievement(id: "checkins_250", progress: count)
        }
        if count >= 500 {
            unlockAchievement(id: "checkins_500", progress: count)
        }
        if count >= 1000 {
            unlockAchievement(id: "checkins_1000", progress: count)
        }
        if count >= 2000 {
            unlockAchievement(id: "checkins_2000", progress: count)
        }
        if count >= 5000 {
            unlockAchievement(id: "checkins_5000", progress: count)
        }
        if count >= 10000 {
            unlockAchievement(id: "checkins_10000", progress: count)
        }
    }
    
    // MARK: - Consistency
    
    private func checkConsistencyAchievements(habits: [Habit], checkIns: [CheckIn]) {
        let calendar = Calendar.current
        let today = Date()
        
        // Perfect Week - all habits completed for 7 days straight
        if checkPerfectWeek(habits: habits) {
            unlockAchievement(id: "perfect_week", progress: 1)
        }
        
        // Perfect Month - all habits completed for 30 days straight
        if checkPerfectMonth(habits: habits) {
            unlockAchievement(id: "perfect_month", progress: 1)
        }
        
        // Early Bird - 7 check-ins before 8 AM
        let earlyCheckIns = checkIns.filter { checkIn in
            let hour = calendar.component(.hour, from: checkIn.timestamp)
            return hour < 8
        }.count
        
        if earlyCheckIns >= 7 {
            unlockAchievement(id: "early_bird", progress: earlyCheckIns)
        }
        
        // Night Owl - 7 check-ins after 10 PM
        let lateCheckIns = checkIns.filter { checkIn in
            let hour = calendar.component(.hour, from: checkIn.timestamp)
            return hour >= 22
        }.count
        
        if lateCheckIns >= 7 {
            unlockAchievement(id: "night_owl", progress: lateCheckIns)
        }
        
        // Weekend Warrior - 10 weekends with all habits completed
        let weekendCount = countPerfectWeekends(habits: habits)
        if weekendCount >= 10 {
            unlockAchievement(id: "weekend_warrior", progress: weekendCount)
        }
        
        // All Habits in One Day
        if checkAllHabitsInOneDay(habits: habits) {
            unlockAchievement(id: "all_habits_day", progress: 1)
        }
        
        // Comeback Kid - rebuild a streak after losing it
        if checkComebackKid(habits: habits) {
            unlockAchievement(id: "comeback_kid", progress: 1)
        }
        
        // No Skip Month - complete at least one habit every day for 30 days
        if checkNoSkipMonth(checkIns: checkIns) {
            unlockAchievement(id: "no_skip_month", progress: 1)
        }
        
        // Goal Crusher - reach 10 weekly/monthly goals
        let goalsCrushed = countGoalsCrushed(habits: habits)
        if goalsCrushed >= 10 {
            unlockAchievement(id: "goal_crusher", progress: goalsCrushed)
        }
        
        // Overachiever - exceed goals by 150% for 50 times
        let overachievements = countOverachievements(habits: habits)
        if overachievements >= 50 {
            unlockAchievement(id: "overachiever", progress: overachievements)
        }
    }
    
    // MARK: - Milestones
    
    private func checkMilestoneAchievements(habits: [Habit], checkIns: [CheckIn]) {
        // Calculate days since first check-in
        guard let firstCheckIn = checkIns.min(by: { $0.date < $1.date }) else { return }
        let daysSinceStart = Calendar.current.dateComponents([.day], from: firstCheckIn.date, to: Date()).day ?? 0
        
        if daysSinceStart >= 7 {
            unlockAchievement(id: "one_week", progress: daysSinceStart)
        }
        if daysSinceStart >= 30 {
            unlockAchievement(id: "one_month", progress: daysSinceStart)
        }
        if daysSinceStart >= 90 {
            unlockAchievement(id: "three_months", progress: daysSinceStart)
        }
        if daysSinceStart >= 180 {
            unlockAchievement(id: "six_months", progress: daysSinceStart)
        }
        if daysSinceStart >= 365 {
            unlockAchievement(id: "one_year", progress: daysSinceStart)
        }
        if daysSinceStart >= 730 {
            unlockAchievement(id: "two_years", progress: daysSinceStart)
        }
        
        // Habit Master - complete at least one habit for 100 days straight
        if habits.contains(where: { $0.currentStreak >= 100 }) {
            unlockAchievement(id: "habit_master", progress: 1)
        }
        
        // Dedication - maintain 3+ active habits for 90 days
        if habits.count >= 3 && daysSinceStart >= 90 {
            unlockAchievement(id: "dedication", progress: 1)
        }
        
        // Resilient - rebuild a streak 5 times
        if countStreakRebuilds(habits: habits) >= 5 {
            unlockAchievement(id: "resilient", progress: countStreakRebuilds(habits: habits))
        }
        
        // Legendary Status - unlock 40 other achievements
        let unlockedCount = unlockedAchievements.filter { $0.unlockedAt != nil && $0.id != "legendary_status" }.count
        if unlockedCount >= 40 {
            unlockAchievement(id: "legendary_status", progress: unlockedCount)
        }
    }
    
    // MARK: - Special
    
    private func checkSpecialAchievements(habits: [Habit], checkIns: [CheckIn]) {
        let calendar = Calendar.current
        let today = Date()
        
        // New Year New Me - create a habit on Jan 1st
        if let firstHabit = habits.min(by: { $0.createdAt < $1.createdAt }) {
            let components = calendar.dateComponents([.month, .day], from: firstHabit.createdAt)
            if components.month == 1 && components.day == 1 {
                unlockAchievement(id: "new_year_new_me", progress: 1)
            }
        }
        
        // Leap Day - complete a habit on Feb 29
        let leapDayCheckIns = checkIns.filter { checkIn in
            let components = calendar.dateComponents([.month, .day], from: checkIn.date)
            return components.month == 2 && components.day == 29
        }
        if !leapDayCheckIns.isEmpty {
            unlockAchievement(id: "leap_day", progress: 1)
        }
        
        // Midnight Warrior - complete a habit at exactly midnight
        let midnightCheckIns = checkIns.filter { checkIn in
            let components = calendar.dateComponents([.hour, .minute], from: checkIn.timestamp)
            return components.hour == 0 && components.minute == 0
        }
        if !midnightCheckIns.isEmpty {
            unlockAchievement(id: "midnight_warrior", progress: 1)
        }
        
        // Multitasker - complete 5+ habits in the same day
        let maxHabitsInDay = countMaxHabitsInOneDay(checkIns: checkIns)
        if maxHabitsInDay >= 5 {
            unlockAchievement(id: "multitasker", progress: maxHabitsInDay)
        }
        
        // Speed Demon - complete 10 check-ins within 1 hour
        if checkSpeedDemon(checkIns: checkIns) {
            unlockAchievement(id: "speed_demon", progress: 10)
        }
        
        // Collector - unlock 25 achievements
        let collectedCount = unlockedAchievements.filter { $0.unlockedAt != nil }.count
        if collectedCount >= 25 {
            unlockAchievement(id: "collector", progress: collectedCount)
        }
        
        // Perfectionist - maintain 100% completion rate for 30 days
        if checkPerfectionist(habits: habits) {
            unlockAchievement(id: "perfectionist", progress: 1)
        }
        
        // Unlock All - unlock all other 49 achievements
        let allUnlockedCount = unlockedAchievements.filter { $0.unlockedAt != nil && $0.id != "unlock_all" }.count
        if allUnlockedCount >= 49 {
            unlockAchievement(id: "unlock_all", progress: 49)
        }
    }
    
    // MARK: - Helper Methods
    
    private func checkPerfectWeek(habits: [Habit]) -> Bool {
        guard !habits.isEmpty else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return false }
            
            for habit in habits {
                guard let checkIns = habit.checkIns else { return false }
                let hasCheckIn = checkIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
                if !hasCheckIn {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func checkPerfectMonth(habits: [Habit]) -> Bool {
        guard !habits.isEmpty else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return false }
            
            for habit in habits {
                guard let checkIns = habit.checkIns else { return false }
                let hasCheckIn = checkIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
                if !hasCheckIn {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func countPerfectWeekends(habits: [Habit]) -> Int {
        guard !habits.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var perfectWeekends = 0
        
        // Check last 52 weekends
        for weekOffset in 0..<52 {
            guard let saturday = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()),
                  let sunday = calendar.date(byAdding: .day, value: 1, to: saturday) else { continue }
            
            var weekendPerfect = true
            for habit in habits {
                guard let checkIns = habit.checkIns else { weekendPerfect = false; break }
                let saturdayCheck = checkIns.contains { calendar.isDate($0.date, inSameDayAs: saturday) }
                let sundayCheck = checkIns.contains { calendar.isDate($0.date, inSameDayAs: sunday) }
                if !saturdayCheck || !sundayCheck {
                    weekendPerfect = false
                    break
                }
            }
            
            if weekendPerfect {
                perfectWeekends += 1
            }
        }
        
        return perfectWeekends
    }
    
    private func checkAllHabitsInOneDay(habits: [Habit]) -> Bool {
        guard habits.count >= 3 else { return false }
        
        let calendar = Calendar.current
        
        // Check last 365 days
        for dayOffset in 0..<365 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            
            var allCompleted = true
            for habit in habits {
                guard let checkIns = habit.checkIns else { allCompleted = false; break }
                let hasCheckIn = checkIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
                if !hasCheckIn {
                    allCompleted = false
                    break
                }
            }
            
            if allCompleted {
                return true
            }
        }
        
        return false
    }
    
    private func checkComebackKid(habits: [Habit]) -> Bool {
        for habit in habits {
            if habit.currentStreak >= 7 && habit.bestStreak > habit.currentStreak + 7 {
                return true
            }
        }
        return false
    }
    
    private func checkNoSkipMonth(checkIns: [CheckIn]) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return false }
            let hasCheckIn = checkIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
            if !hasCheckIn {
                return false
            }
        }
        
        return true
    }
    
    private func countGoalsCrushed(habits: [Habit]) -> Int {
        var count = 0
        
        for habit in habits {
            if let weeklyGoal = habit.weeklyGoal, habit.weeklyProgress >= weeklyGoal {
                count += 1
            }
            if let monthlyGoal = habit.monthlyGoal, habit.monthlyProgress >= monthlyGoal {
                count += 1
            }
        }
        
        return count
    }
    
    private func countOverachievements(habits: [Habit]) -> Int {
        var count = 0
        
        for habit in habits {
            if let weeklyGoal = habit.weeklyGoal, habit.weeklyProgress >= Int(Double(weeklyGoal) * 1.5) {
                count += 1
            }
            if let monthlyGoal = habit.monthlyGoal, habit.monthlyProgress >= Int(Double(monthlyGoal) * 1.5) {
                count += 1
            }
        }
        
        return count
    }
    
    private func countStreakRebuilds(habits: [Habit]) -> Int {
        // Simplified - count habits that have rebuilt streaks
        habits.filter { $0.currentStreak >= 7 && $0.bestStreak > $0.currentStreak }.count
    }
    
    private func countMaxHabitsInOneDay(checkIns: [CheckIn]) -> Int {
        let calendar = Calendar.current
        var habitCountsByDay: [Date: Set<UUID>] = [:]
        
        for checkIn in checkIns {
            let day = calendar.startOfDay(for: checkIn.date)
            if let habitId = checkIn.habit?.id {
                habitCountsByDay[day, default: []].insert(habitId)
            }
        }
        
        return habitCountsByDay.values.map { $0.count }.max() ?? 0
    }
    
    private func checkSpeedDemon(checkIns: [CheckIn]) -> Bool {
        let sortedCheckIns = checkIns.sorted { $0.timestamp < $1.timestamp }
        
        for i in 0..<max(0, sortedCheckIns.count - 9) {
            let firstCheckIn = sortedCheckIns[i]
            let tenthCheckIn = sortedCheckIns[i + 9]
            
            let timeDifference = tenthCheckIn.timestamp.timeIntervalSince(firstCheckIn.timestamp)
            if timeDifference <= 3600 { // 1 hour
                return true
            }
        }
        
        return false
    }
    
    private func checkPerfectionist(habits: [Habit]) -> Bool {
        guard !habits.isEmpty else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return false }
            
            for habit in habits {
                guard let checkIns = habit.checkIns else { return false }
                let dayCheckIns = checkIns.filter { calendar.isDate($0.date, inSameDayAs: date) }
                
                if dayCheckIns.count < habit.dailyRepetitions {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - Unlock Achievement
    
    private func unlockAchievement(id: String, progress: Int) {
        let achievement = getOrCreateAchievement(id: id)
        
        // Update progress
        achievement.progress = progress
        
        // Check if should unlock
        guard achievement.unlockedAt == nil,
              let definition = AchievementDefinition.definition(for: id),
              progress >= definition.requirement else {
            return
        }
        
        // Unlock!
        achievement.unlockedAt = Date()
        
        // Show animation if not notified
        if !achievement.notified {
            achievement.notified = true
            showUnlockAnimation(for: definition)
        }
    }
    
    private func showUnlockAnimation(for definition: AchievementDefinition) {
        recentlyUnlockedAchievement = definition
        showingUnlockAnimation = true
        
        // Auto-hide after 3 seconds
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                showingUnlockAnimation = false
            }
        }
    }
    
    // MARK: - Get Achievement Progress
    
    func getAchievementProgress(id: String) -> Achievement? {
        return unlockedAchievements.first { $0.id == id } ?? getOrCreateAchievement(id: id)
    }
    
    func isUnlocked(id: String) -> Bool {
        return getAchievementProgress(id: id).unlockedAt != nil
    }
    
    func progressPercentage(for id: String) -> Double {
        guard let definition = AchievementDefinition.definition(for: id),
              let achievement = getAchievementProgress(id: id) else {
            return 0
        }
        
        return min(Double(achievement.progress) / Double(definition.requirement), 1.0)
    }
}
