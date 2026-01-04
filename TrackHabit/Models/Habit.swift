import Foundation
import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var icon: String // emoji or SF Symbol name
    var colorHex: String // preset color as hex
    var duration: String // "≤1 min"
    var frequency: String // "daily" for MVP
    var daysOfWeek: [Int]? // Optional: 0 = Sunday, 6 = Saturday
    var createdAt: Date
    var isArchived: Bool
    var reminderEnabled: Bool
    var reminderTime: Date?
    var notes: String?
    var sortOrder: Int
    
    // Daily repetitions (для звичок що виконуються кілька разів на день)
    var dailyRepetitions: Int = 1 // Значення за замовчуванням для міграції
    var reminderTimes: [Date]? = nil // Опціональне, за замовчуванням nil
    
    // Goals
    var weeklyGoal: Int? // Target number of completions per week
    var monthlyGoal: Int? // Target number of completions per month
    var yearlyGoal: Int? // Target number of completions per year

    @Relationship(deleteRule: .cascade, inverse: \CheckIn.habit)
    var checkIns: [CheckIn]?

    init(
        id: UUID = UUID(),
        title: String,
        icon: String,
        colorHex: String,
        duration: String = "≤1 min",
        frequency: String = "daily",
        daysOfWeek: [Int]? = nil,
        createdAt: Date = Date(),
        isArchived: Bool = false,
        reminderEnabled: Bool = true, // Enabled by default
        reminderTime: Date? = nil,
        notes: String? = nil,
        sortOrder: Int = 0,
        dailyRepetitions: Int = 1, // За замовчуванням 1 раз на день
        reminderTimes: [Date]? = nil,
        weeklyGoal: Int? = nil,
        monthlyGoal: Int? = nil,
        yearlyGoal: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorHex = colorHex
        self.duration = duration
        self.frequency = frequency
        self.daysOfWeek = daysOfWeek
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.reminderEnabled = reminderEnabled
        self.dailyRepetitions = dailyRepetitions
        
        // Set up reminder times
        if let reminderTime = reminderTime {
            self.reminderTime = reminderTime
        } else if reminderEnabled {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            self.reminderTime = calendar.date(from: components)
        } else {
            self.reminderTime = nil
        }
        
        // Set up multiple reminder times if needed
        if let times = reminderTimes {
            self.reminderTimes = times
        } else if dailyRepetitions > 1 {
            // Створюємо дефолтні часи: 9:00, 14:00, 20:00 і т.д.
            var defaultTimes: [Date] = []
            let hours = [9, 14, 20, 12, 16] // Дефолтні години
            for i in 0..<min(dailyRepetitions, hours.count) {
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: Date())
                components.hour = hours[i]
                components.minute = 0
                if let time = calendar.date(from: components) {
                    defaultTimes.append(time)
                }
            }
            self.reminderTimes = defaultTimes
        } else {
            self.reminderTimes = nil
        }
        
        self.notes = notes
        self.sortOrder = sortOrder
        self.weeklyGoal = weeklyGoal
        self.monthlyGoal = monthlyGoal
        self.yearlyGoal = yearlyGoal
    }
}

// MARK: - Computed Properties
extension Habit {
    var currentStreak: Int {
        guard let checkIns = checkIns?.sorted(by: { $0.date > $1.date }) else { return 0 }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Check if there's a check-in today or yesterday
        guard let lastCheckIn = checkIns.first,
              let daysSinceLastCheckIn = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastCheckIn.date), to: today).day,
              daysSinceLastCheckIn <= 1 else {
            return 0
        }

        var streak = 0
        var currentDate = calendar.startOfDay(for: lastCheckIn.date)

        for checkIn in checkIns {
            let checkInDate = calendar.startOfDay(for: checkIn.date)

            if checkInDate == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if checkInDate < currentDate {
                // Gap found
                break
            }
        }

        return streak
    }

    var bestStreak: Int {
        guard let checkIns = checkIns?.sorted(by: { $0.date < $1.date }) else { return 0 }

        let calendar = Calendar.current
        var maxStreak = 0
        var currentStreak = 0
        var lastDate: Date?

        for checkIn in checkIns {
            let checkInDate = calendar.startOfDay(for: checkIn.date)

            if let last = lastDate {
                let daysDiff = calendar.dateComponents([.day], from: last, to: checkInDate).day ?? 0

                if daysDiff == 1 {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }

            lastDate = checkInDate
        }

        return max(maxStreak, currentStreak)
    }

    var lastCheckInDate: Date? {
        checkIns?.sorted(by: { $0.date > $1.date }).first?.date
    }

    var isCompletedToday: Bool {
        guard let checkIns = checkIns else { return false }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let todayCheckIns = checkIns.filter { calendar.isDate($0.date, inSameDayAs: today) }
        return todayCheckIns.count >= dailyRepetitions
    }
    
    var todayCompletionCount: Int {
        guard let checkIns = checkIns else { return 0 }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return checkIns.filter { calendar.isDate($0.date, inSameDayAs: today) }.count
    }
    
    var todayCompletionProgress: Double {
        guard dailyRepetitions > 0 else { return 0 }
        return min(Double(todayCompletionCount) / Double(dailyRepetitions), 1.0)
    }
    
    // MARK: - Goal Progress
    
    var weeklyProgress: Int {
        guard let checkIns = checkIns else { return 0 }
        let calendar = Calendar.current
        let today = Date()
        
        // Get start of current week (Monday)
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0
        }
        
        return checkIns.filter { checkIn in
            checkIn.date >= weekStart && checkIn.date <= today
        }.count
    }
    
    var monthlyProgress: Int {
        guard let checkIns = checkIns else { return 0 }
        let calendar = Calendar.current
        let today = Date()
        
        // Get start of current month
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            return 0
        }
        
        return checkIns.filter { checkIn in
            checkIn.date >= monthStart && checkIn.date <= today
        }.count
    }
    
    var yearlyProgress: Int {
        guard let checkIns = checkIns else { return 0 }
        let calendar = Calendar.current
        let today = Date()
        
        // Get start of current year
        guard let yearStart = calendar.date(from: calendar.dateComponents([.year], from: today)) else {
            return 0
        }
        
        return checkIns.filter { checkIn in
            checkIn.date >= yearStart && checkIn.date <= today
        }.count
    }
    
    var weeklyProgressPercentage: Double {
        guard let goal = weeklyGoal, goal > 0 else { return 0 }
        return min(Double(weeklyProgress) / Double(goal), 1.0)
    }
    
    var monthlyProgressPercentage: Double {
        guard let goal = monthlyGoal, goal > 0 else { return 0 }
        return min(Double(monthlyProgress) / Double(goal), 1.0)
    }
    
    var yearlyProgressPercentage: Double {
        guard let goal = yearlyGoal, goal > 0 else { return 0 }
        return min(Double(yearlyProgress) / Double(goal), 1.0)
    }
    
    var hasAnyGoal: Bool {
        weeklyGoal != nil || monthlyGoal != nil || yearlyGoal != nil
    }
}
