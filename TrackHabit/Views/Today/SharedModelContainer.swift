import Foundation
import SwiftData

// MARK: - Shared Model Container
class SharedModelContainer {
    static let shared = SharedModelContainer()
    
    let container: ModelContainer
    
    private init() {
        let schema = Schema([
            Habit.self,
            CheckIn.self,
            Achievement.self
        ])
        let localConfig = ModelConfiguration(schema: schema, cloudKitDatabase: .none)
        
        do {
            // Force a local-only store; the app's iCloud entitlements should not
            // implicitly turn this SwiftData container into a CloudKit-backed store.
            container = try ModelContainer(for: schema, configurations: [localConfig])
            print("✅ ModelContainer created successfully")
        } catch {
            print("❌ Failed to create ModelContainer")
            print("Error: \(error)")
            print("Error localized: \(error.localizedDescription)")
            
            // Try in-memory as last resort
            do {
                let config = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true,
                    cloudKitDatabase: .none
                )
                container = try ModelContainer(for: schema, configurations: [config])
                print("⚠️ Using in-memory storage (data will not persist)")
            } catch {
                fatalError("Could not create ModelContainer even with in-memory storage: \(error)")
            }
        }
    }
}
