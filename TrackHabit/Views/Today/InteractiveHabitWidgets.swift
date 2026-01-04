import SwiftUI
import WidgetKit
import AppIntents
import SwiftData

// MARK: - Widget Configuration Intent
struct HabitWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Налаштування віджета"
    static var description: IntentDescription = IntentDescription("Оберіть звички для відображення")
    
    @Parameter(title: "Вибрати звички", default: [])
    var selectedHabits: [HabitEntity]
}

// MARK: - Habit Entity для вибору
struct HabitEntity: AppEntity {
    var id: UUID
    var title: String
    var icon: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Звичка"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(icon) \(title)")
    }
    
    static var defaultQuery = HabitEntityQuery()
}

// MARK: - Query для звичок
struct HabitEntityQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [HabitEntity] {
        let allHabits = await fetchAllHabits()
        return allHabits.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [HabitEntity] {
        return await fetchAllHabits()
    }
    
    func defaultResult() async -> HabitEntity? {
        let habits = await fetchAllHabits()
        return habits.first
    }
    
    private func fetchAllHabits() async -> [HabitEntity] {
        do {
            let modelContainer = SharedModelContainer.shared.container
            let context = ModelContext(modelContainer)
            
            let descriptor = FetchDescriptor<Habit>(
                predicate: #Predicate { !$0.isArchived },
                sortBy: [SortDescriptor(\Habit.sortOrder)]
            )
            
            let habits = try context.fetch(descriptor)
            
            return habits.map { habit in
                HabitEntity(id: habit.id, title: habit.title, icon: habit.icon)
            }
        } catch {
            print("Error fetching habits for widget configuration: \(error)")
            return []
        }
    }
}

// MARK: - Widget Category Intent
struct SelectCategoryIntent: AppIntent {
    static var title: LocalizedStringResource = "Select Category"
    
    @Parameter(title: "Category")
    var category: String
    
    init(category: String) {
        self.category = category
    }
    
    init() {
        self.category = "all"
    }
    
    func perform() async throws -> some IntentResult {
        // Store selected category in UserDefaults (shared with widget)
        if let defaults = UserDefaults(suiteName: "group.com.yourapp.trackhabit") {
            defaults.set(category, forKey: "selectedWidgetCategory")
        }
        return .result()
    }
}

