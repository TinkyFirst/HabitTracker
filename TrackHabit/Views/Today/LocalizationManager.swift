import Foundation
import SwiftUI

// MARK: - Language Manager
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en" {
        didSet {
            objectWillChange.send()
        }
    }
    
    enum Language: String, CaseIterable {
        case english = "en"
        case ukrainian = "uk"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .ukrainian: return "Українська"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇬🇧"
            case .ukrainian: return "🇺🇦"
            }
        }
    }
    
    var currentLanguage: Language {
        Language(rawValue: selectedLanguage) ?? .english
    }
}

// MARK: - Localized Strings Helper
struct LocalizedStrings {
    static func get(_ key: String) -> String {
        let language = LanguageManager.shared.selectedLanguage
        
        if language == "uk" {
            return ukrainianStrings[key] ?? englishStrings[key] ?? key
        } else {
            return englishStrings[key] ?? key
        }
    }
    
    // MARK: - English Strings
    private static let englishStrings: [String: String] = [
        // Tab Bar
        "tab.today": "Today",
        "tab.insights": "Insights",
        "tab.settings": "Settings",
        
        // Today View
        "today.title": "Today",
        "today.goodMorning": "Good Morning",
        "today.goodAfternoon": "Good Afternoon",
        "today.goodEvening": "Good Evening",
        "today.noHabits": "No Habits Yet",
        "today.noHabitsDescription": "Start building better habits today!",
        "today.addFirstHabit": "Add Your First Habit",
        "today.done": "Done",
        
        // Insights View
        "insights.title": "Insights",
        "insights.yourProgress": "Your Progress",
        "insights.completedToday": "completed today",
        "insights.completed": "Completed",
        "insights.avgStreak": "Avg Streak",
        "insights.active": "Active",
        "insights.total": "Total",
        "insights.goalsProgress": "Goals Progress",
        "insights.bestPerformer": "Best Performer",
        "insights.current": "Current",
        "insights.best": "Best",
        "insights.habitsBreakdown": "Habits Breakdown",
        "insights.noHabits": "No habits yet",
        "insights.createFirst": "Create your first habit to see insights",
        "insights.doneToday": "Done Today",
        
        // Goals
        "goals.weeklyGoal": "Weekly Goal",
        "goals.monthlyGoal": "Monthly Goal",
        "goals.yearlyGoal": "Yearly Goal",
        "goals.week": "Week",
        "goals.month": "Month",
        "goals.year": "Year",
        
        // Settings View
        "settings.title": "Settings",
        "settings.general": "General",
        "settings.language": "Language",
        "settings.selectLanguage": "Select Language",
        "settings.appearance": "Appearance",
        "settings.theme": "Theme",
        "settings.system": "System",
        "settings.light": "Light",
        "settings.dark": "Dark",
        "settings.notifications": "Notifications",
        "settings.enableReminders": "Enable Reminders",
        "settings.data": "Data",
        "settings.icloudSync": "iCloud Sync",
        "settings.exportData": "Export Data",
        "settings.support": "Support",
        "settings.contactSupport": "Contact Support",
        "settings.rateApp": "Rate App",
        "settings.premium": "Premium",
        "settings.upgradeToPro": "Upgrade to Pro",
        "settings.testPremium": "Test Premium Mode",
        "settings.about": "About",
        "settings.version": "Version",
        "settings.developer": "Developer",
        "settings.development": "Development",
        
        // Habit Details
        "habit.edit": "Edit",
        "habit.delete": "Delete Habit",
        "habit.deleteConfirm": "Are you sure you want to delete this habit? This action cannot be undone.",
        "habit.current": "Current",
        "habit.best": "Best",
        "habit.total": "Total",
        "habit.goals": "Goals",
        "habit.notSet": "Not set",
        "habit.reminder": "Reminder",
        "habit.archive": "Archive",
        "habit.time": "Time",
        
        // Edit Habit
        "edit.title": "Edit Habit",
        "edit.habitName": "Habit Name",
        "edit.icon": "Icon",
        "edit.color": "Color",
        "edit.goals": "Goals",
        "edit.optional": "Optional",
        "edit.setGoals": "Set Goals for This Habit",
        "edit.trackProgress": "Track weekly, monthly, and yearly progress",
        "edit.setYourGoals": "Set Your Goals",
        "edit.removeAll": "Remove All",
        "edit.daysPerWeek": "Days per week",
        "edit.daysPerMonth": "Days per month",
        "edit.daysPerYear": "Days per year",
        "edit.settings": "Settings",
        "edit.dailyReminder": "Daily Reminder",
        "edit.getNotified": "Get notified every day",
        "edit.reminderTime": "Reminder Time",
        "edit.archiveHabit": "Archive Habit",
        "edit.hiddenFromActive": "Hidden from active habits",
        "edit.currentlyActive": "Currently active",
        "edit.proTip": "Pro Tip",
        "edit.proTipText": "Set realistic goals you can achieve consistently. Start small and increase gradually!",
        "edit.set": "Set",
        "edit.save": "Save",
        "edit.cancel": "Cancel",
        
        // Common
        "common.delete": "Delete",
        "common.done": "Done",
        "common.cancel": "Cancel",
        "common.save": "Save",
        "common.edit": "Edit"
    ]
    
