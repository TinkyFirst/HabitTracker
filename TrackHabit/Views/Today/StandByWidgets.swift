import SwiftUI
import SwiftUI
import WidgetKit
import SwiftData

// MARK: - StandBy Widget
struct StandByHabitWidget: Widget {
    let kind: String = "StandByHabitWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            StandByHabitWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Habits StandBy")
        .description("View your habits in StandBy mode")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct StandByHabitWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var displayHabits: [HabitSnapshot] {
        switch family {
        case .systemMedium:
            return Array(entry.habits.prefix(2))
        case .systemLarge:
            return Array(entry.habits.prefix(4))
        default:
            return entry.habits
        }
    }
    
    var body: some View {
        ZStack {
            // Background - більш контрастний для StandBy
            if renderingMode == .vibrant {
                Color.clear
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            VStack(spacing: 16) {
                // Header з великим текстом для StandBy
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greetingText)
                            .font(.system(size: 28, weight: .bold))
                        
                        Text(formattedDate)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Великий прогрес кільця
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 6)
                        
                        Circle()
                            .trim(from: 0, to: entry.progressPercentage)
                            .stroke(
                                Color.blue,
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Text("\(entry.completedCount)")
                                .font(.system(size: 24, weight: .bold))
                            Text("/\(entry.totalCount)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 70, height: 70)
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                // Список звичок з великими іконками
                if entry.habits.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("🎯")
                            .font(.system(size: 60))
                        Text("Add your first habit")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                } else {
                    VStack(spacing: 12) {
                        ForEach(displayHabits) { habit in
                            StandByHabitRow(habit: habit)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

struct StandByHabitRow: View {
    let habit: HabitSnapshot
    
    var body: some View {
        HStack(spacing: 16) {
            // Велика іконка
            Text(habit.icon)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color(hex: habit.colorHex).opacity(0.3))
                )
            
            // Інформація про звичку
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                if habit.currentStreak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Text("\(habit.currentStreak) day streak")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Статус з великим чекмарком
            ZStack {
                Circle()
                    .fill(habit.isCompletedToday ? Color(hex: habit.colorHex) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                if habit.isCompletedToday {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - StandBy Compact Widget
struct StandByCompactWidget: Widget {
    let kind: String = "StandByCompactWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            StandByCompactView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Progress Only")
        .description("Simple progress view for StandBy")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct StandByCompactView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.4),
                    Color.purple.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                // Великий прогрес кільця
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 10)
                    
                    Circle()
                        .trim(from: 0, to: entry.progressPercentage)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 4) {
                        Text("\(entry.completedCount)")
                            .font(.system(size: family == .systemSmall ? 40 : 50, weight: .bold))
                        Text("of \(entry.totalCount)")
                            .font(family == .systemSmall ? .headline : .title3)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: family == .systemSmall ? 100 : 120, maxHeight: family == .systemSmall ? 100 : 120)
                
                if family == .systemMedium {
                    VStack(spacing: 4) {
                        Text("\(Int(entry.progressPercentage * 100))%")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Complete")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    StandByHabitWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: false, currentStreak: 3)
        ],
        completedCount: 1,
        totalCount: 2
    )
}

#Preview(as: .systemLarge) {
    StandByHabitWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: false, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2),
            HabitSnapshot(id: UUID(), title: "Journal", icon: "📝", colorHex: "#F39C12", isCompletedToday: true, currentStreak: 7)
        ],
        completedCount: 2,
        totalCount: 4
    )
}
