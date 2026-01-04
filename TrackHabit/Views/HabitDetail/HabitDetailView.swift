import SwiftUI
import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    var shouldShowEditOnAppear: Bool = false
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var selectedMonth = Date()

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    // Header
                    headerSection

                    // Stats
                    statsSection

                    // Calendar
                    calendarSection
                    
                    // Goals
                    goalsSection

                    // Settings
                    settingsSection

                    // Delete button
                    deleteButton
                }
                .padding(AppTheme.spacingL)
            }
        }
        .navigationTitle(habit.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("habit.edit".localized) {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditHabitView(habit: habit)
        }
        .alert("habit.delete".localized, isPresented: $showingDeleteAlert) {
            Button("common.cancel".localized, role: .cancel) { }
            Button("common.delete".localized, role: .destructive) {
                deleteHabit()
            }
        } message: {
            Text("habit.deleteConfirm".localized)
        }
        .onAppear {
            if shouldShowEditOnAppear {
                // Small delay to ensure view is fully presented
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showingEditSheet = true
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                Color(hex: habit.colorHex).opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var headerSection: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                Text(habit.icon)
                    .font(.system(size: 60))
                    .frame(width: 100, height: 100)
                    .background(
                        Circle()
                            .fill(Color(hex: habit.colorHex).opacity(0.2))
                    )

                VStack(spacing: 4) {
                    Text(habit.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(habit.duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.spacingL)
        }
    }

    private var statsSection: some View {
        let stats = [
            (title: "habit.current".localized, value: "\(habit.currentStreak)", icon: "🔥"),
            (title: "habit.best".localized, value: "\(habit.bestStreak)", icon: "🏆"),
            (title: "habit.total".localized, value: "\(habit.checkIns?.count ?? 0)", icon: "✅"),
            (title: "habit.thisWeek".localized, value: "\(habit.weeklyProgress)", icon: "📅")
        ]
        
        // Динамічна сітка: 4 картки = 2x2
        let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
        
        return LazyVGrid(columns: columns, spacing: AppTheme.spacingM) {
            ForEach(0..<stats.count, id: \.self) { index in
                let stat = stats[index]
                HabitStatCard(
                    title: stat.title,
                    value: stat.value,
                    icon: stat.icon,
                    color: Color(hex: habit.colorHex)
                )
            }
        }
    }

    private var calendarSection: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                // Month navigation
                HStack {
                    Button(action: { previousMonth() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Text(monthYearString)
                        .font(.headline)

                    Spacer()

                    Button(action: { nextMonth() }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }

                // Calendar grid
                CalendarGridView(
                    habit: habit,
                    month: selectedMonth
                )
            }
            .padding()
        }
    }
    
    private var goalsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.blue)
                    Text("habit.goals".localized)
                        .font(.headline)
                    
                    Spacer()
                    
                    if !hasAnyGoals {
                        Text("habit.notSet".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if hasAnyGoals {
                    // Weekly Goal - View Only
                    if let weeklyGoal = habit.weeklyGoal {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                Text("goals.weeklyGoal".localized)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(habit.weeklyProgress)/\(weeklyGoal)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(habit.weeklyProgress >= weeklyGoal ? .green : .primary)
                            }
                            
                            ProgressView(value: Double(habit.weeklyProgress), total: Double(weeklyGoal))
                                .tint(.blue)
                        }
                        
                        if habit.monthlyGoal != nil || habit.yearlyGoal != nil {
                            Divider()
                        }
                    }
                    
                    // Monthly Goal - View Only
                    if let monthlyGoal = habit.monthlyGoal {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.purple)
                                    .font(.subheadline)
                                Text("goals.monthlyGoal".localized)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(habit.monthlyProgress)/\(monthlyGoal)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(habit.monthlyProgress >= monthlyGoal ? .green : .primary)
                            }
                            
                            ProgressView(value: Double(habit.monthlyProgress), total: Double(monthlyGoal))
                                .tint(.purple)
                        }
                        
                        if habit.yearlyGoal != nil {
                            Divider()
                        }
                    }
                    
                    // Yearly Goal - View Only
                    if let yearlyGoal = habit.yearlyGoal {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                                Text("goals.yearlyGoal".localized)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(habit.yearlyProgress)/\(yearlyGoal)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(habit.yearlyProgress >= yearlyGoal ? .green : .primary)
                            }
                            
                            ProgressView(value: Double(habit.yearlyProgress), total: Double(yearlyGoal))
                                .tint(.green)
                        }
                    }
                } else {
                    Text("edit.setGoals".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
            .padding()
        }
    }
    
    private var hasAnyGoals: Bool {
        habit.weeklyGoal != nil || habit.monthlyGoal != nil || habit.yearlyGoal != nil
    }

    private var settingsSection: some View {
        GlassCard {
            VStack(spacing: 0) {
                Toggle(isOn: $habit.reminderEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        Text("habit.reminder".localized)
                            .font(.headline)
                    }
                }
                .padding()
                .onChange(of: habit.reminderEnabled) { oldValue, newValue in
                    if newValue {
                        scheduleNotification()
                    } else {
                        cancelNotification()
                    }
                }

                if habit.reminderEnabled {
                    Divider()

                    DatePicker(
                        "habit.time".localized,
                        selection: Binding(
                            get: { habit.reminderTime ?? Date() },
                            set: { habit.reminderTime = $0 }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .padding()
                    .onChange(of: habit.reminderTime) { _, _ in
                        scheduleNotification()
                    }
                }

                Divider()

                Toggle(isOn: $habit.isArchived) {
                    HStack {
                        Image(systemName: "archivebox.fill")
                            .foregroundColor(.orange)
                        Text("habit.archive".localized)
                            .font(.headline)
                    }
                }
                .padding()
            }
        }
    }

    private var deleteButton: some View {
        Button(action: { showingDeleteAlert = true }) {
            Text("habit.delete".localized)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(AppTheme.cornerRadiusM)
        }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: LanguageManager.shared.selectedLanguage == "uk" ? "uk_UA" : "en_US")
        return formatter.string(from: selectedMonth)
    }

    private func previousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
    }

    private func nextMonth() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        if nextMonth <= Date() {
            selectedMonth = nextMonth
        }
    }

    private func scheduleNotification() {
        // Implemented in notifications system
    }

    private func cancelNotification() {
        // Implemented in notifications system
    }

    private func deleteHabit() {
        modelContext.delete(habit)
        try? modelContext.save()
        dismiss()
    }
}

