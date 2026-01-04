import WidgetKit
import SwiftUI

@main
struct HabitWidgets: WidgetBundle {
    var body: some Widget {
        // Тільки інтерактивний список звичок
        InteractiveHabitListWidget()
    }
}
