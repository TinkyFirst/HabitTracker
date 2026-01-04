import SwiftUI
import SwiftUI
import SwiftData
import WidgetKit

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { !$0.isArchived }, sort: \Habit.sortOrder)
    private var habits: [Habit]

    @State private var showingAddHabit = false
    @State private var showingGoalsSheet = false
    @State private var showCompletionAnimation = false
    @State private var completedHabitEmoji = ""
    @State private var newlyCreatedHabitId: UUID? = nil
    @State private var shouldShowEditForNewHabit = false // Новий state для контролю
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    @Binding var selectedHabitId: UUID?
    @Environment(\.openURL) var openURL
    
    var habitsWithGoals: [Habit] {
        habits.filter { $0.hasAnyGoal }
    }

    var completedToday: Int {
        habits.filter { $0.isCompletedToday }.count
    }

    var progressPercentage: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedToday) / Double(habits.count)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                VStack(spacing: 0) {
                    // Header with progress
                    headerView
                        .padding(.horizontal, AppTheme.spacingL)
                        .padding(.top, AppTheme.spacingM)

                    if habits.isEmpty {
                        emptyStateView
                    } else {
                        habitsList
                    }
                    
                    // Goals button at bottom
                    if !habitsWithGoals.isEmpty {
                        goalsButton
                            .padding(.horizontal, AppTheme.spacingL)
                            .padding(.vertical, AppTheme.spacingM)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar) // Прозорий navigation bar
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(newlyCreatedHabitId: $newlyCreatedHabitId)
            }
            .sheet(isPresented: $showingGoalsSheet) {
                GoalsSheetView(habits: habits)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .navigationDestination(item: $selectedHabitId) { habitId in
                if let habit = habits.first(where: { $0.id == habitId }) {
                    HabitDetailView(habit: habit, shouldShowEditOnAppear: shouldShowEditForNewHabit)
                        .onDisappear {
                            // Скидаємо прапорець коли виходимо з деталей
                            shouldShowEditForNewHabit = false
                        }
                }
            }
            .onOpenURL { url in
                handleDeepLink(url)
            }
            .onAppear {
                setupNotifications()
            }
            .onChange(of: newlyCreatedHabitId) { _, newId in
                if let habitId = newId {
                    // Встановлюємо прапорець що треба показати edit
                    shouldShowEditForNewHabit = true
                    
                    // Wait a bit for the sheet to dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedHabitId = habitId
                        newlyCreatedHabitId = nil
                    }
                }
            }
        }
    }
    
    private func setupNotifications() {
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                NotificationManager.shared.setupNotificationCategories()
                enableRemindersForExistingHabits()
                NotificationManager.shared.scheduleAllNotifications(habits: habits)
                
                let delegate = NotificationDelegate()
                delegate.modelContext = modelContext
                UNUserNotificationCenter.current().delegate = delegate
            }
        }
    }
    
    private func enableRemindersForExistingHabits() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 9
        components.minute = 0
        let defaultTime = calendar.date(from: components) ?? Date()
        
        for habit in habits where !habit.isArchived {
            if habit.reminderTime == nil {
                habit.reminderTime = defaultTime
                habit.reminderEnabled = true
            } else if !habit.reminderEnabled {
                habit.reminderEnabled = true
            }
        }
        
        try? modelContext.save()
    }
    
    private func handleDeepLink(_ url: URL) {
        // Handle URL scheme: trackhabit://habit/{habitId}
        guard url.scheme == "trackhabit",
              url.host == "habit",
              let habitIdString = url.pathComponents.last,
              let habitId = UUID(uuidString: habitIdString) else {
            return
        }
        
        selectedHabitId = habitId
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var goalsButton: some View {
        Button(action: { 
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showingGoalsSheet = true
            }
        }) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Text("goals.swipeUp".localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    // Swipe up gesture
                    if value.translation.height < -50 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showingGoalsSheet = true
                        }
                    }
                }
        )
    }


    private var headerView: some View {
        VStack(spacing: AppTheme.spacingM) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingText)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                ZStack {
                    ProgressRing(
                        progress: progressPercentage,
                        color: .blue
                    )
                    .frame(width: 60, height: 60)

                    VStack(spacing: 2) {
                        Text("\(completedToday)")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("/\(habits.count)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.bottom, AppTheme.spacingM) // Додатковий паддінг перед списком звичок
    }

    private var habitsList: some View {
        List {
            ForEach(habits) { habit in
                Button(action: {
                    selectedHabitId = habit.id
                }) {
                    HabitCard(habit: habit, onToggle: {
                        toggleHabit(habit)
                    })
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: AppTheme.spacingS, 
                                         leading: AppTheme.spacingL, 
                                         bottom: AppTheme.spacingS, 
                                         trailing: AppTheme.spacingL))
                .contextMenu {
                    Button {
                        setQuickGoal(for: habit, type: .week)
                    } label: {
                        Label("goals.setWeekly".localized, systemImage: "calendar.badge.clock")
                    }
                    
                    Button {
                        setQuickGoal(for: habit, type: .month)
                    } label: {
                        Label("goals.setMonthly".localized, systemImage: "calendar")
                    }
                    
                    Button {
                        setQuickGoal(for: habit, type: .forever)
                    } label: {
                        Label("goals.setYearly".localized, systemImage: "calendar.badge.plus")
                    }
                    
                    Divider()
                    
                    if habit.hasAnyGoal {
                        Button(role: .destructive) {
                            clearAllGoals(for: habit)
                        } label: {
                            Label("goals.clearAll".localized, systemImage: "xmark.circle")
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteHabit(habit)
                    } label: {
                        Label("common.delete".localized, systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.spacingL) {
            Spacer()

            VStack(spacing: AppTheme.spacingM) {
                Text("🎯")
                    .font(.system(size: 80))

                Text("today.noHabits".localized)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("today.noHabitsDescription".localized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            GlassButton(action: { showingAddHabit = true }) {
                Text("today.addFirstHabit".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 280)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(AppTheme.cornerRadiusM)
            }

            Spacer()
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "today.goodMorning".localized
        case 12..<17: return "today.goodAfternoon".localized
        default: return "today.goodEvening".localized
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        formatter.locale = Locale(identifier: LanguageManager.shared.selectedLanguage == "uk" ? "uk_UA" : "en_US")
        let dateString = formatter.string(from: Date())
        
        // Capitalize first letter of day and month for Ukrainian locale
        if LanguageManager.shared.selectedLanguage == "uk" {
            let components = dateString.components(separatedBy: ", ")
            if components.count == 2 {
                let dayCapitalized = components[0].prefix(1).uppercased() + components[0].dropFirst()
                let monthAndDate = components[1].components(separatedBy: " ")
                if monthAndDate.count == 2 {
                    let monthCapitalized = monthAndDate[0].prefix(1).uppercased() + monthAndDate[0].dropFirst()
                    return "\(dayCapitalized), \(monthCapitalized) \(monthAndDate[1])"
                }
            }
        }
        
        return dateString
    }

    private func toggleHabit(_ habit: Habit) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let todayCheckIns = habit.checkIns?.filter { calendar.isDate($0.date, inSameDayAs: today) } ?? []
        
        // Якщо звичка має множинні виконання
        if habit.dailyRepetitions > 1 {
            if todayCheckIns.count >= habit.dailyRepetitions {
                // Вже все виконано - видаляємо останнє виконання
                if let lastCheckIn = todayCheckIns.last {
                    modelContext.delete(lastCheckIn)
                    // Light haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            } else {
                // Додаємо ще одне виконання
                let checkIn = CheckIn(source: "manual")
                checkIn.habit = habit
                modelContext.insert(checkIn)
                
                // Success haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } else {
            // Стандартна логіка для звичок з 1 виконанням
            if habit.isCompletedToday {
                // Remove today's check-in
                if let checkIn = todayCheckIns.first {
                    modelContext.delete(checkIn)
                    // Light haptic feedback for unchecking
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            } else {
                // Add check-in
                let checkIn = CheckIn(source: "manual")
                checkIn.habit = habit
                modelContext.insert(checkIn)
                
                // Success haptic feedback - pleasant vibration
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }

        try? modelContext.save()
        
        // Update widgets
        WidgetRefreshManager.reloadHabitWidgets()
    }

    private func createHabitFromTemplate(_ template: HabitTemplate) {
        let habit = Habit(
            title: template.title,
            icon: template.icon,
            colorHex: template.colorHex,
            sortOrder: habits.count
        )
        modelContext.insert(habit)
        try? modelContext.save()
        
        // Оновити віджети після додавання нової звички
        WidgetRefreshManager.reloadHabitWidgets()
    }
    
    private func deleteHabit(_ habit: Habit) {
        // Тактильний відгук при видаленні
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        // Видалення звички з контексту
        modelContext.delete(habit)
        
        // Збереження змін
        try? modelContext.save()
        
        // Оновлення віджетів
        WidgetRefreshManager.reloadHabitWidgets()
    }
    
    // MARK: - Quick Goals
    enum GoalType {
        case week, month, forever
    }
    
    private func setQuickGoal(for habit: Habit, type: GoalType) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        switch type {
        case .week:
            habit.weeklyGoal = 7
            habit.monthlyGoal = nil
            habit.yearlyGoal = nil
        case .month:
            habit.weeklyGoal = nil
            habit.monthlyGoal = 30
            habit.yearlyGoal = nil
        case .forever:
            habit.weeklyGoal = 7
            habit.monthlyGoal = 30
            habit.yearlyGoal = 365
        }
        
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()
    }
    
    private func clearAllGoals(for habit: Habit) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        habit.weeklyGoal = nil
        habit.monthlyGoal = nil
        habit.yearlyGoal = nil
        
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()
    }
}

struct HabitCard: View {
    let habit: Habit
    let onToggle: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false

    var body: some View {
        GlassCard {
            HStack(spacing: AppTheme.spacingM) {
                // Icon with simple scale animation
                ZStack {
                    Circle()
                        .fill(Color(hex: habit.colorHex).opacity(0.2))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 1.05 : 1.0)
                    
                    Text(habit.icon)
                        .font(.system(size: 32))
                        .scaleEffect(isPressed ? 1.1 : 1.0)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)

                // Title and info
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)

                    HStack(spacing: 8) {
                        if habit.currentStreak > 0 {
                            StreakChip(streak: habit.currentStreak)
                        }
                        
                        // Показуємо інформацію про множинні виконання
                        if habit.dailyRepetitions > 1 {
                            HStack(spacing: 4) {
                                Image(systemName: "repeat")
                                    .font(.system(size: 10))
                                Text("\(habit.dailyRepetitions)x\("habit.perDay".localized)")
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.secondary.opacity(0.1))
                            )
                        }
                    }
                }

                Spacer()

                // Checkbox button з прогресом (якщо більше 1 разу на день)
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isPressed = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        onToggle()
                        isPressed = false
                    }
                }) {
                    ZStack {
                        // Background circle (сірий)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 44, height: 44)
                        
                        // Progress arc (для множинних виконань)
                        if habit.dailyRepetitions > 1 {
                            Circle()
                                .trim(from: 0, to: habit.todayCompletionProgress)
                                .stroke(
                                    Color.blue,
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                                .frame(width: 44, height: 44)
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: habit.todayCompletionProgress)
                        }
                        
                        // Border circle
                        Circle()
                            .stroke(
                                habit.isCompletedToday ? Color.blue : Color.white.opacity(0.3),
                                lineWidth: 2
                            )
                            .frame(width: 44, height: 44)
                        
                        // Count or Checkmark
                        if habit.dailyRepetitions > 1 && !habit.isCompletedToday {
                            // Показуємо прогрес як текст (1/2, 2/3 і т.д.)
                            Text("\(habit.todayCompletionCount)/\(habit.dailyRepetitions)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.blue)
                        } else if habit.isCompletedToday {
                            // Показуємо галочку коли все виконано
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.blue)
                                .scaleEffect(isPressed ? 1.2 : 1.0)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .shadow(color: habit.todayCompletionProgress > 0 ? .blue.opacity(0.3) : .clear, radius: 8)
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: habit.isCompletedToday)
            }
            .padding(AppTheme.spacingM)
            .contentShape(Rectangle()) // Важливо для того щоб можна було тапати по всій картці
        }
    }
}

struct QuickTemplateChip: View {
    let template: HabitTemplate
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(template.icon)
                    .font(.caption)
                Text(template.title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.7))
            )
            .overlay(
                Capsule()
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Goals Sheet View
struct GoalsSheetView: View {
    let habits: [Habit]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    private var habitsWithGoals: [Habit] {
        habits.filter { $0.hasAnyGoal }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? Color.black : Color(white: 0.95),
                        colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        // Header
                        VStack(spacing: AppTheme.spacingS) {
                            Image(systemName: "target")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            Text("goals.yourGoals".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("goals.trackProgress".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, AppTheme.spacingL)
                        
                        // Goals cards
                        if habitsWithGoals.isEmpty {
                            emptyGoalsState
                        } else {
                            ForEach(habitsWithGoals) { habit in
                                TodayGoalCard(habit: habit)
                            }
                        }
                    }
                    .padding(AppTheme.spacingL)
                }
            }
            .navigationTitle("goals.progressTitle".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var emptyGoalsState: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                Text("🎯")
                    .font(.system(size: 60))
                
                Text("goals.noGoalsSet".localized)
                    .font(.headline)
                
                Text("goals.longPress".localized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(AppTheme.spacingL)
        }
    }
}

// MARK: - Goal Progress Bar (for Goals Sheet)
fileprivate struct TodayGoalProgressBar: View {
    let title: String
    let progress: Int
    let goal: Int
    let color: Color
    let icon: String
    
    @Environment(\.colorScheme) var colorScheme
    
    private var percentage: Double {
        guard goal > 0 else { return 0 }
        return min(Double(progress) / Double(goal), 1.0)
    }
    
    private var isCompleted: Bool {
        progress >= goal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("\(progress)/\(goal)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isCompleted ? color : .primary)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(color)
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Goal Card (for Goals Sheet)
fileprivate struct TodayGoalCard: View {
    let habit: Habit
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                // Habit header
                HStack(spacing: AppTheme.spacingM) {
                    Text(habit.icon)
                        .font(.system(size: 32))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color(hex: habit.colorHex).opacity(0.2))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if habit.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("\(habit.currentStreak) " + "stats.dayStreak".localized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                // Goals progress
                VStack(spacing: AppTheme.spacingM) {
                    // Weekly Goal
                    if let weeklyGoal = habit.weeklyGoal {
                        TodayGoalProgressBar(
                            title: "goals.weeklyGoalLabel".localized,
                            progress: habit.weeklyProgress,
                            goal: weeklyGoal,
                            color: .blue,
                            icon: "calendar.badge.clock"
                        )
                    }
                    
                    // Monthly Goal
                    if let monthlyGoal = habit.monthlyGoal {
                        TodayGoalProgressBar(
                            title: "goals.monthlyGoalLabel".localized,
                            progress: habit.monthlyProgress,
                            goal: monthlyGoal,
                            color: .purple,
                            icon: "calendar"
                        )
                    }
                    
                    // Yearly Goal
                    if let yearlyGoal = habit.yearlyGoal {
                        TodayGoalProgressBar(
                            title: "goals.yearlyGoalLabel".localized,
                            progress: habit.yearlyProgress,
                            goal: yearlyGoal,
                            color: .green,
                            icon: "calendar.badge.plus"
                        )
                    }
                }
            }
            .padding(AppTheme.spacingM)
        }
    }
}

#Preview {
    TodayView(selectedHabitId: .constant(nil))
        .modelContainer(for: [Habit.self, CheckIn.self], inMemory: true)
}