struct HabitStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingS) {
                Text(icon)
                    .font(.title)

                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.spacingM)
        }
    }
}

struct CalendarGridView: View {
    let habit: Habit
    let month: Date

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.locale = Locale(identifier: LanguageManager.shared.selectedLanguage == "uk" ? "uk_UA" : "en_US")
        return cal
    }

    var body: some View {
        VStack(spacing: AppTheme.spacingS) {
            // Weekday headers
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar days
            LazyVGrid(columns: columns, spacing: AppTheme.spacingS) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isCompleted: isDateCompleted(date),
                            color: Color(hex: habit.colorHex)
                        )
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
    }

    private var weekdaySymbols: [String] {
        calendar.veryShortWeekdaySymbols
    }

    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date?] = []
        var currentDate = monthFirstWeek.start

        while days.count < 42 { // 6 weeks max
            if calendar.isDate(currentDate, equalTo: month, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return days
    }

    private func isDateCompleted(_ date: Date) -> Bool {
        guard let checkIns = habit.checkIns else { return false }
        return checkIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct DayCell: View {
    let date: Date
    let isCompleted: Bool
    let color: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? color.opacity(0.8) : (colorScheme == .dark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1)))
                .frame(height: 40)

            Text("\(Calendar.current.component(.day, from: date))")
                .font(.subheadline)
                .foregroundColor(isCompleted ? .white : (colorScheme == .dark ? .white : .black))
        }
    }
}

