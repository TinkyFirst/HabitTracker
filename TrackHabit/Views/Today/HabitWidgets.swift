import SwiftUI
import SwiftUI
import WidgetKit
import SwiftData

// MARK: - Today Progress Widget (Small)
struct TodayProgressWidget: Widget {
    let kind: String = "TodayProgressWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            TodayProgressWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Today's Progress")
        .description("See your daily habit completion progress")
        .supportedFamilies([.systemSmall])
    }
}

struct TodayProgressWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: entry.progressPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: entry.progressPercentage)
                
                VStack(spacing: 4) {
                    Text("\(entry.completedCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("з \(entry.totalCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 95, height: 95)
            
            Spacer()
            
            // Status text
            Text(statusText)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
    
    private var statusText: String {
        let percentage = Int(entry.progressPercentage * 100)
        if percentage == 100 {
            return "Чудова робота! 🎉"
        } else if percentage >= 75 {
            return "Майже готово!"
        } else if percentage >= 50 {
            return "Продовжуй!"
        } else if percentage > 0 {
            return "Гарний початок!"
        } else {
            return "Розпочни день!"
        }
    }
}

// MARK: - Habit List Widget (Medium)
struct HabitListWidget: Widget {
    let kind: String = "HabitListWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            HabitListWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Habit List")
        .description("Quick view of your habits")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct HabitListWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var displayHabits: [HabitSnapshot] {
        switch family {
        case .systemMedium:
            return Array(entry.habits.prefix(4))
        case .systemLarge:
            return Array(entry.habits.prefix(9))
        default:
            return entry.habits
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Compact Header
            HStack(spacing: 8) {
                Text(greetingText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Compact progress indicator
                HStack(spacing: 4) {
                    Text("\(entry.completedCount)/\(entry.totalCount)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 3)
                        
                        Circle()
                            .trim(from: 0, to: entry.progressPercentage)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Habit list
            if entry.habits.isEmpty {
                Spacer()
                VStack(spacing: 10) {
                    Text("🎯")
                        .font(.system(size: 36))
                    Text("Додайте свою першу звичку")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    
                    Link(destination: URL(string: "trackhabit://addhabit")!) {
                        Text("Додати звичку")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                VStack(spacing: 6) {
                    ForEach(displayHabits) { habit in
                        Link(destination: URL(string: "trackhabit://habit/\(habit.id.uuidString)")!) {
                            HabitRowWidget(habit: habit)
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.bottom, 8)
                
                Spacer(minLength: 0)
            }
        }
        .background(Color(uiColor: .systemBackground))
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Доброго ранку"
        case 12..<17: return "Доброго дня"
        default: return "Доброго вечора"
        }
    }
}

// MARK: - Single Habit Widget (Small/Medium)
struct SingleHabitWidget: Widget {
    let kind: String = "SingleHabitWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            SingleHabitWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Favorite Habit")
        .description("Track your most important habit")
        .supportedFamilies([.systemSmall])
    }
}

struct SingleHabitWidgetView: View {
    let entry: HabitWidgetEntry
    
    var firstHabit: HabitSnapshot? {
        entry.habits.first
    }
    
    var body: some View {
        if let habit = firstHabit {
            Link(destination: URL(string: "trackhabit://habit/\(habit.id.uuidString)")!) {
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Icon with colored background
                    ZStack {
                        Circle()
                            .fill(Color(hex: habit.colorHex).opacity(0.2))
                            .frame(width: 70, height: 70)
                        
                        Text(habit.icon)
                            .font(.system(size: 35))
                    }
                    
                    Spacer().frame(height: 12)
                    
                    // Title
                    Text(habit.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer().frame(height: 8)
                    
                    // Status badge
                    HStack(spacing: 5) {
                        Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 12))
                            .foregroundColor(habit.isCompletedToday ? .green : .secondary)
                        
                        Text(habit.isCompletedToday ? "Виконано" : "Не виконано")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(habit.isCompletedToday ? .green : .secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(habit.isCompletedToday ? Color.green.opacity(0.15) : Color.secondary.opacity(0.1))
                    )
                    
                    // Streak
                    if habit.currentStreak > 0 {
                        Spacer().frame(height: 8)
                        
                        HStack(spacing: 3) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                            Text("\(habit.currentStreak) \(habit.currentStreak == 1 ? "день" : "днів")")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: .systemBackground))
            }
        } else {
            Link(destination: URL(string: "trackhabit://addhabit")!) {
                VStack(spacing: 12) {
                    Text("🎯")
                        .font(.system(size: 45))
                    
                    Text("Додати\nзвичку")
                        .font(.system(size: 13, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: .systemBackground))
            }
        }
    }
}

// MARK: - Habit Row Widget
struct HabitRowWidget: View {
    let habit: HabitSnapshot
    
    var body: some View {
        HStack(spacing: 10) {
            // Icon
            Text(habit.icon)
                .font(.system(size: 18))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color(hex: habit.colorHex).opacity(0.15))
                )
            
            // Title and streak
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if habit.currentStreak > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.orange)
                        Text("\(habit.currentStreak) \(habit.currentStreak == 1 ? "день" : "днів")")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer(minLength: 0)
            
            // Status (як в онбордингу)
            ZStack {
                // Background circle (сірий)
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 28, height: 28)
                
                // Border circle
                Circle()
                    .stroke(
                        habit.isCompletedToday ? Color.blue : Color.white.opacity(0.3),
                        lineWidth: 2
                    )
                    .frame(width: 28, height: 28)
                
                // Checkmark (тільки коли виконано)
                if habit.isCompletedToday {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    TodayProgressWidget()
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

#Preview(as: .systemMedium) {
    HabitListWidget()
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
