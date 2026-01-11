import SwiftUI
import SwiftData

struct GoalsMenuView: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    
    @State private var weeklyGoal: Int?
    @State private var monthlyGoal: Int?
    @State private var yearlyGoal: Int?
    @State private var hasGoals: Bool = false
    
    init(habit: Habit) {
        self.habit = habit
        _weeklyGoal = State(initialValue: habit.weeklyGoal)
        _monthlyGoal = State(initialValue: habit.monthlyGoal)
        _yearlyGoal = State(initialValue: habit.yearlyGoal)
        _hasGoals = State(initialValue: habit.weeklyGoal != nil || habit.monthlyGoal != nil || habit.yearlyGoal != nil)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main content card
                    VStack(spacing: 0) {
                        // Header
                        headerSection
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 20)
                        
                        // Goals list
                        goalsListSection
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(white: colorScheme == .dark ? 0.15 : 0.95))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("goals.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("edit.optional".localized) {
                        // Optional badge - non-interactive
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .disabled(true)
                }
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            Text("goals.setYourGoals".localized)
                .font(.title3)
                .fontWeight(.regular)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if hasGoals {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        removeAllGoals()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                        Text("edit.removeAll".localized)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Goals List Section
    
    private var goalsListSection: some View {
        VStack(spacing: 20) {
            // Weekly Goal
            GoalRow(
                icon: "📅",
                iconColor: .blue,
                title: "goals.weeklyGoal".localized,
                value: $weeklyGoal,
                description: "edit.daysPerWeek".localized,
                defaultValue: 7,
                onRemove: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        weeklyGoal = nil
                        updateHasGoals()
                        saveChanges()
                    }
                }
            )
            
            // Monthly Goal
            GoalRow(
                icon: "📅",
                iconColor: .purple,
                title: "goals.monthlyGoal".localized,
                value: $monthlyGoal,
                description: "edit.daysPerMonth".localized,
                defaultValue: 30,
                onRemove: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        monthlyGoal = nil
                        updateHasGoals()
                        saveChanges()
                    }
                }
            )
            
            // Yearly Goal
            GoalRow(
                icon: "📅",
                iconColor: .green,
                title: "goals.yearlyGoal".localized,
                value: $yearlyGoal,
                description: "edit.daysPerYear".localized,
                defaultValue: 365,
                onRemove: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        yearlyGoal = nil
                        updateHasGoals()
                        saveChanges()
                    }
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func removeAllGoals() {
        weeklyGoal = nil
        monthlyGoal = nil
        yearlyGoal = nil
        updateHasGoals()
        saveChanges()
    }
    
    private func updateHasGoals() {
        hasGoals = weeklyGoal != nil || monthlyGoal != nil || yearlyGoal != nil
    }
    
    private func saveChanges() {
        habit.weeklyGoal = weeklyGoal
        habit.monthlyGoal = monthlyGoal
        habit.yearlyGoal = yearlyGoal
        
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()
    }
}

// MARK: - Goal Row Component

struct GoalRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var value: Int?
    let description: String
    let defaultValue: Int
    let onRemove: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Title with icon
            HStack(spacing: 10) {
                // Icon with badge
                ZStack(alignment: .bottomTrailing) {
                    Text(icon)
                        .font(.system(size: 28))
                    
                    Circle()
                        .fill(iconColor)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 2, y: 2)
                }
                .frame(width: 36, height: 36)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.bottom, 12)
            
            // Value input section
            HStack(spacing: 0) {
                // Value button/input
                Button {
                    if value == nil {
                        value = defaultValue
                    }
                    isFocused = true
                } label: {
                    HStack(spacing: 12) {
                        Text("\(value ?? defaultValue)")
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(minWidth: 60, alignment: .center)
                        
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Remove button
                if value != nil {
                    Button {
                        onRemove()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .frame(width: 44, height: 44)
                    }
                    .padding(.leading, 8)
                }
            }
        }
        .onChange(of: isFocused) { _, newValue in
            if !newValue && value == nil {
                // If user unfocused without setting a value, don't enable the goal
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    let context = container.mainContext
    
    let habit = Habit(
        title: "Drink Water",
        icon: "💧",
        colorHex: "#0096FF",
        reminderEnabled: false,
        sortOrder: 0
    )
    context.insert(habit)
    
    return GoalsMenuView(habit: habit)
        .modelContainer(container)
}