struct EditHabitView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext

    @State private var title: String
    @State private var selectedIcon: String
    @State private var selectedColor: PresetColor
    @State private var reminderEnabled: Bool
    @State private var reminderTime: Date
    @State private var isArchived: Bool
    
    // Daily Repetitions
    @State private var dailyRepetitions: Int
    @State private var reminderTimes: [Date]
    
    // Goals
    @State private var weeklyGoal: Int?
    @State private var monthlyGoal: Int?
    @State private var yearlyGoal: Int?
    @State private var goalsEnabled: Bool
    
    // UI State
    @State private var showGoalFields = false
    @State private var customEmoji = ""
    @State private var showingCustomEmojiInput = false

    init(habit: Habit) {
        self.habit = habit
        _title = State(initialValue: habit.title)
        _selectedIcon = State(initialValue: habit.icon)
        _selectedColor = State(initialValue: AppTheme.presetColors.first { $0.hex == habit.colorHex } ?? AppTheme.presetColors[0])
        _reminderEnabled = State(initialValue: habit.reminderEnabled)
        _reminderTime = State(initialValue: habit.reminderTime ?? Date())
        _isArchived = State(initialValue: habit.isArchived)
        _dailyRepetitions = State(initialValue: habit.dailyRepetitions)
        _reminderTimes = State(initialValue: habit.reminderTimes ?? [])
        _weeklyGoal = State(initialValue: habit.weeklyGoal)
        _monthlyGoal = State(initialValue: habit.monthlyGoal)
        _yearlyGoal = State(initialValue: habit.yearlyGoal)
        _goalsEnabled = State(initialValue: habit.weeklyGoal != nil || habit.monthlyGoal != nil || habit.yearlyGoal != nil)
        _showGoalFields = State(initialValue: habit.weeklyGoal != nil || habit.monthlyGoal != nil || habit.yearlyGoal != nil)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        // Basic Info Section
                        basicInfoSection
                        
                        // Goals Section
                        goalsSection
                        
                        // Settings Section
                        settingsSection
                    }
                    .padding(AppTheme.spacingL)
                }
            }
            .navigationTitle("edit.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("edit.cancel".localized) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("edit.save".localized) {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var basicInfoSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            titleInputCard
            iconSelectionCard
            colorSelectionCard
        }
    }
    
    private var titleInputCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                Label("edit.habitName".localized, systemImage: "textformat")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("e.g., Drink water", text: $title)
                    .textFieldStyle(.plain)
                    .font(.headline)
            }
            .padding()
        }
    }
    
    private var iconSelectionCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                Label("edit.icon".localized, systemImage: "face.smiling")
                    .font(.caption)
                    .foregroundColor(.secondary)

                iconScrollView
                
                if showingCustomEmojiInput {
                    customEmojiInputView
                }
            }
            .padding()
        }
    }
    
    private var iconScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.spacingS) {
                ForEach(commonIcons, id: \.self) { icon in
                    IconButton(
                        icon: icon,
                        isSelected: selectedIcon == icon && !showingCustomEmojiInput
                    ) {
                        selectedIcon = icon
                        showingCustomEmojiInput = false
                        customEmoji = ""
                    }
                }
                
                customEmojiButton
            }
        }
    }
    
    private var customEmojiButton: some View {
        Button(action: {
            showingCustomEmojiInput = true
            customEmoji = selectedIcon
        }) {
            VStack(spacing: 4) {
                Text(showingCustomEmojiInput && !customEmoji.isEmpty ? customEmoji : "+")
                    .font(showingCustomEmojiInput && !customEmoji.isEmpty ? .title2 : .title)
                    .frame(width: 50, height: 50)
                    .background(customEmojiButtonBackground)
                    .overlay(customEmojiButtonOverlay)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
        .padding(.leading, 2)
    }
    
    private var customEmojiButtonBackground: some View {
        Circle()
            .fill(showingCustomEmojiInput ? 
                (colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.9)) : 
                (colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.7))
            )
    }
    
    private var customEmojiButtonOverlay: some View {
        Circle()
            .stroke(
                showingCustomEmojiInput ? Color.blue : (colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.3)), 
                lineWidth: showingCustomEmojiInput ? 2 : 1
            )
    }
    
    private var customEmojiInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("addHabit.customEmoji".localized)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            TextField("addHabit.emojiPlaceholder".localized, text: $customEmoji)
                .textFieldStyle(.plain)
                .font(.title2)
                .frame(height: 44)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1))
                )
                .onChange(of: customEmoji) { _, newValue in
                    // Limit to single emoji
                    if !newValue.isEmpty {
                        let emoji = String(newValue.prefix(2)) // Allow for emoji with modifiers
                        customEmoji = emoji
                        selectedIcon = emoji
                    }
                }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private var colorSelectionCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                Label("edit.color".localized, systemImage: "paintpalette")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.spacingS) {
                        ForEach(AppTheme.presetColors) { preset in
                            ColorButton(
                                color: preset,
                                isSelected: selectedColor.id == preset.id
                            ) {
                                selectedColor = preset
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            // Section Header
            HStack {
                Label("edit.goals".localized, systemImage: "target")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("edit.optional".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                    )
            }
            .padding(.bottom, 4)
            
            if !showGoalFields {
                // Enable Goals Button
                GlassCard {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showGoalFields = true
                            // Set default values
                            weeklyGoal = 7
                            monthlyGoal = 30
                            yearlyGoal = 365
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: "target")
                                        .foregroundColor(.blue)
                                    Text("edit.setGoals".localized)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                                
                                Text("edit.trackProgress".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                // Goals Input Fields
                GlassCard {
                    VStack(spacing: AppTheme.spacingL) {
                        // Header with Remove All button
                        HStack {
                            Text("edit.setYourGoals".localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    weeklyGoal = nil
                                    monthlyGoal = nil
                                    yearlyGoal = nil
                                    showGoalFields = false
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("edit.removeAll".localized)
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.bottom, 4)
                        
                        // Weekly Goal
                        GoalInputRow(
                            title: "goals.weeklyGoal".localized,
                            icon: "calendar.badge.clock",
                            color: .blue,
                            value: $weeklyGoal,
                            placeholder: 7,
                            description: "edit.daysPerWeek".localized
                        )
                        
                        Divider()
                        
                        // Monthly Goal
                        GoalInputRow(
                            title: "goals.monthlyGoal".localized,
                            icon: "calendar",
                            color: .purple,
                            value: $monthlyGoal,
                            placeholder: 30,
                            description: "edit.daysPerMonth".localized
                        )
                        
                        Divider()
                        
                        // Yearly Goal
                        GoalInputRow(
                            title: "goals.yearlyGoal".localized,
                            icon: "calendar.badge.plus",
                            color: .green,
                            value: $yearlyGoal,
                            placeholder: 365,
                            description: "edit.daysPerYear".localized
                        )
                    }
                    .padding()
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            Label("edit.settings".localized, systemImage: "gearshape")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 4)
            
            GlassCard {
                VStack(spacing: 0) {
                    // Daily Repetitions Picker
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("habit.timesPerDay".localized)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("habit.timesPerDayDesc".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $dailyRepetitions) {
                            ForEach(1...5, id: \.self) { count in
                                Text("\(count)x").tag(count)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .onChange(of: dailyRepetitions) { oldValue, newValue in
                        // Оновлюємо кількість нагадувань
                        updateReminderTimes(for: newValue)
                    }
                    
                    Divider()
                    
                    // Reminder Toggle
                    Toggle(isOn: $reminderEnabled) {
                        HStack {
                            Image(systemName: reminderEnabled ? "bell.fill" : "bell.slash.fill")
                                .foregroundColor(reminderEnabled ? .blue : .gray)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("edit.dailyReminder".localized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                if reminderEnabled {
                                    Text("edit.getNotified".localized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()

                    // Reminder Time Pickers
                    if reminderEnabled {
                        Divider()
                        
                        if dailyRepetitions == 1 {
                            // Single reminder time
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                                
                                Text("edit.reminderTime".localized)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                DatePicker(
                                    "",
                                    selection: $reminderTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                            }
                            .padding()
                        } else {
                            // Multiple reminder times
                            VStack(spacing: 0) {
                                ForEach(0..<dailyRepetitions, id: \.self) { index in
                                    if index > 0 {
                                        Divider()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.blue)
                                            .frame(width: 24)
                                        
                                        Text("\("habit.reminder".localized) \(index + 1)")
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        DatePicker(
                                            "",
                                            selection: Binding(
                                                get: {
                                                    if index < reminderTimes.count {
                                                        return reminderTimes[index]
                                                    }
                                                    return Date()
                                                },
                                                set: { newValue in
                                                    if index < reminderTimes.count {
                                                        reminderTimes[index] = newValue
                                                    }
                                                }
                                            ),
                                            displayedComponents: .hourAndMinute
                                        )
                                        .labelsHidden()
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Archive Toggle
                    Toggle(isOn: $isArchived) {
                        HStack {
                            Image(systemName: isArchived ? "archivebox.fill" : "archivebox")
                                .foregroundColor(isArchived ? .orange : .gray)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("edit.archiveHabit".localized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(isArchived ? "edit.hiddenFromActive".localized : "edit.currentlyActive".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Info Card
            GlassCard {
                HStack(spacing: AppTheme.spacingM) {
                    Text("💡")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("edit.proTip".localized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("edit.proTipText".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                Color(hex: selectedColor.hex).opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private let commonIcons = ["⭐", "💧", "🧘", "🚶", "💪", "📚", "🎯", "😊", "🌱", "☀️", "🌙", "⚡", "🔥", "💎", "🎨", "🎵", "📝", "✅", "🏃", "🧠"]

    // MARK: - Actions
    
    private func saveChanges() {
        habit.title = title
        habit.icon = selectedIcon
        habit.colorHex = selectedColor.hex
        habit.reminderEnabled = reminderEnabled
        habit.reminderTime = reminderEnabled ? reminderTime : nil
        habit.isArchived = isArchived
        habit.dailyRepetitions = dailyRepetitions
        habit.reminderTimes = dailyRepetitions > 1 ? reminderTimes : nil
        habit.weeklyGoal = weeklyGoal
        habit.monthlyGoal = monthlyGoal
        habit.yearlyGoal = yearlyGoal
        
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()
        
        // Handle notifications
        if reminderEnabled {
            scheduleNotification()
        } else {
            cancelNotification()
        }
        
        dismiss()
    }
    
    private func updateReminderTimes(for count: Int) {
        // Оновлюємо масив часів нагадувань
        if count > reminderTimes.count {
            // Додаємо нові часи
            let defaultHours = [9, 14, 20, 12, 16] // Дефолтні години
            for i in reminderTimes.count..<count {
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: Date())
                components.hour = i < defaultHours.count ? defaultHours[i] : 12
                components.minute = 0
                if let time = calendar.date(from: components) {
                    reminderTimes.append(time)
                }
            }
        } else if count < reminderTimes.count {
            // Видаляємо зайві часи
            reminderTimes = Array(reminderTimes.prefix(count))
        }
    }
    
    private func scheduleNotification() {
        // Notification scheduling logic
    }
    
    private func cancelNotification() {
        // Notification cancellation logic
    }
}

// MARK: - Supporting Views

struct GoalInputRow: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var value: Int?
    let placeholder: Int
    let description: String
    
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.subheadline)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                HStack {
                    TextField(
                        "\(placeholder)",
                        text: Binding(
                            get: {
                                if let value = value {
                                    return "\(value)"
                                }
                                return ""
                            },
                            set: { newValue in
                                if newValue.isEmpty {
                                    value = nil
                                } else if let intValue = Int(newValue), intValue > 0 {
                                    value = intValue
                                }
                            }
                        )
                    )
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primary.opacity(0.05))
                    )
                    .focused($isFocused)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if value != nil {
                    Button(action: { value = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: { value = placeholder }) {
                        Text("edit.set".localized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(color.opacity(0.15))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - View Extension for Conditional Modifiers
// Note: This extension is used across multiple files (HabitDetailView, InsightsView)
// Placed here to avoid duplication errors
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, CheckIn.self, configurations: config)

    let habit = Habit(
        title: "Read",
        icon: "📚",
        colorHex: "#4A90E2"
    )
    container.mainContext.insert(habit)

    return NavigationStack {
        HabitDetailView(habit: habit)
    }
    .modelContainer(container)
}
