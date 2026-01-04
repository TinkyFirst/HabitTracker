import Foundation
import SwiftData

@Model
final class CheckIn {
    var id: UUID
    var date: Date
    var timestamp: Date
    var source: String // "manual", "widget", "shortcut"

    var habit: Habit?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        timestamp: Date = Date(),
        source: String = "manual"
    ) {
        self.id = id
        self.date = date
        self.timestamp = timestamp
        self.source = source
    }
}
