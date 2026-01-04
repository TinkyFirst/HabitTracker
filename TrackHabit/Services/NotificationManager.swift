import Foundation
import Foundation
import UserNotifications
import SwiftData

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleNotification(for habit: Habit) {
        guard habit.reminderEnabled,
              let reminderTime = habit.reminderTime else { return }

        let content = UNMutableNotificationContent()
        let message = getReminderMessage(for: habit)
        
        content.title = getNotificationTitle()
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "HABIT_REMINDER"
        content.userInfo = ["habitId": habit.id.uuidString]

        // Extract hour and minute from reminderTime
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)

        var dateComponents = DateComponents()
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "habit-\(habit.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotification(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["habit-\(habit.id.uuidString)"]
        )
    }

    func updateNotification(for habit: Habit) {
        cancelNotification(for: habit)

        if habit.reminderEnabled {
            scheduleNotification(for: habit)
        }
    }

    func scheduleAllNotifications(habits: [Habit]) {
        // Remove all existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Schedule notifications for all enabled habits
        for habit in habits where habit.reminderEnabled && !habit.isArchived {
            scheduleNotification(for: habit)
        }
    }

    // Get notification title based on language
    private func getNotificationTitle() -> String {
        let isUkrainian = LanguageManager.shared.selectedLanguage == "uk"
        
        let titles = isUkrainian ? [
            "Час для вашої звички! ⏱️",
            "Нагадування про звичку 🔔",
            "Не забудьте! ⭐",
            "Час діяти! 💪",
            "Ваша хвилина настала! ✨"
        ] : [
            "Time for your habit! ⏱️",
            "Habit reminder 🔔",
            "Don't forget! ⭐",
            "Time to act! 💪",
            "Your moment is here! ✨"
        ]
        
        return titles.randomElement() ?? titles[0]
    }

    // Smart reminder copy variations - 30+ unique messages
    private func getReminderMessage(for habit: Habit) -> String {
        let isUkrainian = LanguageManager.shared.selectedLanguage == "uk"
        
        let messages = isUkrainian ? [
            // Motivational (Мотиваційні)
            "\(habit.icon) \(habit.title) - лише 1 хвилина!",
            "Час побудувати вашу серію! \(habit.icon)",
            "Швидке нагадування: \(habit.title) \(habit.icon)",
            "1 хвилина - це все, що потрібно! \(habit.icon)",
            "Збережіть вашу серію! \(habit.icon)",
            "Ви можете це зробити! \(habit.icon) \(habit.title)",
            "Маленькі кроки ведуть до великих змін! \(habit.icon)",
            "Сьогодні ваш день для \(habit.title)! \(habit.icon)",
            "Зробіть це зараз, подякуєте собі пізніше! \(habit.icon)",
            "Ваше майбутнє 'я' вдячне вам! \(habit.icon)",
            
            // Progress-focused (Орієнтовані на прогрес)
            "Ще один день ближче до мети! \(habit.icon)",
            "Продовжуйте рухатись вперед! \(habit.icon) \(habit.title)",
            "Кожен день має значення! \(habit.icon)",
            "Будуйте імпульс з \(habit.title)! \(habit.icon)",
            "Прогрес, а не досконалість! \(habit.icon)",
            "Ваш шлях до успіху продовжується! \(habit.icon)",
            "Ще один крок до вашої мети! \(habit.icon)",
            
            // Encouraging (Підбадьорливі)
            "Ви впораєтесь! \(habit.icon) \(habit.title)",
            "Почніть свій день правильно! \(habit.icon)",
            "Зробіть щось гарне для себе! \(habit.icon)",
            "Час інвестувати в себе! \(habit.icon)",
            "Ви варті цього! \(habit.icon) \(habit.title)",
            "Будьте пишаються своїм прогресом! \(habit.icon)",
            "Сьогодні новий шанс! \(habit.icon)",
            
            // Action-oriented (Орієнтовані на дію)
            "Готові? Час для \(habit.title)! \(habit.icon)",
            "Давайте зробимо це! \(habit.icon)",
            "Зараз ідеальний час! \(habit.icon) \(habit.title)",
            "Не відкладайте на потім! \(habit.icon)",
            "Хвилина зараз = успіх завтра! \(habit.icon)",
            "Коротко і ефективно: \(habit.title) \(habit.icon)",
            
            // Streak-focused (Орієнтовані на серію)
            "Не втрачайте серію! \(habit.icon)",
            "День \(habit.currentStreak + 1) чекає! \(habit.icon)",
            "Збережіть ваш імпульс! \(habit.icon) \(habit.title)",
            "Кожен день підряд має значення! \(habit.icon)"
        ] : [
            // Motivational
            "\(habit.icon) \(habit.title) - Just 1 minute!",
            "Time to build your streak! \(habit.icon)",
            "Quick reminder: \(habit.title) \(habit.icon)",
            "1 minute is all it takes! \(habit.icon)",
            "Keep your streak alive! \(habit.icon)",
            "You've got this! \(habit.icon) \(habit.title)",
            "Small steps lead to big changes! \(habit.icon)",
            "Today is your day for \(habit.title)! \(habit.icon)",
            "Do it now, thank yourself later! \(habit.icon)",
            "Your future self will thank you! \(habit.icon)",
            
            // Progress-focused
            "One day closer to your goal! \(habit.icon)",
            "Keep the momentum going! \(habit.icon) \(habit.title)",
            "Every day counts! \(habit.icon)",
            "Build momentum with \(habit.title)! \(habit.icon)",
            "Progress, not perfection! \(habit.icon)",
            "Your journey to success continues! \(habit.icon)",
            "Another step towards your goal! \(habit.icon)",
            
            // Encouraging
            "You can do this! \(habit.icon) \(habit.title)",
            "Start your day right! \(habit.icon)",
            "Do something great for yourself! \(habit.icon)",
            "Time to invest in yourself! \(habit.icon)",
            "You're worth it! \(habit.icon) \(habit.title)",
            "Be proud of your progress! \(habit.icon)",
            "Today is a new chance! \(habit.icon)",
            
            // Action-oriented
            "Ready? Time for \(habit.title)! \(habit.icon)",
            "Let's do this! \(habit.icon)",
            "Now is the perfect time! \(habit.icon) \(habit.title)",
            "Don't put it off! \(habit.icon)",
            "One minute now = success tomorrow! \(habit.icon)",
            "Quick and effective: \(habit.title) \(habit.icon)",
            
            // Streak-focused
            "Don't break the chain! \(habit.icon)",
            "Day \(habit.currentStreak + 1) awaits! \(habit.icon)",
            "Keep your momentum! \(habit.icon) \(habit.title)",
            "Every consecutive day matters! \(habit.icon)"
        ]

        return messages.randomElement() ?? messages[0]
    }

    func setupNotificationCategories() {
        let isUkrainian = LanguageManager.shared.selectedLanguage == "uk"
        
        let doneAction = UNNotificationAction(
            identifier: "DONE_ACTION",
            title: isUkrainian ? "Готово" : "Mark Done",
            options: [.foreground]
        )

        let laterAction = UNNotificationAction(
            identifier: "LATER_ACTION",
            title: isUkrainian ? "Пізніше" : "Later",
            options: []
        )

        let category = UNNotificationCategory(
            identifier: "HABIT_REMINDER",
            actions: [doneAction, laterAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var modelContext: ModelContext?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let habitIdString = userInfo["habitId"] as? String,
           let habitId = UUID(uuidString: habitIdString),
           let modelContext = modelContext {

            if response.actionIdentifier == "DONE_ACTION" {
                // Mark habit as done
                let descriptor = FetchDescriptor<Habit>(
                    predicate: #Predicate { habit in
                        habit.id == habitId
                    }
                )

                if let habits = try? modelContext.fetch(descriptor),
                   let habit = habits.first {

                    // Check if already completed today
                    if !habit.isCompletedToday {
                        let checkIn = CheckIn(source: "notification")
                        checkIn.habit = habit
                        modelContext.insert(checkIn)
                        try? modelContext.save()
                    }
                }
            }
        }

        completionHandler()
    }
}