    // MARK: - Ukrainian Strings
    private static let ukrainianStrings: [String: String] = [
        // Tab Bar
        "tab.today": "Сьогодні",
        "tab.insights": "Статистика",
        "tab.settings": "Налаштування",
        
        // Today View
        "today.title": "Сьогодні",
        "today.goodMorning": "Доброго ранку",
        "today.goodAfternoon": "Доброго дня",
        "today.goodEvening": "Доброго вечора",
        "today.noHabits": "Поки немає звичок",
        "today.noHabitsDescription": "Почніть будувати кращі звички сьогодні!",
        "today.addFirstHabit": "Додайте першу звичку",
        "today.done": "Готово",
        
        // Insights View
        "insights.title": "Статистика",
        "insights.yourProgress": "Ваш прогрес",
        "insights.completedToday": "виконано сьогодні",
        "insights.completed": "Виконано",
        "insights.avgStreak": "Сер. серія",
        "insights.active": "Активних",
        "insights.total": "Всього",
        "insights.goalsProgress": "Прогрес цілей",
        "insights.bestPerformer": "Найкраща звичка",
        "insights.current": "Поточна",
        "insights.best": "Найкраща",
        "insights.habitsBreakdown": "Аналіз звичок",
        "insights.noHabits": "Поки немає звичок",
        "insights.createFirst": "Створіть першу звичку, щоб побачити статистику",
        "insights.doneToday": "Готово сьогодні",
        
        // Goals
        "goals.weeklyGoal": "Тижнева ціль",
        "goals.monthlyGoal": "Місячна ціль",
        "goals.yearlyGoal": "Річна ціль",
        "goals.week": "Тиждень",
        "goals.month": "Місяць",
        "goals.year": "Рік",
        
        // Settings View
        "settings.title": "Налаштування",
        "settings.general": "Загальні",
        "settings.language": "Мова",
        "settings.selectLanguage": "Виберіть мову",
        "settings.appearance": "Вигляд",
        "settings.theme": "Тема",
        "settings.system": "Системна",
        "settings.light": "Світла",
        "settings.dark": "Темна",
        "settings.notifications": "Сповіщення",
        "settings.enableReminders": "Увімкнути нагадування",
        "settings.data": "Дані",
        "settings.icloudSync": "Синхронізація iCloud",
        "settings.exportData": "Експорт даних",
        "settings.support": "Підтримка",
        "settings.contactSupport": "Зв'язатися з підтримкою",
        "settings.rateApp": "Оцінити додаток",
        "settings.premium": "Преміум",
        "settings.upgradeToPro": "Оновити до Pro",
        "settings.testPremium": "Тестовий режим Premium",
        "settings.about": "Про додаток",
        "settings.version": "Версія",
        "settings.developer": "Розробник",
        "settings.development": "Розробка",
        
        // Habit Details
        "habit.edit": "Редагувати",
        "habit.delete": "Видалити звичку",
        "habit.deleteConfirm": "Ви впевнені, що хочете видалити цю звичку? Цю дію не можна буде скасувати.",
        "habit.current": "Поточна",
        "habit.best": "Найкраща",
        "habit.total": "Всього",
        "habit.goals": "Цілі",
        "habit.notSet": "Не встановлено",
        "habit.reminder": "Нагадування",
        "habit.archive": "Архівувати",
        "habit.time": "Час",
        
        // Edit Habit
        "edit.title": "Редагувати звичку",
        "edit.habitName": "Назва звички",
        "edit.icon": "Іконка",
        "edit.color": "Колір",
        "edit.goals": "Цілі",
        "edit.optional": "Опціонально",
        "edit.setGoals": "Встановити цілі для цієї звички",
        "edit.trackProgress": "Відстежуйте прогрес за тиждень, місяць та рік",
        "edit.setYourGoals": "Встановіть свої цілі",
        "edit.removeAll": "Видалити всі",
        "edit.daysPerWeek": "Днів на тиждень",
        "edit.daysPerMonth": "Днів на місяць",
        "edit.daysPerYear": "Днів на рік",
        "edit.settings": "Налаштування",
        "edit.dailyReminder": "Щоденне нагадування",
        "edit.getNotified": "Отримуйте нагадування щодня",
        "edit.reminderTime": "Час нагадування",
        "edit.archiveHabit": "Архівувати звичку",
        "edit.hiddenFromActive": "Прихована від активних звичок",
        "edit.currentlyActive": "Зараз активна",
        "edit.proTip": "Порада",
        "edit.proTipText": "Встановлюйте реалістичні цілі, яких ви можете досягти послідовно. Починайте з малого і поступово збільшуйте!",
        "edit.set": "Встановити",
        "edit.save": "Зберегти",
        "edit.cancel": "Скасувати",
        
        // Common
        "common.delete": "Видалити",
        "common.done": "Готово",
        "common.cancel": "Скасувати",
        "common.save": "Зберегти",
        "common.edit": "Редагувати"
    ]
}

// MARK: - String Extension
extension String {
    var localized: String {
        LocalizedStrings.get(self)
    }
}
