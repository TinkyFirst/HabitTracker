import SwiftUI
import WidgetKit

// MARK: - Widget Refresh Helper
struct WidgetRefreshManager {
    /// Оновити всі віджети
    static func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Оновити конкретний віджет
    static func reloadWidget(ofKind kind: String) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind)
    }
    
    /// Оновити всі віджети з певних типів
    static func reloadHabitWidgets() {
        let widgetKinds = [
            "TodayProgressWidget",
            "HabitListWidget",
            "SingleHabitWidget",
            "InteractiveHabitListWidget"
        ]
        
        for kind in widgetKinds {
            WidgetCenter.shared.reloadTimelines(ofKind: kind)
        }
    }
}

// MARK: - Widget Deep Link Helper
struct WidgetDeepLink {
    /// Створити URL для відкриття звички
    static func habitURL(id: UUID) -> URL? {
        URL(string: "trackhabit://habit/\(id.uuidString)")
    }
    
    /// Створити URL для додавання нової звички
    static func addHabitURL() -> URL? {
        URL(string: "trackhabit://addhabit")
    }
    
    /// Створити URL для відкриття головного екрана
    static func todayURL() -> URL? {
        URL(string: "trackhabit://today")
    }
    
    /// Створити URL для відкриття статистики
    static func insightsURL() -> URL? {
        URL(string: "trackhabit://insights")
    }
}
