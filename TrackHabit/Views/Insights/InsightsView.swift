import SwiftUI
import SwiftUI
import SwiftData

struct InsightsView: View {
    @Query(filter: #Predicate<Habit> { !$0.isArchived }, sort: \Habit.sortOrder)
    private var habits: [Habit]

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var selectedPeriod: Period = .week
    @State private var showMotivation = false
    @State private var animateCards = false
    @AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false
    
    var isProUser: Bool {
        isTestPremiumEnabled || StoreManager.shared.isProUser
    }

    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"

        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .year: return 365
            }
        }
        
        var icon: String {
            switch self {
            case .week: return "calendar"
            case .month: return "calendar.badge.clock"
            case .year: return "calendar.badge.plus"
            }
        }
        
        var localizedName: String {
            switch self {
            case .week: return "goals.week".localized
            case .month: return "goals.month".localized
            case .year: return "goals.year".localized
            }
        }
    }

    var totalCompletions: Int {
        habits.reduce(0) { $0 + ($1.checkIns?.count ?? 0) }
    }

    var averageStreak: Double {
        guard !habits.isEmpty else { return 0 }
        let totalStreak = habits.reduce(0) { $0 + $1.currentStreak }
        return Double(totalStreak) / Double(habits.count)
    }

    var bestHabit: Habit? {
        habits.max(by: { ($0.currentStreak) < ($1.currentStreak) })
    }
    
    var habitsWithGoals: [Habit] {
        habits.filter { $0.hasAnyGoal }
    }

    var completionsInPeriod: Int {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -selectedPeriod.days, to: Date()) ?? Date()

        return habits.reduce(0) { total, habit in
            let count = habit.checkIns?.filter { $0.date >= startDate }.count ?? 0
            return total + count
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    LazyVStack(spacing: AppTheme.spacingL, pinnedViews: [.sectionHeaders]) {
                        // Hero Section with Motivation
                        heroSection
                            .padding(.horizontal, AppTheme.spacingL)
                            .padding(.top, AppTheme.spacingM)
                        
                        // Period Selector
                        periodSelectorSection
                            .padding(.horizontal, AppTheme.spacingL)
                        
                        // Main Stats Grid - 2x2
                        statsGridSection
                            .padding(.horizontal, AppTheme.spacingL)
                        
                        // Goals Progress
                        if !habitsWithGoals.isEmpty {
                            goalsSection
                        }
                        
                        // Best Performer
                        if let best = bestHabit, best.currentStreak > 0 {
                            bestPerformerSection(best)
                                .padding(.horizontal, AppTheme.spacingL)
                        }
                        
                        // Habits Grid - 2 columns
                        habitsGridSection
                            .padding(.horizontal, AppTheme.spacingL)
                        
                        // Pro Features / Advanced Analytics
                        if isProUser {
                            advancedInsightsSection
                                .padding(.horizontal, AppTheme.spacingL)
                        } else {
                            proUpsellSection
                                .padding(.horizontal, AppTheme.spacingL)
                        }
                        
                        // Calendar Heatmap
                        calendarHeatmapSection
                            .padding(.horizontal, AppTheme.spacingL)
                    }
                    .padding(.bottom, AppTheme.spacingXL)
                }
            }
            .navigationTitle("insights.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar) // Прозорий navigation bar
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateCards = true
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.indigo.opacity(0.3) : Color.indigo.opacity(0.15),
                colorScheme == .dark ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        GlassCard {
            heroContent
        }
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
    }
    
    private var heroContent: some View {
        VStack(spacing: AppTheme.spacingM) {
            HStack {
                heroTextSection
                Spacer()
                heroProgressCircle
            }
        }
        .padding()
    }
    
    private var heroTextSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("insights.yourProgress".localized)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(completedToday) з \(habits.count) " + "insights.completedToday".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var heroProgressCircle: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0, to: progressPercentage)
                .stroke(progressGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.8), value: progressPercentage)
            
            progressPercentageText
        }
        .frame(width: 80, height: 80)
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var progressPercentageText: some View {
        VStack(spacing: 2) {
            Text("\(Int(progressPercentage * 100))%")
                .font(.title3)
                .fontWeight(.bold)
            Text("common.done".localized)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private var progressPercentage: Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompletedToday }.count
        return Double(completed) / Double(habits.count)
    }
    
    // MARK: - Period Selector
    private var periodSelectorSection: some View {
        HStack(spacing: AppTheme.spacingM) {
            ForEach(Period.allCases, id: \.self) { period in
                PeriodButton(
                    period: period,
                    isSelected: selectedPeriod == period
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedPeriod = period
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Grid (2x2)
    private var statsGridSection: some View {
        LazyVGrid(columns: statsGridColumns, spacing: AppTheme.spacingM) {
            completedStatCard
            streakStatCard
            activeStatCard
            totalStatCard
        }
    }
    
    private var statsGridColumns: [GridItem] {
        [
            GridItem(.flexible(minimum: 150, maximum: 200), spacing: AppTheme.spacingM),
            GridItem(.flexible(minimum: 150, maximum: 200), spacing: AppTheme.spacingM)
        ]
    }
    
    private var completedStatCard: some View {
        StatCard(
            icon: "checkmark.circle.fill",
            title: "insights.completed".localized,
            value: "\(completionsInPeriod)",
            color: .green,
            gradient: [.green, .mint]
        )
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private var streakStatCard: some View {
        StatCard(
            icon: "flame.fill",
            title: "insights.avgStreak".localized,
            value: String(format: "%.1f", averageStreak),
            color: .orange,
            gradient: [.orange, .red]
        )
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    private var activeStatCard: some View {
        StatCard(
            icon: "target",
            title: "insights.active".localized,
            value: "\(habits.count)",
            color: .blue,
            gradient: [.blue, .cyan]
        )
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private var totalStatCard: some View {
        StatCard(
            icon: "chart.bar.fill",
            title: "insights.total".localized,
            value: "\(totalCompletions)",
            color: .purple,
            gradient: [.purple, .pink]
        )
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Goals Section
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            goalsSectionHeader
            goalsSectionContent
        }
    }
    
    private var goalsSectionHeader: some View {
        HStack {
            Image(systemName: "target")
                .foregroundColor(.blue)
            Text("insights.goalsProgress".localized)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, AppTheme.spacingL)
    }
    
    @ViewBuilder
    private var goalsSectionContent: some View {
        if habitsWithGoals.count == 1 {
            singleGoalCard
        } else {
            multipleGoalsGrid
        }
    }
    
    private var singleGoalCard: some View {
        GoalProgressCard(habit: habitsWithGoals[0])
            .scaleEffect(animateCards ? 1 : 0.8)
            .opacity(animateCards ? 1 : 0)
            .animation(
                .spring(response: 0.6, dampingFraction: 0.8).delay(0.5),
                value: animateCards
            )
            .padding(.horizontal, AppTheme.spacingL)
    }
    
    private var multipleGoalsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: AppTheme.spacingM),
                GridItem(.flexible(), spacing: AppTheme.spacingM)
            ],
            spacing: AppTheme.spacingM
        ) {
            ForEach(Array(habitsWithGoals.enumerated()), id: \.element.id) { index, habit in
                GoalProgressCard(habit: habit)
                    .scaleEffect(animateCards ? 1 : 0.8)
                    .opacity(animateCards ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(0.5 + Double(index) * 0.1),
                        value: animateCards
                    )
            }
        }
        .padding(.horizontal, AppTheme.spacingL)
    }
    
    // MARK: - Best Performer
    private func bestPerformerSection(_ habit: Habit) -> some View {
        GlassCard {
            bestPerformerContent(habit)
        }
    }
    
    private func bestPerformerContent(_ habit: Habit) -> some View {
        HStack(spacing: AppTheme.spacingL) {
            bestPerformerIcon(habit)
            
            VStack(alignment: .leading, spacing: 8) {
                bestPerformerBadge
                
                HStack(alignment: .center, spacing: AppTheme.spacingM) {
                    Text(habit.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    bestPerformerStreaks(habit)
                }
            }
        }
        .padding()
    }
    
    private func bestPerformerIcon(_ habit: Habit) -> some View {
        ZStack {
            Circle()
                .fill(bestPerformerIconGradient(habit))
                .frame(width: 80, height: 80)
            
            Text(habit.icon)
                .font(.system(size: 40))
        }
        .shimmerEffect()
    }
    
    private func bestPerformerIconGradient(_ habit: Habit) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: habit.colorHex).opacity(0.3),
                Color(hex: habit.colorHex).opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func bestPerformerStats(_ habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            bestPerformerBadge
            
            Text(habit.title)
                .font(.title3)
                .fontWeight(.bold)
            
            bestPerformerStreaks(habit)
        }
    }
    
    private var bestPerformerBadge: some View {
        HStack {
            Image(systemName: "crown.fill")
                .foregroundColor(.yellow)
            Text("insights.bestPerformer".localized)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func bestPerformerStreaks(_ habit: Habit) -> some View {
        HStack(spacing: AppTheme.spacingM) {
            currentStreakInfo(habit)
            bestStreakInfo(habit)
        }
    }
    
    private func currentStreakInfo(_ habit: Habit) -> some View {
        VStack(alignment: .center, spacing: 2) {
            HStack(spacing: 4) {
                Text("🔥")
                    .font(.caption)
                Text("\(habit.currentStreak)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            Text("insights.current".localized)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private func bestStreakInfo(_ habit: Habit) -> some View {
        VStack(alignment: .center, spacing: 2) {
            HStack(spacing: 4) {
                Text("🏆")
                    .font(.caption)
                Text("\(habit.bestStreak)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            Text("insights.best".localized)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Habits Grid (2 columns)
    private var habitsGridSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.purple)
                Text("insights.habitsBreakdown".localized)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            
            if habits.isEmpty {
                GlassCard {
                    VStack(spacing: AppTheme.spacingM) {
                        Text("📊")
                            .font(.system(size: 60))
                        Text("insights.noHabits".localized)
                            .font(.headline)
                        Text("insights.createFirst".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(AppTheme.spacingXL)
                    .frame(maxWidth: .infinity)
                }
            } else {
                habitsGrid
            }
        }
    }
    
    // MARK: - Habits Grid Helper
    @ViewBuilder
    private var habitsGrid: some View {
        let totalHabits = habits.count
        let isOdd = totalHabits % 2 != 0
        
        if totalHabits == 1 {
            // Якщо тільки 1 звичка - на повну ширину
            HabitInsightCard(habit: habits[0])
                .scaleEffect(animateCards ? 1 : 0.8)
                .opacity(animateCards ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
        } else {
            // 2+ звичок
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: AppTheme.spacingM),
                    GridItem(.flexible(), spacing: AppTheme.spacingM)
                ],
                spacing: AppTheme.spacingM
            ) {
                ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
                    HabitInsightCard(habit: habit)
                        .scaleEffect(animateCards ? 1 : 0.8)
                        .opacity(animateCards ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(0.6 + Double(index) * 0.05),
                            value: animateCards
                        )
                        // Якщо це остання карточка і загальна кількість непарна - розтягуємо на 2 колонки
                        .gridCellColumns(
                            (isOdd && index == totalHabits - 1) ? 2 : 1
                        )
                }
            }
        }
    }
    
    // MARK: - Calendar Heatmap Section
    private var calendarHeatmapSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("calendar.activityCalendar".localized)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            
            CalendarHeatmapView(habits: habits, period: selectedPeriod)
                .scaleEffect(animateCards ? 1 : 0.8)
                .opacity(animateCards ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
        }
    }
}

// MARK: - Supporting Components

// Period Button
struct PeriodButton: View {
    let period: InsightsView.Period
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    
    // Різні кольори для кожного періоду
    var gradientColors: [Color] {
        switch period {
        case .week:
            return [.green, .mint]
        case .month:
            return [.blue, .cyan]
        case .year:
            return [.purple, .pink]
        }
    }
    
    private var backgroundGradient: LinearGradient {
        if isSelected {
            return LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            let opacity = colorScheme == .dark ? 0.1 : 0.8
            return LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(opacity), Color.white.opacity(opacity)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            return .clear
        }
        return colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var buttonContent: some View {
        VStack(spacing: 8) {
            Image(systemName: period.icon)
                .font(.title3)
                .foregroundColor(isSelected ? .white : .primary)
            
            Text(period.localizedName)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.spacingM)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                .fill(backgroundGradient)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                .stroke(strokeColor, lineWidth: 1)
        )
    }
}

// Stat Card with Gradient
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let gradient: [Color]
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    
    private var iconGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: gradient),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GlassCard {
            cardContent
        }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingM) {
            iconSection
            statsSection
        }
        .padding()
    }
    
    private var iconSection: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(iconGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Goal Progress Card (Horizontal scroll or Grid)
struct GoalProgressCard: View {
    let habit: Habit
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                HStack {
                    Text(habit.icon)
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        if habit.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Text("🔥")
                                    .font(.caption2)
                                Text("\(habit.currentStreak)")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                
                VStack(spacing: AppTheme.spacingS) {
                    if let weekly = habit.weeklyGoal {
                        ProgressRow(
                            title: "goals.week".localized,
                            progress: habit.weeklyProgress,
                            goal: weekly,
                            color: .blue
                        )
                    }
                    
                    if let monthly = habit.monthlyGoal {
                        ProgressRow(
                            title: "goals.month".localized,
                            progress: habit.monthlyProgress,
                            goal: monthly,
                            color: .purple
                        )
                    }
                    
                    if let yearly = habit.yearlyGoal {
                        ProgressRow(
                            title: "goals.year".localized,
                            progress: habit.yearlyProgress,
                            goal: yearly,
                            color: .green
                        )
                    }
                }
            }
            .padding()
        }
        // ФІКСОВАНА ширина для grid, адаптивна для scroll
    }
}