// MARK: - Interactive Habit List Widget
struct InteractiveHabitListWidget: Widget {
    let kind: String = "InteractiveHabitListWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: HabitWidgetConfigurationIntent.self,
            provider: HabitWidgetIntentProvider()
        ) { entry in
            InteractiveHabitListWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Список звичок")
        .description("Швидко відмічайте виконані звички")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

struct InteractiveHabitListWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    var displayHabits: [HabitSnapshot] {
        switch family {
        case .systemMedium:
            return Array(entry.habits.prefix(4))
        case .systemLarge:
            return Array(entry.habits.prefix(8))
        default:
            return entry.habits
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Habit list
            if entry.habits.isEmpty {
                Spacer()
                VStack(spacing: 4) {
                    Text("🎯")
                        .font(.system(size: 20))
                    Text("Додайте звичку")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Link(destination: URL(string: "trackhabit://addhabit")!) {
                        Text("Додати")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
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
                if family == .systemMedium {
                    adaptiveMediumLayout
                } else {
                    VStack(spacing: 2) {
                        ForEach(displayHabits) { habit in
                            InteractiveHabitRowWidget(habit: habit, isCompact: false, colorScheme: colorScheme)
                        }
                    }
                    .padding(6)
                }
                
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var adaptiveMediumLayout: some View {
        VStack(spacing: 2) {
            let habitCount = displayHabits.count
            
            if habitCount == 1 {
                InteractiveHabitRowWidget(habit: displayHabits[0], isCompact: false, colorScheme: colorScheme)
            } else if habitCount == 2 {
                ForEach(displayHabits) { habit in
                    InteractiveHabitRowWidget(habit: habit, isCompact: false, colorScheme: colorScheme)
                }
            } else {
                let rows = stride(from: 0, to: habitCount, by: 2).map { index in
                    Array(displayHabits[index..<min(index + 2, habitCount)])
                }
                
                ForEach(0..<rows.count, id: \.self) { rowIndex in
                    HStack(spacing: 2) {
                        ForEach(rows[rowIndex]) { habit in
                            InteractiveHabitRowWidget(habit: habit, isCompact: true, colorScheme: colorScheme)
                        }
                    }
                }
            }
        }
        .padding(10)
    }
}

// MARK: - Interactive Habit Row Widget
struct InteractiveHabitRowWidget: View {
    let habit: HabitSnapshot
    var isCompact: Bool = false
    let colorScheme: ColorScheme
    
    var body: some View {
        Button(intent: ToggleHabitIntent(habitId: habit.id.uuidString)) {
            if isCompact {
                compactLayout
            } else {
                fullLayout
            }
        }
        .buttonStyle(.plain)
    }
    
    // Простий layout для сітки - тільки emoji і назва
    private var compactLayout: some View {
        VStack(spacing: 3) {
            // Icon
            Text(habit.icon)
                .font(.system(size: 36))
            
            // Title
            Text(habit.title)
                .font(.system(size: 10, weight: habit.isCompletedToday ? .bold : .medium))
                .foregroundColor(habit.isCompletedToday ? Color(hex: habit.colorHex) : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    habit.isCompletedToday
                        ? Color(hex: habit.colorHex).opacity(colorScheme == .dark ? 0.2 : 0.12)
                        : (colorScheme == .dark 
                            ? Color.white.opacity(0.06) 
                            : Color.white.opacity(0.4))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    habit.isCompletedToday 
                        ? Color(hex: habit.colorHex).opacity(0.6)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
    }
    
    // Простий layout для списку - emoji, назва і streak
    private var fullLayout: some View {
        HStack(spacing: 6) {
            // Icon
            Text(habit.icon)
                .font(.system(size: 28))
            
            // Title
            Text(habit.title)
                .font(.system(size: 12, weight: habit.isCompletedToday ? .bold : .medium))
                .foregroundColor(habit.isCompletedToday ? Color(hex: habit.colorHex) : .primary)
                .lineLimit(1)
            
            Spacer(minLength: 0)
            
            // Тільки streak число
            if habit.currentStreak > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                    Text("\(habit.currentStreak)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    habit.isCompletedToday
                        ? Color(hex: habit.colorHex).opacity(colorScheme == .dark ? 0.2 : 0.12)
                        : (colorScheme == .dark 
                            ? Color.white.opacity(0.06) 
                            : Color.white.opacity(0.4))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    habit.isCompletedToday 
                        ? Color(hex: habit.colorHex).opacity(0.6)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
    }
    
    private func streakText(_ count: Int) -> String {
        switch count {
        case 1: return "день"
        case 2...4: return "дні"
        default: return "днів"
        }
    }
}

// MARK: - Preview
#Preview("Medium - 2 звички", as: .systemMedium) {
    InteractiveHabitListWidget()
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

#Preview("Medium - 4 звички (Grid)", as: .systemMedium) {
    InteractiveHabitListWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: false, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2),
            HabitSnapshot(id: UUID(), title: "Water", icon: "💧", colorHex: "#1ABC9C", isCompletedToday: true, currentStreak: 12)
        ],
        completedCount: 2,
        totalCount: 4
    )
}

#Preview("Large - 6 звичок", as: .systemLarge) {
    InteractiveHabitListWidget()
} timeline: {
    HabitWidgetEntry(
        date: Date(),
        habits: [
            HabitSnapshot(id: UUID(), title: "Meditate", icon: "🧘", colorHex: "#9B59B6", isCompletedToday: true, currentStreak: 5),
            HabitSnapshot(id: UUID(), title: "Read", icon: "📚", colorHex: "#4A90E2", isCompletedToday: false, currentStreak: 3),
            HabitSnapshot(id: UUID(), title: "Exercise", icon: "💪", colorHex: "#50C878", isCompletedToday: false, currentStreak: 2),
            HabitSnapshot(id: UUID(), title: "Journal", icon: "📝", colorHex: "#F39C12", isCompletedToday: false, currentStreak: 7),
            HabitSnapshot(id: UUID(), title: "Water", icon: "💧", colorHex: "#1ABC9C", isCompletedToday: true, currentStreak: 12),
            HabitSnapshot(id: UUID(), title: "Walk", icon: "🚶", colorHex: "#50C878", isCompletedToday: false, currentStreak: 4)
        ],
        completedCount: 2,
        totalCount: 6
    )
}
