import Foundation
import SwiftData

// MARK: - Shared Model Container
class SharedModelContainer {
    static let shared = SharedModelContainer()
    
    let container: ModelContainer
    
    private init() {
        let schema = Schema([
            Habit.self,
            CheckIn.self
        ])
        
        // Use App Group for sharing data with widgets
        // Make sure this matches your App Group ID in Signing & Capabilities
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.trackhabit")
        )
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
