import SwiftUI
import WidgetKit
import SwiftData

// MARK: - Widget Entry
struct HabitWidgetEntry: TimelineEntry {
    let date: Date
    let habits: [HabitSnapshot]
    let completedCount: Int
    let totalCount: Int
    
    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}

// MARK: - Habit Snapshot
struct HabitSnapshot: Identifiable, Codable {
    let id: UUID
    let title: String
    let icon: String
    let colorHex: String
    let isCompletedToday: Bool
    let currentStreak: Int
}

// MARK: - Timeline Provider
struct HabitWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> HabitWidgetEntry {
        HabitWidgetEntry(
            date: Date(),
            habits: placeholderHabits(),
            completedCount: 2,
            totalCount: 4
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HabitWidgetEntry) -> Void) {
        let entry = HabitWidgetEntry(
            date: Date(),
            habits: placeholderHabits(),
            completedCount: 2,
            totalCount: 4
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitWidgetEntry>) -> Void) {
        Task {
            let habits = await fetchHabits()
            let completedCount = habits.filter { $0.isCompletedToday }.count
            let totalCount = habits.count
            
            let entry = HabitWidgetEntry(
                date: Date(),
                habits: habits,
                completedCount: completedCount,
                totalCount: totalCount
            )
            
            // Update every 15 minutes
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    private func fetchHabits(selectedIds: [UUID]? = nil) async -> [HabitSnapshot] {
        do {
            // IMPORTANT: Use SharedModelContainer to access the same data as the app
            let modelContainer = SharedModelContainer.shared.container
            let context = ModelContext(modelContainer)
            
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { !$0.isArchived },
                sortBy: [SortDescriptor(\Habit.sortOrder)]
            )
            
            var habits = try context.fetch(descriptor)
            
            // Фільтруємо по вибраним звичкам, якщо вони є
            if let selectedIds = selectedIds, !selectedIds.isEmpty {
                habits = habits.filter { selectedIds.contains($0.id) }
            }
            
            return habits.map { habit in
                HabitSnapshot(
                    id: habit.id,
                    title: habit.title,
                    icon: habit.icon,
                    colorHex: habit.colorHex,
                    isCompletedToday: habit.isCompletedToday,
                    currentStreak: habit.currentStreak
                )
            }
        } catch {
            print("Error fetching habits for widget: \(error)")
            return []
        }
    }
    
    private func placeholderHabits() -> [HabitSnapshot] {
        [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: true, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2),
            HabitSnapshot(id: UUID(), title: "Journal", icon: "📝", colorHex: "#F39C12", isCompletedToday: false, currentStreak: 7)
        ]
    }
}
// MARK: - Intent Timeline Provider
struct HabitWidgetIntentProvider: AppIntentTimelineProvider {
    typealias Entry = HabitWidgetEntry
    typealias Intent = HabitWidgetConfigurationIntent
    
    func placeholder(in context: Context) -> HabitWidgetEntry {
        HabitWidgetEntry(
            date: Date(),
            habits: placeholderHabits(),
            completedCount: 2,
            totalCount: 4
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> HabitWidgetEntry {
        let habits = await fetchHabits(selectedIds: configuration.selectedHabits.map { $0.id })
        let completedCount = habits.filter { $0.isCompletedToday }.count
        
        return HabitWidgetEntry(
            date: Date(),
            habits: habits,
            completedCount: completedCount,
            totalCount: habits.count
        )
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<HabitWidgetEntry> {
        let habits = await fetchHabits(selectedIds: configuration.selectedHabits.map { $0.id })
        let completedCount = habits.filter { $0.isCompletedToday }.count
        
        let entry = HabitWidgetEntry(
            date: Date(),
            habits: habits,
            completedCount: completedCount,
            totalCount: habits.count
        )
        
        // Update every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    private func fetchHabits(selectedIds: [UUID]) async -> [HabitSnapshot] {
        do {
            let modelContainer = SharedModelContainer.shared.container
            let context = ModelContext(modelContainer)
            
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { !$0.isArchived },
                sortBy: [SortDescriptor(\Habit.sortOrder)]
            )
            
            var habits = try context.fetch(descriptor)
            
            // Фільтруємо по вибраним звичкам, якщо вони є
            if !selectedIds.isEmpty {
                // Зберігаємо порядок вибраних звичок
                habits = selectedIds.compactMap { id in
                    habits.first(where: { $0.id == id })
                }
            }
            
            return habits.map { habit in
                HabitSnapshot(
                    id: habit.id,
                    title: habit.title,
                    icon: habit.icon,
                    colorHex: habit.colorHex,
                    isCompletedToday: habit.isCompletedToday,
                    currentStreak: habit.currentStreak
                )
            }
        } catch {
            print("Error fetching habits for widget: \(error)")
            return []
        }
    }
    
    private func placeholderHabits() -> [HabitSnapshot] {
        [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: true, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2),
            HabitSnapshot(id: UUID(), title: "Journal", icon: "📝", colorHex: "#F39C12", isCompletedToday: false, currentStreak: 7)
        ]
    }
}

