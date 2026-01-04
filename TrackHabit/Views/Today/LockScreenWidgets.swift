import SwiftUI
import SwiftUI
import WidgetKit
import SwiftData

// MARK: - Lock Screen Widget
struct LockScreenProgressWidget: Widget {
    let kind: String = "LockScreenProgressWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            LockScreenProgressWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Habit Progress")
        .description("Your daily progress at a glance")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Circular Lock Screen View
struct LockScreenProgressWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        case .accessoryInline:
            inlineView
        default:
            circularView
        }
    }
    
    private var circularView: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            Gauge(value: entry.progressPercentage, in: 0...1) {
                Image(systemName: "checkmark.circle")
            } currentValueLabel: {
                Text("\(entry.completedCount)")
                    .font(.system(size: 20, weight: .bold))
            }
            .gaugeStyle(.accessoryCircular)
        }
    }
    
    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                Text("Habits Today")
                    .font(.headline)
            }
            
            HStack {
                Text("\(entry.completedCount) of \(entry.totalCount)")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Gauge(value: entry.progressPercentage, in: 0...1) {
                    EmptyView()
                }
                .gaugeStyle(.accessoryLinearCapacity)
                .tint(.blue)
                .frame(width: 40)
            }
            
            Text("\(Int(entry.progressPercentage * 100))% complete")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private var inlineView: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
            Text("\(entry.completedCount)/\(entry.totalCount) habits")
        }
    }
}

// MARK: - Lock Screen Habit Counter Widget
struct LockScreenHabitCounterWidget: Widget {
    let kind: String = "LockScreenHabitCounterWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            LockScreenHabitCounterView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Habit Counter")
        .description("Count of completed habits")
        .supportedFamilies([.accessoryCircular])
    }
}

struct LockScreenHabitCounterView: View {
    let entry: HabitWidgetEntry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            VStack(spacing: 0) {
                Text("\(entry.completedCount)")
                    .font(.system(size: 28, weight: .bold))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text("done")
                    .font(.system(size: 10, weight: .medium))
                    .textCase(.uppercase)
            }
        }
    }
}

// MARK: - Lock Screen Streak Widget
struct LockScreenStreakWidget: Widget {
    let kind: String = "LockScreenStreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            LockScreenStreakView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Best Streak")
        .description("Your longest streak")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

struct LockScreenStreakView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var longestStreak: Int {
        entry.habits.map { $0.currentStreak }.max() ?? 0
    }
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            circularStreakView
        case .accessoryRectangular:
            rectangularStreakView
        default:
            circularStreakView
        }
    }
    
    private var circularStreakView: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            VStack(spacing: 2) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
                
                Text("\(longestStreak)")
                    .font(.system(size: 16, weight: .bold))
                    .minimumScaleFactor(0.5)
            }
        }
    }
    
    private var rectangularStreakView: some View {
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Best Streak")
                    .font(.headline)
                Text("\(longestStreak) days")
                    .font(.system(size: 24, weight: .bold))
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview(as: .accessoryCircular) {
    LockScreenProgressWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: true, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2)
        ],
        completedCount: 2,
        totalCount: 3
    )
}

#Preview(as: .accessoryRectangular) {
    LockScreenProgressWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: true, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2)
        ],
        completedCount: 2,
        totalCount: 3
    )
}

#Preview(as: .accessoryInline) {
    LockScreenProgressWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: true, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2)
        ],
        completedCount: 2,
        totalCount: 3
    )
}
