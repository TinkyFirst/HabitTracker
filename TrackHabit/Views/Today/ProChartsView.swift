import SwiftUI
import Charts

// MARK: - Enhanced Charts for Pro Users

struct HabitCompletionChart: View {
    let habits: [Habit]
    let period: Int // days
    @State private var animationProgress: CGFloat = 0
    
    var chartData: [ChartDataPoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<period).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let completions = habits.filter { habit in
                habit.checkIns?.contains { checkIn in
                    calendar.isDate(checkIn.date, inSameDayAs: date)
                } ?? false
            }.count
            
            return ChartDataPoint(
                date: date,
                value: Double(completions),
                label: formatDate(date, dayOffset: dayOffset)
            )
        }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Completions")
                .font(.headline)
            
            Chart(chartData) { dataPoint in
                BarMark(
                    x: .value("Day", dataPoint.label),
                    y: .value("Completions", dataPoint.value * Double(animationProgress))
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(6)
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .font(.caption2)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animationProgress = 1.0
                }
            }
        }
    }
    
    private func formatDate(_ date: Date, dayOffset: Int) -> String {
        if dayOffset == 0 {
            return "Today"
        } else if dayOffset == 1 {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter.string(from: date)
        }
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let label: String
}

// MARK: - Streak Heatmap
struct StreakHeatmap: View {
    let habits: [Habit]
    let columns = 7
    let rows = 8 // 8 weeks
    @State private var selectedDay: Date?
    
    private var heatmapData: [[HeatmapCell]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<rows).map { row in
            (0..<columns).map { col in
                let dayOffset = row * columns + col
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
                let completions = countCompletions(for: date)
                
                return HeatmapCell(
                    date: date,
                    completions: completions,
                    intensity: intensityLevel(completions)
                )
            }
        }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 8 Weeks")
                .font(.headline)
            
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<columns, id: \.self) { col in
                            let cell = heatmapData[row][col]
                            HeatmapCellView(cell: cell)
                                .onTapGesture {
                                    selectedDay = cell.date
                                }
                        }
                    }
                }
            }
            
            // Legend
            HStack(spacing: 8) {
                Text("Less")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 3) {
                    ForEach(0...4, id: \.self) { level in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorForIntensity(level))
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text("More")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
    }
    
    private func countCompletions(for date: Date) -> Int {
        habits.filter { habit in
            habit.checkIns?.contains { checkIn in
                Calendar.current.isDate(checkIn.date, inSameDayAs: date)
            } ?? false
        }.count
    }
    
    private func intensityLevel(_ completions: Int) -> Int {
        switch completions {
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 3: return 3
        default: return 4
        }
    }
    
    private func colorForIntensity(_ intensity: Int) -> Color {
        switch intensity {
        case 0: return Color.secondary.opacity(0.15)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
}

struct HeatmapCell: Identifiable {
    let id = UUID()
    let date: Date
    let completions: Int
    let intensity: Int
}

struct HeatmapCellView: View {
    let cell: HeatmapCell
    @State private var isPressed = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(colorForIntensity)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    private var colorForIntensity: Color {
        switch cell.intensity {
        case 0: return Color.secondary.opacity(0.15)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
}

// MARK: - Success Rate Pie Chart
struct SuccessRatePieChart: View {
    let completed: Int
    let total: Int
    @State private var animationProgress: CGFloat = 0
    
    var successRate: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 20)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: successRate * animationProgress)
                    .stroke(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: animationProgress)
                
                VStack(spacing: 4) {
                    Text("\(Int(successRate * 100))%")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    Text("Success")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(completed)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(total - completed)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    Text("Missed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.2)) {
                animationProgress = 1.0
            }
        }
    }
}

// MARK: - Habit Performance Chart
struct HabitPerformanceChart: View {
    let habits: [Habit]
    @State private var animationProgress: CGFloat = 0
    
    var performanceData: [HabitPerformance] {
        habits.map { habit in
            let completionCount = habit.checkIns?.count ?? 0
            let completionRate = calculateCompletionRate(habit)
            
            return HabitPerformance(
                habit: habit,
                completions: completionCount,
                rate: completionRate
            )
        }
        .sorted { $0.rate > $1.rate }
        .prefix(5)
        .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Performers")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(performanceData) { performance in
                    HabitPerformanceRow(performance: performance, animationProgress: animationProgress)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = 1.0
            }
        }
    }
    
    private func calculateCompletionRate(_ habit: Habit) -> Double {
        guard let checkIns = habit.checkIns, !checkIns.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let daysSinceCreation = calendar.dateComponents([.day], from: habit.createdAt, to: Date()).day ?? 1
        
        return Double(checkIns.count) / Double(max(daysSinceCreation, 1))
    }
}

struct HabitPerformance: Identifiable {
    let id = UUID()
    let habit: Habit
    let completions: Int
    let rate: Double
}

struct HabitPerformanceRow: View {
    let performance: HabitPerformance
    let animationProgress: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            Text(performance.habit.icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(performance.habit.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.15))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: performance.habit.colorHex), Color(hex: performance.habit.colorHex).opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * performance.rate * animationProgress)
                    }
                }
                .frame(height: 6)
            }
            
            Text("\(Int(performance.rate * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .trailing)
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            GlassCard {
                HabitCompletionChart(habits: [], period: 7)
                    .padding()
            }
            
            GlassCard {
                StreakHeatmap(habits: [])
                    .padding()
            }
            
            GlassCard {
                SuccessRatePieChart(completed: 45, total: 60)
                    .padding()
            }
        }
        .padding()
    }
}
