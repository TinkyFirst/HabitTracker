import SwiftData
import Foundation

/// Shared model container for the app and widgets
/// Використовує App Group для обміну даними між додатком та віджетами
/// Підтримує синхронізацію через iCloud CloudKit
@MainActor
final class SharedModelContainer {
    static let shared = SharedModelContainer()
    
    let container: ModelContainer
    
    private init() {
        // ВАЖЛИВО: Замініть на вашу реальну App Group
        let appGroupIdentifier = "group.com.trackhabit.shared"
        
        let schema = Schema([
            Habit.self,
            CheckIn.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            // Вказуємо розташування бази даних в App Group
            url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)?
                .appendingPathComponent("TrackHabit.sqlite"),
            // УВІМКНЕННЯ CLOUDKIT СИНХРОНІЗАЦІЇ
            cloudKitDatabase: .automatic // Автоматична синхронізація через iCloud
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            print("✅ SharedModelContainer initialized successfully")
            print("📍 Database location: \(modelConfiguration.url?.path ?? "unknown")")
            print("☁️ CloudKit sync: enabled")
        } catch {
            fatalError("❌ Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    /// Основний контекст для використання в додатку
    var mainContext: ModelContext {
        container.mainContext
    }
    
    /// Створення нового фонового контексту для фонових операцій
    func newBackgroundContext() -> ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = false
        return context
    }
}
