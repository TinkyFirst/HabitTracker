//
//  HabitWidget.swift
//  HabitWidget
//
//  Created with Claude Code
//

import SwiftUI
import WidgetKit
import SwiftData
import AppIntents

// MARK: - Main Habit Widget
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitWidgetProvider()) { entry in
            HabitWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Мої звички")
        .description("Відстежуйте свої звички прямо з домашнього екрану")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
// MARK: - Habit Widget View
struct HabitWidgetView: View {
    let entry: HabitWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallHabitWidgetView(entry: entry)
        case .systemMedium:
            MediumHabitWidgetView(entry: entry)
        case .systemLarge:
            LargeHabitWidgetView(entry: entry)
        default:
            MediumHabitWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget View
struct SmallHabitWidgetView: View {
    let entry: HabitWidgetEntry
    
    var body: some View {
        VStack(spacing: 6) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.15), lineWidth: 6)
                
                Circle()
                    .trim(from: 0, to: entry.progressPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 1) {
                    Text("\(entry.completedCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("з \(entry.totalCount)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 85, height: 85)
            
            Text("Сьогодні")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium Widget View
struct MediumHabitWidgetView: View {
    let entry: HabitWidgetEntry
    
    var displayHabits: [HabitSnapshot] {
        Array(entry.habits.prefix(3))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Compact Progress Section
            VStack(spacing: 3) {
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 6)
                    
                    Circle()
                        .trim(from: 0, to: entry.progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(entry.completedCount)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("з \(entry.totalCount)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 60, height: 60)
                
                Text("Сьогодні")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(width: 70)
            
            // Habits List
            VStack(alignment: .leading, spacing: 6) {
                if entry.habits.isEmpty {
                    Text("Додайте звички")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(displayHabits) { habit in
                        InteractiveHabitRowView(habit: habit)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
    }
}

// MARK: - Large Widget View
struct LargeHabitWidgetView: View {
    let entry: HabitWidgetEntry
    
    var displayHabits: [HabitSnapshot] {
        Array(entry.habits.prefix(10))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Compact Header
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Мої звички")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("\(entry.completedCount) з \(entry.totalCount)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Compact Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 4)
                    
                    Circle()
                        .trim(from: 0, to: entry.progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(entry.progressPercentage * 100))%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(width: 44, height: 44)
            }
            
            // Habits List
            if entry.habits.isEmpty {
                Spacer()
                VStack(spacing: 6) {
                    Text("📝")
                        .font(.system(size: 36))
                    Text("Додайте свою першу звичку")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(displayHabits) { habit in
                        InteractiveHabitRowView(habit: habit)
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(12)
    }
}

// MARK: - Interactive Habit Row View
struct InteractiveHabitRowView: View {
    let habit: HabitSnapshot
    
    var body: some View {
        Button(intent: ToggleHabitIntent(habitId: habit.id.uuidString)) {
            HStack(spacing: 8) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(habit.isCompletedToday ? Color(hex: habit.colorHex) : Color.secondary.opacity(0.12))
                        .frame(width: 22, height: 22)
                    
                    if habit.isCompletedToday {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 14, height: 14)
                    }
                }
                
                // Icon
                Text(habit.icon)
                    .font(.system(size: 15))
                
                // Title
                Text(habit.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer(minLength: 0)
                
                // Streak
                if habit.currentStreak > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.orange)
                        Text("\(habit.currentStreak)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.6))
            )
        }
        .buttonStyle(.plain)
    }
}

