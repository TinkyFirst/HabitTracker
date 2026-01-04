import SwiftUI
import SwiftData

// MARK: - Habit Goals Feature

@Model
final class HabitGoal {
    var id: UUID
    var habitId: UUID
    var targetDays: Int
    var startDate: Date
    var endDate: Date
    var isCompleted: Bool
    var createdAt: Date
    
    init(habitId: UUID, targetDays: Int, startDate: Date = Date()) {
        self.id = UUID()
        self.habitId = habitId
        self.targetDays = targetDays
        self.startDate = startDate
        self.endDate = Calendar.current.date(byAdding: .day, value: targetDays, to: startDate) ?? startDate
        self.isCompleted = false
        self.createdAt = Date()
    }
}

// MARK: - Habit Categories
enum HabitCategory: String, Codable, CaseIterable {
    case health = "Health"
    case fitness = "Fitness"
    case mindfulness = "Mindfulness"
    case productivity = "Productivity"
    case learning = "Learning"
    case social = "Social"
    case creativity = "Creativity"
    case finance = "Finance"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .fitness: return "figure.run"
        case .mindfulness: return "brain.head.profile"
        case .productivity: return "checkmark.circle.fill"
        case .learning: return "book.fill"
        case .social: return "person.2.fill"
        case .creativity: return "paintbrush.fill"
        case .finance: return "dollarsign.circle.fill"
        case .other: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .health: return .red
        case .fitness: return .green
        case .mindfulness: return .purple
        case .productivity: return .blue
        case .learning: return .orange
        case .social: return .pink
        case .creativity: return .yellow
        case .finance: return .teal
        case .other: return .gray
        }
    }
}

// MARK: - Goal Setting View
struct GoalSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let habit: Habit
    
    @State private var selectedDays = 30
    @State private var startDate = Date()
    
    let dayOptions = [7, 14, 21, 30, 60, 90, 100, 365]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Duration") {
                    Picker("Days", selection: $selectedDays) {
                        ForEach(dayOptions, id: \.self) { days in
                            Text("\(days) days").tag(days)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section("Start Date") {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Goal Summary")
                            .font(.headline)
                        
                        HStack {
                            Text(habit.icon)
                                .font(.title2)
                            Text(habit.title)
                                .font(.body)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Target:")
                            Spacer()
                            Text("\(selectedDays) consecutive days")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("End Date:")
                            Spacer()
                            Text(endDate, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Set Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createGoal()
                    }
                }
            }
        }
    }
    
    private var endDate: Date {
        Calendar.current.date(byAdding: .day, value: selectedDays, to: startDate) ?? startDate
    }
    
    private func createGoal() {
        let goal = HabitGoal(habitId: habit.id, targetDays: selectedDays, startDate: startDate)
        modelContext.insert(goal)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Category Filter View
struct CategoryFilterView: View {
    @Binding var selectedCategory: HabitCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChipView(
                    category: nil,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    CategoryChipView(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChipView: View {
    let category: HabitCategory?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let category = category {
                    Image(systemName: category.icon)
                        .font(.caption)
                    Text(category.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                } else {
                    Text("All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? (category?.color ?? .blue) : Color.secondary.opacity(0.15))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Actions Menu
struct QuickActionsMenu: View {
    let habit: Habit
    @State private var showingGoalSheet = false
    @State private var showingShareSheet = false
    
    var body: some View {
        Menu {
            Button {
                showingGoalSheet = true
            } label: {
                Label("Set Goal", systemImage: "target")
            }
            
            Button {
                // Edit habit
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button {
                showingShareSheet = true
            } label: {
                Label("Share Progress", systemImage: "square.and.arrow.up")
            }
            
            Divider()
            
            Button(role: .destructive) {
                // Archive habit
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showingGoalSheet) {
            GoalSettingView(habit: habit)
        }
    }
}

// MARK: - Habit Notes Feature
@Model
final class HabitNote {
    var id: UUID
    var habitId: UUID
    var content: String
    var date: Date
    
    init(habitId: UUID, content: String) {
        self.id = UUID()
        self.habitId = habitId
        self.content = content
        self.date = Date()
    }
}

struct HabitNotesView: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [HabitNote]
    @State private var newNote = ""
    @State private var showingAddNote = false
    
    init(habit: Habit) {
        self.habit = habit
        let habitId = habit.id
        _notes = Query(
            filter: #Predicate<HabitNote> { note in
                note.habitId == habitId
            },
            sort: \HabitNote.date,
            order: .reverse
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notes")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    showingAddNote = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            if notes.isEmpty {
                Text("No notes yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(notes) { note in
                    NoteCard(note: note)
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteSheet(habit: habit)
        }
    }
}

struct NoteCard: View {
    let note: HabitNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.content)
                .font(.body)
            
            Text(note.date, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}

struct AddNoteSheet: View {
    let habit: Habit
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var noteText = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Add a note about your habit")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $noteText)
                    .frame(height: 150)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    )
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        let note = HabitNote(habitId: habit.id, content: noteText)
        modelContext.insert(note)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Habit Sharing
struct ShareProgressView: View {
    let habit: Habit
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Progress Card
                VStack(spacing: 16) {
                    Text(habit.icon)
                        .font(.system(size: 60))
                    
                    Text(habit.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 32) {
                        VStack(spacing: 8) {
                            Text("\(habit.currentStreak)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.orange)
                            Text("Day Streak")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(habit.checkIns?.count ?? 0)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.green)
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(hex: habit.colorHex).opacity(0.1))
                )
                
                // Share Button
                Button {
                    shareProgress()
                } label: {
                    Label("Share Progress", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func shareProgress() {
        let text = """
        🎯 I'm building my \(habit.title) habit!
        🔥 Current streak: \(habit.currentStreak) days
        ✅ Total completions: \(habit.checkIns?.count ?? 0)
        
        #HabitTracker #ConsistencyIsKey
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryFilterView(selectedCategory: .constant(nil))
}