struct ProgressRow: View {
    let title: String
    let progress: Int
    let goal: Int
    let color: Color
    
    var percentage: Double {
        guard goal > 0 else { return 0 }
        return min(Double(progress) / Double(goal), 1.0)
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.7)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            progressHeader
            progressBar
        }
    }
    
    private var progressHeader: some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(progress)/\(goal)")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(progress >= goal ? .green : .primary)
        }
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                
                Capsule()
                    .fill(progressGradient)
                    .frame(width: geometry.size.width * percentage)
            }
        }
        .frame(height: 6)
    }
}

// Habit Insight Card (Grid item)
struct HabitInsightCard: View {
    let habit: Habit
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var completionRate: Double {
        guard let checkIns = habit.checkIns, !checkIns.isEmpty else { return 0 }
        let daysActive = Calendar.current.dateComponents([.day], from: habit.createdAt, to: Date()).day ?? 1
        return Double(checkIns.count) / Double(max(daysActive, 1)) * 100
    }
    
    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                // Icon and Title
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: habit.colorHex).opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Text(habit.icon)
                            .font(.title)
                    }
                    
                    Text(habit.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Stats - компактно без переносу
                VStack(spacing: 8) {
                    // Streak і Total в один рядок без переносу
                    HStack(spacing: 8) {
                        // Streak
                        HStack(spacing: 2) {
                            Text("🔥")
                                .font(.caption)
                            Text("\(habit.currentStreak)")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text("stats.streak".localized)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        
                        Spacer(minLength: 4)
                        
                        // Total
                        HStack(spacing: 2) {
                            Text("\(habit.checkIns?.count ?? 0)")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text("stats.total".localized)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                    }
                    
                    // Completion indicator - на всю ширину якщо виконано
                    if habit.isCompletedToday {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("insights.doneToday".localized)
                                .font(.caption2)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Methods for InsightsView
extension InsightsView {
    private var advancedInsightsSection: some View {
        VStack(spacing: AppTheme.spacingL) {
            Text("premium.advancedAnalytics".localized)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Success Rate Pie Chart
            if completedToday > 0 {
                GlassCard {
                    VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                        Text("goals.todayProgress".localized)
                            .font(.headline)
                        
                        HStack {
                            Text("\(completedToday) " + "stats.of".localized + " \(habits.count) " + "stats.completed".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(progressPercentage * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var completedToday: Int {
        habits.filter { habit in
            habit.checkIns?.contains { checkIn in
                Calendar.current.isDateInToday(checkIn.date)
            } ?? false
        }.count
    }

    private var proUpsellSection: some View {
        GlassCard {
            proUpsellContent
        }
    }
    
    private var proUpsellContent: some View {
        VStack(spacing: AppTheme.spacingM) {
            Text("📊")
                .font(.system(size: 50))

            Text("premium.unlockInsights".localized)
                .font(.headline)

            Text("premium.detailedAnalytics".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            upgradeButton
        }
        .padding()
    }
    
    private var upgradeButton: some View {
        Button(action: {
            // Show paywall
        }) {
            upgradeButtonContent
        }
    }
    
    private var upgradeButtonContent: some View {
        Text("settings.upgradeToPro".localized)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(upgradeButtonGradient)
            .cornerRadius(AppTheme.cornerRadiusM)
    }
    
    private var upgradeButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// Keep existing components at the end...


// MARK: - Legacy Components (keeping for backwards compatibility)

struct InsightCard: View {
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
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.spacingM)
        }
    }
}

struct HabitInsightRow: View {
    let habit: Habit
    @Environment(\.colorScheme) var colorScheme

    var completionRate: Double {
        let calendar = Calendar.current
        guard let createdAt = calendar.dateComponents([.day], from: habit.createdAt, to: Date()).day else { return 0 }

        let daysSinceCreated = max(createdAt, 1)
        let completions = habit.checkIns?.count ?? 0

        return Double(completions) / Double(daysSinceCreated)
    }

    var body: some View {
        HStack(spacing: AppTheme.spacingM) {
            Text(habit.icon)
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(hex: habit.colorHex).opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: AppTheme.spacingS) {
                    if habit.currentStreak > 0 {
                        Text("🔥 \(habit.currentStreak)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    Text("\(habit.checkIns?.count ?? 0) " + "stats.checkIns".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(completionRate * 100))%")
                    .font(.headline)
                    .foregroundColor(Color(hex: habit.colorHex))

                Text("stats.success".localized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Goal Components for Insights
fileprivate struct InsightsGoalProgressBar: View {
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

fileprivate struct InsightsGoalCard: View {
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
                                Text("\(habit.currentStreak) day streak")
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
                        InsightsGoalProgressBar(
                            title: "Weekly Goal",
                            progress: habit.weeklyProgress,
                            goal: weeklyGoal,
                            color: .blue,
                            icon: "calendar.badge.clock"
                        )
                    }
                    
                    // Monthly Goal
                    if let monthlyGoal = habit.monthlyGoal {
                        InsightsGoalProgressBar(
                            title: "Monthly Goal",
                            progress: habit.monthlyProgress,
                            goal: monthlyGoal,
                            color: .purple,
                            icon: "calendar"
                        )
                    }
                    
                    // Yearly Goal
                    if let yearlyGoal = habit.yearlyGoal {
                        InsightsGoalProgressBar(
                            title: "Yearly Goal",
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

// MARK: - Calendar Heatmap View

struct CalendarHeatmapView: View {
    let habits: [Habit]
    let period: InsightsView.Period
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var selectedMonth = Date()
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    // Get dates based on selected period
    private var datesInPeriod: [Date] {
        if period == .year {
            // For year - show current month with navigation
            guard let range = calendar.range(of: .day, in: .month, for: selectedMonth),
                  let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)) else {
                return []
            }
            
            return range.compactMap { day -> Date? in
                calendar.date(byAdding: .day, value: day - 1, to: firstDay)
            }
        } else {
            // For week/month - show recent days
            let today = Date()
            let daysCount = period.days
            
            return (0..<daysCount).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: -dayOffset, to: today)
            }.reversed()
        }
    }
    
    // Get weekday of first day to add padding
    private var firstWeekday: Int {
        guard let firstDay = datesInPeriod.first else { return 0 }
        return calendar.component(.weekday, from: firstDay) - 1
    }
    
    // Calculate completion percentage for a specific day
    private func completionPercentage(for date: Date) -> Double {
        let completed = habits.filter { habit in
            habit.checkIns?.contains { checkIn in
                calendar.isDate(checkIn.date, inSameDayAs: date)
            } ?? false
        }.count
        
        guard !habits.isEmpty else { return 0 }
        return Double(completed) / Double(habits.count)
    }
    
    // Check if all habits completed on this day
    private func isFullyCompleted(for date: Date) -> Bool {
        guard !habits.isEmpty else { return false }
        return completionPercentage(for: date) == 1.0
    }
    
    // Check if any habits completed on this day
    private func hasAnyCompletion(for date: Date) -> Bool {
        return completionPercentage(for: date) > 0
    }
    
    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingM) {
                // Title with navigation (only for year)
                if period == .year {
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Text(monthYearString)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    HStack {
                        Text(periodTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                
                // Weekday headers
                if period != .week {
                    HStack(spacing: period == .week ? 8 : 4) {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .font(period == .week ? .caption : .caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                // Calendar grid
                if period == .week {
                    weekView
                } else {
                    standardView
                }
                
                // Legend
                HStack(spacing: AppTheme.spacingM) {
                    LegendItem(color: .blue.opacity(0.3), label: "calendar.partial".localized)
                    LegendItem(color: .blue, label: "calendar.complete".localized)
                }
                .font(.caption)
            }
            .padding()
        }
    }
    
    // Enhanced week view with better design
    private var weekView: some View {
        HStack(spacing: 4) {
            ForEach(datesInPeriod, id: \.self) { date in
                VStack(spacing: 4) {
                    // Day name
                    Text(dayName(for: date))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    // Day cell
                    WeekDayCell(
                        date: date,
                        isFullyCompleted: isFullyCompleted(for: date),
                        hasAnyCompletion: hasAnyCompletion(for: date),
                        isToday: calendar.isDateInToday(date)
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // Standard month/year view
    private var standardView: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            // Empty cells for padding
            ForEach(0..<firstWeekday, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.clear)
                    .frame(height: 36)
            }
            
            // Days
            ForEach(datesInPeriod, id: \.self) { date in
                InsightsDayCell(
                    date: date,
                    isFullyCompleted: isFullyCompleted(for: date),
                    hasAnyCompletion: hasAnyCompletion(for: date),
                    isToday: calendar.isDateInToday(date)
                )
            }
        }
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date).prefix(1).uppercased()
    }
    
    private var periodTitle: String {
        switch period {
        case .week:
            return "calendar.thisWeek".localized
        case .month:
            return "calendar.thisMonth".localized
        case .year:
            return monthYearString
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedMonth) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedMonth = newDate
            }
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedMonth) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedMonth = newDate
            }
        }
    }
}

// MARK: - Insights Day Cell

struct InsightsDayCell: View {
    let date: Date
    let isFullyCompleted: Bool
    let hasAnyCompletion: Bool
    let isToday: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var backgroundColor: Color {
        if isFullyCompleted {
            return .blue // Повністю виконано - синій
        } else if hasAnyCompletion {
            return .blue.opacity(0.3) // Частково виконано - світло-синій
        } else {
            return colorScheme == .dark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
            
            if isToday {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.blue, lineWidth: 2)
            }
            
            Text(dayNumber)
                .font(.system(size: 12, weight: isToday ? .bold : .medium))
                .foregroundColor(isFullyCompleted || hasAnyCompletion ? .white : .primary)
        }
        .frame(height: 36)
    }
}

// MARK: - Week Day Cell (Enhanced for week view)

struct WeekDayCell: View {
    let date: Date
    let isFullyCompleted: Bool
    let hasAnyCompletion: Bool
    let isToday: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var backgroundColor: Color {
        if isFullyCompleted {
            return .blue
        } else if hasAnyCompletion {
            return .blue.opacity(0.3)
        } else {
            return colorScheme == .dark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1)
        }
    }
    
    private var strokeGradient: LinearGradient {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var shadowColor: Color {
        isFullyCompleted ? .blue.opacity(0.2) : .clear
    }
    
    private var textColor: Color {
        isFullyCompleted || hasAnyCompletion ? .white : .primary
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
            
            if isToday {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(strokeGradient, lineWidth: 2)
            }
            
            Text(dayNumber)
                .font(.system(size: 16, weight: isToday ? .bold : .semibold))
                .foregroundColor(textColor)
        }
        .frame(height: 48)
        .shadow(color: shadowColor, radius: 6, x: 0, y: 3)
    }
}

// MARK: - Legend Item

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    InsightsView()
        .modelContainer(for: [Habit.self, CheckIn.self], inMemory: true)
}


