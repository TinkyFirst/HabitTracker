import Foundation
import SwiftData
import SwiftUI

final class AchievementManagerNew: ObservableObject {
    static var shared: AchievementManagerNew?
    
    private var modelContext: ModelContext
    
    @Published var showingUnlockAnimation: Bool = false
    @Published var recentlyUnlockedAchievement: AchievementDefinition?
    @Published var isFirstAchievement: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        if AchievementManagerNew.shared == nil {
            AchievementManagerNew.shared = self
        }
    }
    
    // MARK: - Main Check Function
    
    func checkAllAchievements(habits: [Habit], checkIns: [CheckIn]) {
        print("\n🎯 ========== CHECKING ALL ACHIEVEMENTS ==========")
        print("   📊 Input: \(habits.count) habits, \(checkIns.count) check-ins")
        
        // First Steps
        updateAchievement(id: "first_habit", progress: habits.count, requirement: 1)
        updateAchievement(id: "first_checkin", progress: checkIns.count, requirement: 1)
        updateAchievement(id: "three_habits", progress: habits.count, requirement: 3)
        updateAchievement(id: "five_habits", progress: habits.count, requirement: 5)
        updateAchievement(id: "ten_habits", progress: habits.count, requirement: 10)
        
        // Streaks
        let maxStreak = habits.map { max($0.currentStreak, $0.bestStreak) }.max() ?? 0
        updateAchievement(id: "streak_3", progress: maxStreak, requirement: 3)
        updateAchievement(id: "streak_7", progress: maxStreak, requirement: 7)
        updateAchievement(id: "streak_14", progress: maxStreak, requirement: 14)
        updateAchievement(id: "streak_21", progress: maxStreak, requirement: 21)
        updateAchievement(id: "streak_30", progress: maxStreak, requirement: 30)
        updateAchievement(id: "streak_50", progress: maxStreak, requirement: 50)
        updateAchievement(id: "streak_100", progress: maxStreak, requirement: 100)
        updateAchievement(id: "streak_200", progress: maxStreak, requirement: 200)
        updateAchievement(id: "streak_365", progress: maxStreak, requirement: 365)
        updateAchievement(id: "streak_500", progress: maxStreak, requirement: 500)
        
        // Completions
        updateAchievement(id: "checkins_10", progress: checkIns.count, requirement: 10)
        updateAchievement(id: "checkins_25", progress: checkIns.count, requirement: 25)
        updateAchievement(id: "checkins_50", progress: checkIns.count, requirement: 50)
        updateAchievement(id: "checkins_100", progress: checkIns.count, requirement: 100)
        updateAchievement(id: "checkins_250", progress: checkIns.count, requirement: 250)
        updateAchievement(id: "checkins_500", progress: checkIns.count, requirement: 500)
        updateAchievement(id: "checkins_1000", progress: checkIns.count, requirement: 1000)
        updateAchievement(id: "checkins_2000", progress: checkIns.count, requirement: 2000)
        updateAchievement(id: "checkins_5000", progress: checkIns.count, requirement: 5000)
        updateAchievement(id: "checkins_10000", progress: checkIns.count, requirement: 10000)
        
        print("   ✅ Done checking!")
        print("   📊 Total unlocked: \(getUnlockedCount())/\(AchievementDefinition.allAchievements.count)")
        print("================================================\n")
        
        // Notify UI
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("AchievementsUpdated"), object: nil)
        }
    }
    
    // MARK: - Core Update Function
    
    private func updateAchievement(id: String, progress: Int, requirement: Int) {
        let predicate = #Predicate<Achievement> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        
        var achievement: Achievement
        
        do {
            if let existing = try modelContext.fetch(descriptor).first {
                achievement = existing
            } else {
                achievement = Achievement(id: id, progress: progress)
                modelContext.insert(achievement)
                print("   ➕ Created '\(id)' = \(progress)/\(requirement)")
            }
        } catch {
            print("   ❌ Error fetching '\(id)': \(error)")
            return
        }
        
        // Update progress
        if achievement.progress != progress {
            print("   📈 '\(id)': \(achievement.progress) → \(progress)/\(requirement)")
            achievement.progress = progress
        }
        
        // Check unlock
        if achievement.unlockedAt == nil && progress >= requirement {
            achievement.unlockedAt = Date()
            achievement.notified = false
            print("   🏆 UNLOCKED '\(id)'!")
            
            if let definition = AchievementDefinition.definition(for: id) {
                showUnlockAnimation(for: definition)
            }
        }
        
        // Save
        do {
            try modelContext.save()
        } catch {
            print("   ❌ Save error '\(id)': \(error)")
        }
    }
    
    // MARK: - Helper
    
    private func getUnlockedCount() -> Int {
        let descriptor = FetchDescriptor<Achievement>()
        do {
            return try modelContext.fetch(descriptor).filter { $0.unlockedAt != nil }.count
        } catch {
            return 0
        }
    }
    
    private func showUnlockAnimation(for definition: AchievementDefinition) {
        let isFirst = getUnlockedCount() == 1
        
        DispatchQueue.main.async { [weak self] in
            self?.isFirstAchievement = isFirst
            self?.recentlyUnlockedAchievement = definition
            self?.showingUnlockAnimation = true
        }
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: isFirst ? 4_000_000_000 : 3_000_000_000)
            self.showingUnlockAnimation = false
            try? await Task.sleep(nanoseconds: 500_000_000)
            self.recentlyUnlockedAchievement = nil
        }
    }
}
