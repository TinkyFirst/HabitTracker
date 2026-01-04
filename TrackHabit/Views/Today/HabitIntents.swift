import AppIntents
import AppIntents
import SwiftData
import WidgetKit

// MARK: - Custom Error
enum HabitIntentError: Error, CustomLocalizedStringResourceConvertible {
    case invalidHabitId
    case habitNotFound
    case failedToToggle(String)
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidHabitId:
            return "Invalid habit ID"
        case .habitNotFound:
            return "Habit not found"
        case .failedToToggle(let message):
            return "Failed to toggle habit: \(message)"
        }
    }
}

// MARK: - Toggle Habit Intent
struct ToggleHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Habit"
    static var description: IntentDescription = IntentDescription("Mark habit as complete or incomplete")
    
    @Parameter(title: "Habit ID")
    var habitId: String
    
    init() {}
    
    init(habitId: String) {
        self.habitId = habitId
    }
    
    func perform() async throws -> some IntentResult {
        guard let uuid = UUID(uuidString: habitId) else {
            throw HabitIntentError.invalidHabitId
        }
        
        do {
            // IMPORTANT: Use SharedModelContainer for data consistency
            let modelContainer = SharedModelContainer.shared.container
            let context = ModelContext(modelContainer)
            
            // Fetch the habit
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { $0.id == uuid }
            )
            
            guard let habit = try context.fetch(descriptor).first else {
                throw HabitIntentError.habitNotFound
            }
            
            // Toggle completion
            if habit.isCompletedToday {
                // Remove today's check-in
                if let checkIn = habit.checkIns?.first(where: {
                    Calendar.current.isDate($0.date, inSameDayAs: Date())
                }) {
                    context.delete(checkIn)
                }
            } else {
                // Add check-in
                let checkIn = CheckIn(source: "widget")
                checkIn.habit = habit
                context.insert(checkIn)
            }
            
            try context.save()
            
            // Refresh all widgets
            WidgetCenter.shared.reloadAllTimelines()
            
            return .result()
        } catch let error as HabitIntentError {
            throw error
        } catch {
            throw HabitIntentError.failedToToggle(error.localizedDescription)
        }
    }
}

