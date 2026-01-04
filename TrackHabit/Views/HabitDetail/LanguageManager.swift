import Foundation
import SwiftUI

// Language Manager for app localization
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {
        // Автоматичне визначення мови при першому запуску
        if selectedLanguage.isEmpty {
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            // Якщо системна мова - українська або російська, встановлюємо українську
            // Інакше - англійська
            if systemLanguage == "uk" || systemLanguage == "ru" {
                selectedLanguage = "uk"
            } else {
                selectedLanguage = "en"
            }
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

// Localized strings helper
struct LocalizedStrings {
    static func get(_ key: String) -> String {
        let language = LanguageManager.shared.selectedLanguage
        
        if language == "uk" {
            return ukrainianStrings[key] ?? englishStrings[key] ?? key
        } else {
            return englishStrings[key] ?? key
        }
    }
    
    // English strings
    private static let englishStrings: [String: String] = [
        // Tab Bar
        "tab.today": "Today",
        "tab.insights": "Insights",
        "tab.settings": "Settings",
        
        // Calendar
        "calendar.activityCalendar": "Activity Calendar",
        "calendar.thisWeek": "This Week",
        "calendar.thisMonth": "This Month",
        "calendar.partial": "Partial",
        "calendar.complete": "Complete",
        
        // Days of week
        "day.sunday": "Sunday",
        "day.monday": "Monday",
        "day.tuesday": "Tuesday",
        "day.wednesday": "Wednesday",
        "day.thursday": "Thursday",
        "day.friday": "Friday",
        "day.saturday": "Saturday",
        
        // Months
        "month.january": "January",
        "month.february": "February",
        "month.march": "March",
        "month.april": "April",
        "month.may": "May",
        "month.june": "June",
        "month.july": "July",
        "month.august": "August",
        "month.september": "September",
        "month.october": "October",
        "month.november": "November",
        "month.december": "December",
        
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
        "settings.premium": "Premium",
        "settings.upgradeToPro": "Upgrade to Pro",
        "settings.testPremium": "Test Premium Mode",
        "settings.testPremiumDesc": "Enable all Pro features for testing",
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
        "settings.about": "About",
        "settings.development": "Development",
        "settings.proMember": "Pro Member",
        "settings.allFeaturesUnlocked": "All features unlocked",
        "settings.unlimitedHabits": "Unlimited habits & insights",
        "settings.resetOnboarding": "Reset Onboarding",
        "settings.restorePurchases": "Restore Purchases",
        "settings.restoring": "Restoring...",
        "settings.purchasesRestored": "Purchases restored successfully!",
        "settings.noPurchasesFound": "No purchases found to restore",
        "settings.restoreFailed": "Failed to restore purchases. Please try again.",
        
        // Paywall
        "paywall.title": "Upgrade to Pro",
        "paywall.subtitle": "Unlock unlimited habits and advanced insights",
        "paywall.monthly": "Monthly",
        "paywall.yearly": "Yearly",
        "paywall.lifetime": "Lifetime",
        "paywall.bestValue": "BEST VALUE",
        "paywall.save": "Save 48%",
        "paywall.perMonth": "/mo",
        "paywall.oneTime": "One-time",
        "paywall.startTrial": "Start Free Trial",
        "paywall.continue": "Continue",
        "paywall.trialInfo": "Start with 7 days free trial",
        "paywall.close": "Close",
        "paywall.purchaseFailed": "Purchase failed. Please try again.",
        "paywall.restoreFailed": "Failed to restore purchases. Please try again.",
        "paywall.featureUnlimited": "Unlimited Habits",
        "paywall.featureUnlimitedDesc": "Track as many habits as you want",
        "paywall.featureInsights": "Advanced Insights",
        "paywall.featureInsightsDesc": "Detailed analytics and trends",
        "paywall.featureReminders": "Multiple Reminders",
        "paywall.featureRemindersDesc": "Set multiple reminders per habit",
        "paywall.featureIcloud": "iCloud Sync",
        "paywall.featureIcloudDesc": "Sync across all your devices",
        "paywall.featureTags": "Tags & Notes",
        "paywall.featureTagsDesc": "Organize with tags and notes",
        "paywall.featureExport": "Export Data",
        "paywall.featureExportDesc": "Export your data anytime",
        "paywall.autoRenewable": "Auto-renewable subscription",
        "paywall.terms": "Terms",
        "paywall.privacy": "Privacy",
        
        // iCloud
        "icloud.title": "iCloud Sync",
        "icloud.enabled": "Enabled",
        "icloud.disabled": "Disabled",
        "icloud.syncing": "Syncing...",
        "icloud.lastSync": "Last synced",
        "icloud.never": "Never",
        "icloud.description": "Your habits automatically sync across all your devices using iCloud.",
        "icloud.requiresIcloud": "Requires iCloud account",
        "icloud.signIn": "Sign in to iCloud in Settings to enable sync.",
        "icloud.whatSyncs": "What syncs:",
        "icloud.allHabits": "All habits",
        "icloud.checkIns": "Check-ins history",
        "icloud.settings": "Settings & preferences",
        "icloud.goals": "Goals & targets",
        "icloud.syncNow": "Sync Now",
        
        // About
        "about.title": "About",
        "about.appName": "Track Habit",
        "about.tagline": "Build better habits, one day at a time",
        "about.version": "Version",
        "about.ourMission": "Our Mission",
        "about.missionDescription": "Track Habit helps you build lasting habits through consistency and simplicity. We believe that small, daily actions compound into remarkable life changes. Our mission is to make habit tracking effortless, beautiful, and genuinely helpful.",
        "about.keyFeatures": "Key Features",
        "about.feature1Title": "Progress Tracking",
        "about.feature1Desc": "Visualize your journey with beautiful charts and streaks",
        "about.feature2Title": "Smart Reminders",
        "about.feature2Desc": "Never miss a habit with intelligent notifications",
        "about.feature3Title": "Calendar View",
        "about.feature3Desc": "See your consistency at a glance with the activity calendar",
        "about.feature4Title": "Customization",
        "about.feature4Desc": "Personalize each habit with colors, icons, and goals",
        "about.feature5Title": "iCloud Sync",
        "about.feature5Desc": "Access your habits across all your Apple devices",
        "about.coreValues": "Core Values",
        "about.value1Title": "Privacy First",
        "about.value1Desc": "Your data stays on your device and in your iCloud. We never see or sell your information.",
        "about.value2Title": "Simplicity",
        "about.value2Desc": "No clutter, no distractions. Just the tools you need to build better habits.",
        "about.value3Title": "Sustainability",
        "about.value3Desc": "We focus on building habits that last, not quick fixes that fade away.",
        "about.byTheNumbers": "By the Numbers",
        "about.downloads": "Downloads",
        "about.rating": "Rating",
        "about.countries": "Countries",
        "about.habitsTracked": "Habits Tracked",
        "about.statsDisclaimer": "* These are placeholder numbers. The app has not been launched yet.",
        "about.shareApp": "Share Track Habit",
        "about.shareAppDesc": "Tell your friends about us",
        "about.shareMessage": "Check out Track Habit - the best way to build lasting habits! 🚀",
        "about.rateApp": "Rate on App Store",
        "about.rateAppDesc": "Help us grow with a review",
        "about.contactUs": "Contact Support",
        "about.contactUsDesc": "We're here to help",
        "about.privacyPolicy": "Privacy Policy",
        "about.termsOfService": "Terms of Service",
        "about.website": "Visit Website",
        "about.madeWith": "Made with ❤️ in Ukraine",
        "about.allRightsReserved": "All rights reserved",
        
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
        "common.edit": "Edit",
        
        // Goals & Context Menu
        "goals.setWeekly": "Set Weekly Goal (7 days)",
        "goals.setMonthly": "Set Monthly Goal (30 days)",
        "goals.setYearly": "Set Yearly Goal (Forever)",
        "goals.clearAll": "Clear All Goals",
        "goals.swipeUp": "Swipe up to see your goals progress",
        "goals.yourGoals": "Your Goals",
        "goals.trackProgress": "Track your progress across all habits",
        "goals.progressTitle": "Goals Progress",
        "goals.noGoalsSet": "No Goals Set",
        "goals.longPress": "Long press any habit to set a goal",
        "goals.todayProgress": "Today's Progress",
        "goals.weeklyGoalLabel": "Weekly Goal",
        "goals.monthlyGoalLabel": "Monthly Goal",
        "goals.yearlyGoalLabel": "Yearly Goal",
        
        // Statistics
        "stats.streak": "Streak",
        "stats.total": "Total",
        "stats.checkIns": "check-ins",
        "stats.success": "success",
        "stats.dayStreak": "day streak",
        "stats.completed": "completed",
        "stats.of": "of",
        
        // Premium
        "premium.advancedAnalytics": "Advanced Analytics",
        "premium.unlockInsights": "Unlock Advanced Insights",
        "premium.detailedAnalytics": "Get detailed analytics, trends, and personalized recommendations",
        
        // Add Habit
        "addHabit.chooseTemplate": "Choose Template",
        "addHabit.createHabit": "Create Habit",
        "addHabit.cancel": "Cancel",
        "addHabit.save": "Save",
        "addHabit.createCustom": "Create Custom",
        "addHabit.useTemplate": "Use Template",
        "addHabit.setGoalQuestion": "Set a goal for this habit?",
        "addHabit.chooseTracking": "Choose how long you want to track this habit",
        "addHabit.weeklyOption": "Weekly (7 days)",
        "addHabit.monthlyOption": "Monthly (30 days)",
        "addHabit.foreverOption": "Forever (Yearly)",
        "addHabit.noGoal": "No Goal",
        "addHabit.templates": "Templates",
        "addHabit.customHabit": "Custom Habit",
        "addHabit.habitName": "Habit Name",
        "addHabit.habitNamePlaceholder": "e.g., Drink water",
        "addHabit.icon": "Icon",
        "addHabit.color": "Color",
        "addHabit.customEmoji": "Enter your emoji",
        "addHabit.emojiPlaceholder": "Type emoji...",
        "addHabit.reminder": "Daily Reminder",
        "addHabit.reminderTime": "Reminder Time",
        "addHabit.freeLimitReached": "🔒 Free Limit Reached",
        "addHabit.upgradeUnlimited": "Upgrade to Pro for unlimited habits",
        
        // Habit Details
        "habit.edit": "Edit",
        "habit.delete": "Delete Habit",
        "habit.deleteConfirm": "Are you sure you want to delete this habit? This action cannot be undone.",
        "habit.current": "Current",
        "habit.best": "Best",
        "habit.total": "Total",
        "habit.goals": "Goals",
        "habit.notSet": "Not set",
        "habit.archive": "Archive",
        "habit.time": "Time",
        
        // Template Categories
        "Health": "Health",
        "Mindfulness": "Mindfulness",
        "Productivity": "Productivity",
        "Learning": "Learning",
        "Social": "Social",
        "Creative": "Creative",
        
        // Health Templates
        "template.drinkWater": "Drink Water",
        "template.drinkWaterExample": "5 sips",
        "template.stretch": "Stretch",
        "template.stretchExample": "1 minute stretch",
        "template.walk": "Walk",
        "template.walkExample": "Walk around room",
        "template.deepBreathing": "Deep Breathing",
        "template.deepBreathingExample": "3 deep breaths",
        "template.vitamins": "Vitamins",
        "template.vitaminsExample": "Take daily vitamin",
        "template.exercise": "Exercise",
        "template.exerciseExample": "10 squats",
        
        // Mindfulness Templates
        "template.meditate": "Meditate",
        "template.meditateExample": "1 minute meditation",
        "template.gratitude": "Gratitude",
        "template.gratitudeExample": "Think of 1 thing",
        "template.journal": "Journal",
        "template.journalExample": "Write 1 sentence",
        "template.smile": "Smile",
        "template.smileExample": "Smile in mirror",
        "template.affirmation": "Affirmation",
        "template.affirmationExample": "Say 1 affirmation",
        
        // Productivity Templates
        "template.makeBed": "Make Bed",
        "template.makeBedExample": "Make your bed",
        "template.planDay": "Plan Day",
        "template.planDayExample": "Review top 3 tasks",
        "template.cleanDesk": "Clean Desk",
        "template.cleanDeskExample": "Clear 1 item",
        "template.reviewGoals": "Review Goals",
        "template.reviewGoalsExample": "Read your goals",
        "template.noPhone": "No Phone",
        "template.noPhoneExample": "1 min phone-free",
        
        // Learning Templates
        "template.read": "Read",
        "template.readExample": "Read 1 page",
        "template.learnLanguage": "Learn Language",
        "template.learnLanguageExample": "Learn 1 word",
        "template.podcast": "Podcast",
        "template.podcastExample": "Listen 1 minute",
        "template.practiceSkill": "Practice Skill",
        "template.practiceSkillExample": "Practice 1 minute",
        "template.watchTutorial": "Watch Tutorial",
        "template.watchTutorialExample": "Watch 1 minute",
        
        // Social Templates
        "template.textFriend": "Text Friend",
        "template.textFriendExample": "Send 1 message",
        "template.callFamily": "Call Family",
        "template.callFamilyExample": "Call someone",
        "template.compliment": "Compliment",
        "template.complimentExample": "Give 1 compliment",
        "template.socialMediaBreak": "Social Media Break",
        "template.socialMediaBreakExample": "1 min offline",
        
        // Creative Templates
        "template.draw": "Draw",
        "template.drawExample": "Sketch for 1 min",
        "template.write": "Write",
        "template.writeExample": "Write 1 sentence",
        "template.takePhoto": "Take Photo",
        "template.takePhotoExample": "Capture 1 moment",
        "template.music": "Music",
        "template.musicExample": "Play 1 minute",
        "template.dance": "Dance",
        "template.danceExample": "Dance to 1 song",
        
        // Onboarding
        "onboarding.skip": "Skip",
        "onboarding.back": "Back",
        "onboarding.next": "Next",
        "onboarding.seePricing": "See Pricing",
        "onboarding.continueWithFree": "Continue with Free",
        "onboarding.step": "Step",
        "onboarding.of": "of",
        
        // Welcome Slide
        "onboarding.welcome.title": "Track Habit",
        "onboarding.welcome.subtitle": "Build Better Habits",
        "onboarding.welcome.feature1": "Track daily habits",
        "onboarding.welcome.feature2": "View insights",
        "onboarding.welcome.feature3": "Stay motivated",
        
        // Guide Slides
        "onboarding.guide1.title": "Create Your Habits",
        "onboarding.guide1.subtitle": "Tap + to add new habits",
        "onboarding.guide1.habit1": "💧 Drink water",
        "onboarding.guide1.habit2": "📚 Read 30 min",
        "onboarding.guide1.habit3": "🏃 Morning workout",
        
        "onboarding.guide2.title": "Track Daily",
        "onboarding.guide2.subtitle": "Check off completed habits",
        "onboarding.guide2.habit1": "Morning workout",
        "onboarding.guide2.habit2": "Read 30 min",
        "onboarding.guide2.habit3": "Drink water",
        
        "onboarding.guide3.title": "Track Progress",
        "onboarding.guide3.subtitle": "View insights and analytics",
        "onboarding.guide3.dayStreak": "Day Streak",
        "onboarding.guide3.completed": "Completed",
        "onboarding.guide3.thisWeek": "This Week",
        
        // Features Slide
        "onboarding.features.title": "Powerful Features",
        "onboarding.features.subtitle": "Everything you need to build better habits",
        "onboarding.features.insights": "Insights & Analytics",
        "onboarding.features.insightsDesc": "Track your progress with beautiful charts and statistics",
        "onboarding.features.reminders": "Smart Reminders",
        "onboarding.features.remindersDesc": "Never miss a habit with intelligent notifications",
        "onboarding.features.goals": "Goals & Streaks",
        "onboarding.features.goalsDesc": "Set goals and maintain streaks to stay motivated",
        "onboarding.features.icloud": "iCloud Sync",
        "onboarding.features.icloudDesc": "Access your habits on all your devices",
        "onboarding.features.customization": "Customization",
        "onboarding.features.customizationDesc": "Personalize colors, icons, and themes",
        "onboarding.features.achievements": "Achievements",
        "onboarding.features.achievementsDesc": "Unlock badges and celebrate milestones",
        
        // Pricing Slide
        "onboarding.pricing.title": "Go Pro",
        "onboarding.pricing.subtitle": "Unlock unlimited habits and advanced features",
        "onboarding.pricing.unlimitedHabits": "Unlimited habits",
        "onboarding.pricing.advancedAnalytics": "Advanced analytics",
        "onboarding.pricing.customThemes": "Custom themes",
        "onboarding.pricing.widgetCustomization": "Widget customization",
        "onboarding.pricing.smartNotifications": "Smart notifications",
        "onboarding.pricing.icloudSync": "iCloud sync",
        "onboarding.pricing.yearly": "Yearly",
        "onboarding.pricing.monthly": "Monthly",
        "onboarding.pricing.bestValue": "Best value - Save 60%",
        "onboarding.pricing.billedMonthly": "Billed monthly",
        "onboarding.pricing.subscribeNow": "Subscribe Now",
        "onboarding.pricing.perDay": "/day",
        "onboarding.pricing.terms": "Terms & Privacy Policy",
        
        // Multiple Daily Completions
        "habit.timesPerDay": "Times per day",
        "habit.timesPerDayDesc": "How many times you want to complete this habit daily",
        "habit.reminder": "Reminder",
        "habit.thisWeek": "This Week",
        "habit.perDay": "/day"
    ]
    
    // Ukrainian strings
    private static let ukrainianStrings: [String: String] = [
            // Tab Bar
            "tab.today": "Сьогодні",
            "tab.insights": "Успіхи", // Більш мотивуюче, ніж "Статистика"
            "tab.settings": "Налаштування",
            
            // Calendar
            "calendar.activityCalendar": "Календар активності",
            "calendar.thisWeek": "Цього тижня",
            "calendar.thisMonth": "Цього місяця",
            "calendar.partial": "Частково",
            "calendar.complete": "Повністю",
            
            // Days of week
            "day.sunday": "Неділя",
            "day.monday": "Понеділок",
            "day.tuesday": "Вівторок",
            "day.wednesday": "Середа",
            "day.thursday": "Четвер",
            "day.friday": "П'ятниця",
            "day.saturday": "Субота",
            
            // Months
            "month.january": "Січня",
            "month.february": "Лютого",
            "month.march": "Березня",
            "month.april": "Квітня",
            "month.may": "Травня",
            "month.june": "Червня",
            "month.july": "Липня",
            "month.august": "Серпня",
            "month.september": "Вересня",
            "month.october": "Жовтня",
            "month.november": "Листопада",
            "month.december": "Грудня",
            
            // Today View
            "today.title": "Сьогодні",
            "today.goodMorning": "Доброго ранку! ☕️",
            "today.goodAfternoon": "Гарного дня! ☀️",
            "today.goodEvening": "Затишного вечора! 🌙",
            "today.noHabits": "Чисто, як у небі",
            "today.noHabitsDescription": "Саме час завести корисну звичку.",
            "today.addFirstHabit": "Додати першу звичку",
            "today.done": "Зроблено",
            
            // Insights View
            "insights.title": "Мої успіхи",
            "insights.yourProgress": "Твій прогрес",
            "insights.completedToday": "зроблено сьогодні",
            "insights.completed": "Готово",
            "insights.avgStreak": "Сер. стрік", // "Стрік" — зрозумілий термін для трекерів
            "insights.active": "В роботі",
            "insights.total": "Всього",
            "insights.goalsProgress": "Рух до цілей",
            "insights.bestPerformer": "Звичка-герой", // Більш епічно
            "insights.current": "Зараз",
            "insights.best": "Рекорд",
            "insights.habitsBreakdown": "Деталі",
            "insights.noHabits": "Поки що тихо",
            "insights.createFirst": "Створіть звичку, щоб побачити графіки",
            "insights.doneToday": "Сьогодні — все!",
            
            // Goals
            "goals.weeklyGoal": "План на тиждень",
            "goals.monthlyGoal": "План на місяць",
            "goals.yearlyGoal": "План на рік",
            "goals.week": "Тиждень",
            "goals.month": "Місяць",
            "goals.year": "Рік",
            
            // Settings View
            "settings.title": "Налаштування",
            "settings.general": "Основне",
            "settings.language": "Мова",
            "settings.selectLanguage": "Оберіть мову",
            "settings.appearance": "Вигляд",
            "settings.theme": "Тема оформлення",
            "settings.system": "Як у системі",
            "settings.light": "Світла",
            "settings.dark": "Темна",
            "settings.notifications": "Сповіщення",
            "settings.enableReminders": "Нагадувати мені",
            "settings.data": "Мої дані",
            "settings.icloudSync": "Хмара iCloud",
            "settings.exportData": "Експорт даних",
            "settings.support": "Допомога",
            "settings.contactSupport": "Написати розробникам",
            "settings.rateApp": "Поставити ❤️",
            "settings.premium": "Pro версія",
            "settings.upgradeToPro": "Перейти на Pro",
            "settings.testPremium": "Спробувати Pro",
            "settings.testPremiumDesc": "Відкрити всі можливості для тесту",
            "settings.about": "Про додаток",
            "settings.version": "Версія",
            "settings.developer": "Розробник",
            "settings.development": "Розробка",
            "settings.proMember": "Учасник клубу Pro",
            "settings.allFeaturesUnlocked": "Всі фішки відкриті",
            "settings.unlimitedHabits": "Безліміт звичок та аналітики",
            "settings.resetOnboarding": "Показати інтро знову",
            "settings.restorePurchases": "Відновити покупки",
            "settings.restoring": "Відновлюю...",
            "settings.purchasesRestored": "Покупки успішно відновлено!",
            "settings.noPurchasesFound": "Не знайдено покупок для відновлення",
            "settings.restoreFailed": "Не вдалося відновити покупки. Спробуйте ще раз.",
            
            // Paywall
            "paywall.title": "Перейти на Pro",
            "paywall.subtitle": "Відкрий безліміт звичок та всі фішки",
            "paywall.monthly": "Місяць",
            "paywall.yearly": "Рік",
            "paywall.lifetime": "Назавжди",
            "paywall.popular": "ПОПУЛЯРНО",
            "paywall.bestValue": "НАЙВИГІДНІШЕ",
            "paywall.save": "Економія 48%",
            "paywall.perMonth": "/міс",
            "paywall.oneTime": "Одноразово",
            "paywall.startTrial": "Спробувати безкоштовно",
            "paywall.continue": "Продовжити",
            "paywall.trialInfo": "Перші 7 днів безкоштовно",
            "paywall.close": "Закрити",
            "paywall.purchaseFailed": "Помилка покупки. Спробуйте ще раз.",
            "paywall.restoreFailed": "Не вдалося відновити покупки. Спробуйте ще раз.",
            "paywall.featureUnlimited": "Безліміт звичок",
            "paywall.featureUnlimitedDesc": "Створюй скільки завгодно звичок",
            "paywall.featureInsights": "Розширена аналітика",
            "paywall.featureInsightsDesc": "Детальна статистика та тренди",
            "paywall.featureReminders": "Багато нагадувань",
            "paywall.featureRemindersDesc": "Декілька нагадувань на звичку",
            "paywall.featureIcloud": "Синхронізація iCloud",
            "paywall.featureIcloudDesc": "Синхронізація між всіма пристроями",
            "paywall.featureTags": "Теги і нотатки",
            "paywall.featureTagsDesc": "Організуй звички за тегами",
            "paywall.featureExport": "Експорт даних",
            "paywall.featureExportDesc": "Експортуй дані в будь-який момент",
            "paywall.autoRenewable": "Підписка з автоподовженням",
            "paywall.terms": "Умови",
            "paywall.privacy": "Приватність",
            
            // iCloud
            "icloud.title": "Хмара iCloud",
            "icloud.enabled": "Увімкнено",
            "icloud.disabled": "Вимкнено",
            "icloud.syncing": "Синхронізую...",
            "icloud.lastSync": "Остання синхронізація",
            "icloud.never": "Ніколи",
            "icloud.description": "Твої звички автоматично синхронізуються між пристроями через iCloud.",
            "icloud.requiresIcloud": "Потрібен акаунт iCloud",
            "icloud.signIn": "Увійди в iCloud в Налаштуваннях щоб увімкнути синхронізацію.",
            "icloud.whatSyncs": "Що синхронізується:",
            "icloud.allHabits": "Всі звички",
            "icloud.checkIns": "Історія виконань",
            "icloud.settings": "Налаштування",
            "icloud.goals": "Цілі",
            "icloud.syncNow": "Синхронізувати",
            
            // About
            "about.title": "Про додаток",
            "about.appName": "Track Habit",
            "about.tagline": "Будуй звички крок за кроком",
            "about.version": "Версія",
            "about.ourMission": "Наша місія",
            "about.missionDescription": "Track Habit допомагає будувати звички через постійність і простоту. Ми віримо, що маленькі щоденні кроки складаються в дивовижні зміни в житті. Наша мета — зробити трекінг звичок легким, красивим і дійсно корисним.",
            "about.keyFeatures": "Основні фішки",
            "about.feature1Title": "Відстеження прогресу",
            "about.feature1Desc": "Бачи свій шлях на красивих графіках і стріках",
            "about.feature2Title": "Розумні нагадування",
            "about.feature2Desc": "Ніколи не пропускай звички з розумними сповіщеннями",
            "about.feature3Title": "Календар активності",
            "about.feature3Desc": "Оцінюй свою стабільність одним поглядом",
            "about.feature4Title": "Персоналізація",
            "about.feature4Desc": "Налаштовуй кожну звичку під себе: кольори, іконки, цілі",
            "about.feature5Title": "Синхронізація iCloud",
            "about.feature5Desc": "Доступ до звичок на всіх твоїх Apple пристроях",
            "about.coreValues": "Наші цінності",
            "about.value1Title": "Приватність понад усе",
            "about.value1Desc": "Твої дані залишаються на твоєму пристрої і в iCloud. Ми ніколи не бачимо і не продаємо твою інформацію.",
            "about.value2Title": "Простота",
            "about.value2Desc": "Ніякого сміття, ніяких відволікань. Тільки інструменти для твоїх звичок.",
            "about.value3Title": "Сталість",
            "about.value3Desc": "Ми фокусуємося на звичках, що залишаються назавжди, а не на швидких фіксах.",
            "about.byTheNumbers": "Цифри говорять",
            "about.downloads": "Завантажень",
            "about.rating": "Рейтинг",
            "about.countries": "Країн",
            "about.habitsTracked": "Звичок відстежено",
            "about.statsDisclaimer": "* Це найобка. Додаток ще не запущений.",
            "about.shareApp": "Поділитись Track Habit",
            "about.shareAppDesc": "Розкажи друзям про нас",
            "about.shareMessage": "Глянь Track Habit - найкращий спосіб будувати звички! 🚀",
            "about.rateApp": "Оцінити в App Store",
            "about.rateAppDesc": "Допоможи нам зростати ❤️",
            "about.contactUs": "Написати в підтримку",
            "about.contactUsDesc": "Ми завжди на зв'язку",
            "about.privacyPolicy": "Політика приватності",
            "about.termsOfService": "Умови використання",
            "about.website": "Відвідати сайт",
            "about.madeWith": "Зроблено з ❤️ в Україні",
            "about.allRightsReserved": "Всі права захищені",
            
            // Edit Habit
            "edit.title": "Налаштування звички",
            "edit.habitName": "Назва",
            "edit.icon": "Іконка",
            "edit.color": "Колір",
            "edit.goals": "Цілі",
            "edit.optional": "Не обов'язково",
            "edit.setGoals": "Встановити ціль",
            "edit.trackProgress": "Слідкуй за прогресом на довгій дистанції",
            "edit.setYourGoals": "Твої цілі",
            "edit.removeAll": "Прибрати все",
            "edit.daysPerWeek": "Днів на тиждень",
            "edit.daysPerMonth": "Днів на місяць",
            "edit.daysPerYear": "Днів на рік",
            "edit.settings": "Параметри",
            "edit.dailyReminder": "Щоденне нагадування",
            "edit.getNotified": "Отримуй нагадування щодня",
            "edit.reminderTime": "Коли нагадати",
            "edit.archiveHabit": "В архів",
            "edit.hiddenFromActive": "Приховано з головного екрану",
            "edit.currentlyActive": "Активна звичка",
            "edit.proTip": "Лайфхак",
            "edit.proTipText": "Став реальні цілі. Краще 5 хвилин щодня, ніж година раз на тиждень. Ти зможеш!",
            "edit.set": "Ок",
            "edit.save": "Зберегти",
            "edit.cancel": "Назад",
            
            // Common
            "common.delete": "Видалити",
            "common.done": "Готово",
            "common.cancel": "Скасувати",
            "common.save": "Зберегти",
            "common.edit": "Змінити",
            
            // Goals & Context Menu
            "goals.setWeekly": "Ціль на тиждень (7 днів)",
            "goals.setMonthly": "Ціль на місяць (30 днів)",
            "goals.setYearly": "Ціль на рік (Марафон)",
            "goals.clearAll": "Скинути цілі",
            "goals.swipeUp": "Тягни вгору, щоб глянути прогрес",
            "goals.yourGoals": "Твої метрики",
            "goals.trackProgress": "Загальний прогрес по всіх фронтах",
            "goals.progressTitle": "Як ти рухаєшся до цілей",
            "goals.noGoalsSet": "Без цілей",
            "goals.longPress": "Затисни звичку, щоб додати ціль",
            "goals.todayProgress": "Прогрес за день",
            "goals.weeklyGoalLabel": "Тижнева ціль",
            "goals.monthlyGoalLabel": "Місячна ціль",
            "goals.yearlyGoalLabel": "Річна ціль",
            
            // Statistics
            "stats.streak": "Стрік",
            "stats.total": "Всього",
            "stats.checkIns": "разів",
            "stats.success": "успішність",
            "stats.dayStreak": "днів підряд",
            "stats.completed": "виконано",
            "stats.of": "з",
            
            // Premium
            "premium.advancedAnalytics": "Потужна аналітика 💪",
            "premium.unlockInsights": "Розблокувати всі інсайти",
            "premium.detailedAnalytics": "Отримай доступ до графіків, трендів та персональних порад",
            
            // Add Habit
            "addHabit.chooseTemplate": "Обери шаблон",
            "addHabit.createHabit": "Нова звичка",
            "addHabit.cancel": "Скасувати",
            "addHabit.save": "Створити",
            "addHabit.createCustom": "Своя звичка",
            "addHabit.useTemplate": "Взяти шаблон",
            "addHabit.setGoalQuestion": "Додати ціль?",
            "addHabit.chooseTracking": "Як довго будемо трекати?",
            "addHabit.weeklyOption": "Тиждень (Спринт)",
            "addHabit.monthlyOption": "Місяць (30 днів)",
            "addHabit.foreverOption": "Назавжди (Марафон)",
            "addHabit.noGoal": "Без цілі, просто для душі",
            "addHabit.templates": "Ідеї",
            "addHabit.customHabit": "Створити свою",
            "addHabit.habitName": "Як назвемо звичку?",
            "addHabit.habitNamePlaceholder": "напр., Вивчити Щедрик",
            "addHabit.icon": "Іконка",
            "addHabit.color": "Колір",
            "addHabit.customEmoji": "Введи свій емоджі",
            "addHabit.emojiPlaceholder": "Пиши емоджі...",
            "addHabit.reminder": "Нагадування",
            "addHabit.reminderTime": "Час",
            "addHabit.freeLimitReached": "🔒 Ліміт безкоштовної версії",
            "addHabit.upgradeUnlimited": "Оновись до Pro для безліміту",
            
            // Habit Details
            "habit.edit": "Змінити",
            "habit.delete": "Видалити звичку",
            "habit.deleteConfirm": "Точно видаляємо? Весь прогрес по цій звичці зникне безповоротно.",
            "habit.current": "Поточна",
            "habit.best": "Рекорд",
            "habit.total": "Всього",
            "habit.goals": "Цілі",
            "habit.notSet": "Немає",
            "habit.archive": "В архів",
            "habit.time": "Час",
            
            // Template Categories
            "Health": "Здоров'я",
            "Mindfulness": "Усвідомленість",
            "Productivity": "Продуктивність",
            "Learning": "Розвиток",
            "Social": "Соціум",
            "Creative": "Творчість",
            
            // Health Templates (з пасхалками)
            "template.drinkWater": "Випити води",
            "template.drinkWaterExample": "Не будь сухарем 💧",
            "template.stretch": "Розім'яти спину",
            "template.stretchExample": "1 хвилина, щоб не хрустіло",
            "template.walk": "Провітрити голову",
            "template.walkExample": "Коло навколо дому",
            "template.deepBreathing": "Глибоке дихання",
            "template.deepBreathingExample": "Вдих-видих (3 рази)",
            "template.vitamins": "Вітамінки",
            "template.vitaminsExample": "Пігулка сили",
            "template.exercise": "Руханка",
            "template.exerciseExample": "10 присідань",
            
            // Mindfulness Templates
            "template.meditate": "Зловити дзен",
            "template.meditateExample": "1 хвилина тиші",
            "template.gratitude": "Вдячність",
            "template.gratitudeExample": "За що дякую сьогодні?",
            "template.journal": "Щоденник",
            "template.journalExample": "Записати одну думку",
            "template.smile": "Усмішка",
            "template.smileExample": "Собі у дзеркалі",
            "template.affirmation": "Афірмація",
            "template.affirmationExample": "Я все зможу!",
            
            // Productivity Templates
            "template.makeBed": "Застелити ліжко",
            "template.makeBedExample": "Порядок в ліжку - порядок в голові",
            "template.planDay": "План на день",
            "template.planDayExample": "Топ-3 важливі справи",
            "template.cleanDesk": "Прибрати стіл",
            "template.cleanDeskExample": "Викинути зайве",
            "template.reviewGoals": "Згадати цілі",
            "template.reviewGoalsExample": "Куди я рухаюсь?",
            "template.noPhone": "Без телефону",
            "template.noPhoneExample": "1 хв реального життя",
            
            // Learning Templates
            "template.read": "Читати",
            "template.readExample": "Хоча б 1 сторінку",
            "template.learnLanguage": "Вчити мову",
            "template.learnLanguageExample": "Нове слово (Hello!)",
            "template.podcast": "Подкаст",
            "template.podcastExample": "Послухати розумних людей",
            "template.practiceSkill": "Скіли",
            "template.practiceSkillExample": "Практика 1 хвилину",
            "template.watchTutorial": "Туторіал",
            "template.watchTutorialExample": "Дізнатись щось нове",
            
            // Social Templates (головна пасхалка)
            "template.textFriend": "Написати другу",
            "template.textFriendExample": "Скинути мемчик",
            "template.callFamily": "Подзвонити рідним",
            "template.callFamilyExample": "Сказати, що ти в шапці 🧢",
            "template.compliment": "Комплімент",
            "template.complimentExample": "Зробити комусь приємно",
            "template.socialMediaBreak": "Детокс",
            "template.socialMediaBreakExample": "1 хв без скролінгу",
            
            // Creative Templates
            "template.draw": "Помалювати",
            "template.drawExample": "Швидкий скетч",
            "template.write": "Писати",
            "template.writeExample": "Пару рядків прози",
            "template.takePhoto": "Фото",
            "template.takePhotoExample": "Злови момент",
            "template.music": "Музика",
            "template.musicExample": "Зіграти на чомусь",
            "template.dance": "Танці",
            "template.danceExample": "Двіж під Смарагдове небо",
            
            // Onboarding
            "onboarding.skip": "Пропустити",
            "onboarding.back": "Назад",
            "onboarding.next": "Далі",
            "onboarding.seePricing": "Тарифи",
            "onboarding.continueWithFree": "Продовжити безкоштовно",
            "onboarding.step": "Крок",
            "onboarding.of": "з",
            
            // Welcome Slide
            "onboarding.welcome.title": "Трек Звичок",
            "onboarding.welcome.subtitle": "Будуємо кращі звички",
            "onboarding.welcome.feature1": "Відстежуй щоденні звички",
            "onboarding.welcome.feature2": "Переглядай статистику",
            "onboarding.welcome.feature3": "Залишайся мотивованим",
            
            // Guide Slides
            "onboarding.guide1.title": "Створюй звички",
            "onboarding.guide1.subtitle": "Тисни + і додавай нові",
            "onboarding.guide1.habit1": "💧 Пий воду",
            "onboarding.guide1.habit2": "📚 Читай 30 хв",
            "onboarding.guide1.habit3": "🏃 Ранкове тренування",
            
            "onboarding.guide2.title": "Трекай щодня",
            "onboarding.guide2.subtitle": "Відмічай виконані",
            "onboarding.guide2.habit1": "Ранкове тренування",
            "onboarding.guide2.habit2": "Читай 30 хв",
            "onboarding.guide2.habit3": "Пий воду",
            
            "onboarding.guide3.title": "Відслідковуй прогрес",
            "onboarding.guide3.subtitle": "Графіки та аналітика",
            "onboarding.guide3.dayStreak": "Днів підряд",
            "onboarding.guide3.completed": "Виконано",
            "onboarding.guide3.thisWeek": "Цього тижня",
            
            // Features Slide
            "onboarding.features.title": "Потужні можливості",
            "onboarding.features.subtitle": "Все, що потрібно для успішних звичок",
            "onboarding.features.insights": "Інсайти та аналітика",
            "onboarding.features.insightsDesc": "Відслідковуй прогрес на красивих графіках",
            "onboarding.features.reminders": "Розумні нагадування",
            "onboarding.features.remindersDesc": "Ніколи не забувай про свої звички",
            "onboarding.features.goals": "Цілі та стріки",
            "onboarding.features.goalsDesc": "Ставай цілі та тримай стріки для мотивації",
            "onboarding.features.icloud": "Синхронізація iCloud",
            "onboarding.features.icloudDesc": "Доступ до звичок на всіх пристроях",
            "onboarding.features.customization": "Кастомізація",
            "onboarding.features.customizationDesc": "Персоналізуй кольори, іконки та теми",
            "onboarding.features.achievements": "Досягнення",
            "onboarding.features.achievementsDesc": "Відкривай бейджі та святкуй успіхи",
            
            // Pricing Slide
            "onboarding.pricing.title": "Перейти на Pro",
            "onboarding.pricing.subtitle": "Відкрий безліміт звичок та всі фішки",
            "onboarding.pricing.unlimitedHabits": "Безліміт звичок",
            "onboarding.pricing.advancedAnalytics": "Розширена аналітика",
            "onboarding.pricing.customThemes": "Власні теми",
            "onboarding.pricing.widgetCustomization": "Налаштування віджетів",
            "onboarding.pricing.smartNotifications": "Розумні нагадування",
            "onboarding.pricing.icloudSync": "Синхронізація iCloud",
            "onboarding.pricing.yearly": "Рік",
            "onboarding.pricing.monthly": "Місяць",
            "onboarding.pricing.bestValue": "Найвигідніше - Економія 60%",
            "onboarding.pricing.billedMonthly": "Щомісяця",
            "onboarding.pricing.subscribeNow": "Підписатись",
            "onboarding.pricing.perDay": "/день",
            "onboarding.pricing.terms": "Умови та Політика приватності",
            
            // Multiple Daily Completions
            "habit.timesPerDay": "Разів на день",
            "habit.timesPerDayDesc": "Скільки разів виконувати цю звичку щодня",
            "habit.reminder": "Нагадування",
            "habit.thisWeek": "Цього тижня",
            "habit.perDay": "/день"
        ]
    }

// SwiftUI View modifier for easy localization
extension String {
    var localized: String {
        LocalizedStrings.get(self)
    }
}
