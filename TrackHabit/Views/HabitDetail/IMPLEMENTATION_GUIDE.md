# 🎯 Інструкція з оновлення досягнень

## ✅ Що вже зроблено:

### 1. Achievement.swift
- ✅ Змінено completions: 5000→750, 10000→1500, додано 2000
- ✅ Додано 8 нових досягнень у категорію Special
- ✅ Оновлено requirement для unlock_all: 49→54
- ✅ Видалено birthday_celebration та social_butterfly

### 2. AchievementManager.swift
- ✅ Оновлено checkAllAchievements() з новими ID
- ✅ Додано helper методи для нових досягнень:
  - `checkMultipleCheckInsOneDay(habits:count:)` ✅
  - `countCustomHabits(habits:)` ✅
  - `checkCustomIcon(habits:)` ⚠️ (потребує доопрацювання)
- ✅ Змінено legendary_status requirement: 40→35
- ✅ Оновлено unlock_all requirement: 49→54

---

## 📝 Що потрібно зробити:

### 1. Додати локалізацію

Відкрийте файл `NEW_ACHIEVEMENTS_LOCALIZATION.md` та скопіюйте всі ключі в:

**English (Localizable.strings):**
```
achievement.checkins_750.title
achievement.checkins_1500.title
achievement.double_trouble.title
achievement.triple_threat.title
achievement.custom_creator.title
achievement.icon_collector.title
achievement.three_day_streak_visit.title
achievement.week_streak_visit.title
achievement.notification_ninja.title
... та всі їх .description
```

**Ukrainian (Localizable.strings - uk):**
```
achievement.checkins_750.title.uk
achievement.checkins_1500.title.uk
... (всі українські переклади)
```

**Також видаліть старі ключі:**
```
achievement.birthday_celebration.*
achievement.social_butterfly.*
achievement.checkins_5000.*
achievement.checkins_10000.*
```

---

### 2. Оновити Habit модель (опціонально)

Для повної функціональності нових досягнень:

#### Для Custom Creator:
```swift:Habit.swift
// Додати властивість:
var templateId: String? = nil
var isFromTemplate: Bool { templateId != nil }
```

#### Для Icon Collector:
```swift:Habit.swift
// Додати властивість:
var hasCustomIcon: Bool = false
```

Потім в AddHabitView.swift при створенні:
```swift
// Якщо з шаблону:
newHabit.templateId = template.id

// Якщо обрано кастомну іконку:
newHabit.hasCustomIcon = true
```

---

### 3. Додати трекінг відкриттів додатку (опціонально)

Для досягнень App Explorer та Week Warrior:

#### Створити модель AppSession:
```swift:AppSession.swift
import Foundation
import SwiftData

@Model
final class AppSession {
    var date: Date
    var openedAt: Date
    
    init(date: Date = Date(), openedAt: Date = Date()) {
        self.date = Calendar.current.startOfDay(for: openedAt)
        self.openedAt = openedAt
    }
}
```

#### Додати до SharedModelContainer:
```swift:SharedModelContainer.swift
let schema = Schema([
    Habit.self,
    CheckIn.self,
    Achievement.self,
    AppSession.self  // ← Додати
])
```

#### Додати трекінг в TrackHabitApp:
```swift:TrackHabitApp.swift
var body: some Scene {
    WindowGroup {
        MainTabView()
            .modelContainer(SharedModelContainer.shared.container)
            .onAppear {
                trackAppOpen()
            }
    }
}

private func trackAppOpen() {
    let context = SharedModelContainer.shared.container.mainContext
    let today = Calendar.current.startOfDay(for: Date())
    
    // Перевірити чи вже є сесія сьогодні
    let predicate = #Predicate<AppSession> { session in
        session.date == today
    }
    var descriptor = FetchDescriptor(predicate: predicate)
    descriptor.fetchLimit = 1
    
    do {
        let existing = try context.fetch(descriptor)
        if existing.isEmpty {
            let session = AppSession()
            context.insert(session)
            try context.save()
        }
    } catch {
        print("Error tracking app open: \(error)")
    }
}
```

#### Додати helper методи в AchievementManager:
```swift:AchievementManager.swift
// Розкоментувати в checkAllAchievements():
let appOpenStreak = calculateAppOpenStreak()
updateAchievement(id: "three_day_streak_visit", progress: appOpenStreak, requirement: 3)
updateAchievement(id: "week_streak_visit", progress: appOpenStreak, requirement: 7)

// Додати метод:
private func calculateAppOpenStreak() -> Int {
    let descriptor = FetchDescriptor<AppSession>(
        sortBy: [SortDescriptor(\.date, order: .reverse)]
    )
    
    do {
        let sessions = try modelContext.fetch(descriptor)
        guard !sessions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for session in sessions {
            if calendar.isDate(session.date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    } catch {
        print("Error calculating app open streak: \(error)")
        return 0
    }
}
```

---

### 4. Додати трекінг сповіщень (опціонально)

Для досягнення Notification Ninja:

#### В NotificationManager.swift:
```swift
// Коли користувач тапає на сповіщення:
func userTappedNotification() {
    UserDefaults.standard.set(Date(), forKey: "lastNotificationTapTime")
    UserDefaults.standard.set(true, forKey: "openedFromNotification")
}
```

#### В TrackHabitApp.swift:
```swift
.onAppear {
    trackAppOpen()
    checkNotificationOpen()  // ← Додати
}

private func checkNotificationOpen() {
    if UserDefaults.standard.bool(forKey: "openedFromNotification") {
        let lastTapTime = UserDefaults.standard.object(forKey: "lastNotificationTapTime") as? Date ?? Date.distantPast
        let timeDifference = Date().timeIntervalSince(lastTapTime)
        
        if timeDifference <= 300 { // 5 хвилин
            // Встановити прапорець для досягнення
            UserDefaults.standard.set(true, forKey: "quickOpenAfterNotification")
        }
        
        UserDefaults.standard.set(false, forKey: "openedFromNotification")
    }
}
```

#### В AchievementManager.swift:
```swift
// Розкоментувати в checkAllAchievements():
let quickOpen = UserDefaults.standard.bool(forKey: "quickOpenAfterNotification")
updateAchievement(id: "notification_ninja", progress: quickOpen ? 1 : 0, requirement: 1)
```

---

### 5. Оновити checkCustomIcon метод

```swift:AchievementManager.swift
private func checkCustomIcon(habits: [Habit]) -> Bool {
    return habits.contains { $0.hasCustomIcon == true }
}
```

---

## 🧪 Тестування:

### 1. Базові досягнення (працюють одразу):
- ✅ Completions (10, 25, 50, 100, 250, 500, 750, 1000, 1500, 2000)
- ✅ Streaks (3, 7, 14, 21, 30, 50, 100, 200, 365, 500)
- ✅ Double Trouble / Triple Threat
- ✅ Custom Creator

### 2. Потребують оновлення Habit моделі:
- ⚠️ Icon Collector (додати hasCustomIcon)

### 3. Потребують трекінгу:
- ⏳ App Explorer (потрібен AppSession)
- ⏳ Week Warrior (потрібен AppSession)
- ⏳ Notification Ninja (потрібен notification tracking)

---

## 📊 Прогрес впровадження:

- [x] Оновити Achievement.swift
- [x] Оновити AchievementManager.swift
- [ ] Додати локалізацію
- [ ] Оновити Habit модель (опціонально)
- [ ] Додати AppSession модель (опціонально)
- [ ] Додати трекінг сповіщень (опціонально)
- [ ] Протестувати всі досягнення

---

## 💡 Примітки:

- Досягнення з позначкою ✅ працюють одразу
- Досягнення з позначкою ⚠️ потребують невеликих змін
- Досягнення з позначкою ⏳ потребують додаткових моделей/трекінгу
- Можна впровадити поступово: спочатку базові, потім додаткові

---

## 🎮 Результат:

Після повного впровадження:
- **54 досягнення** (було 49)
- **Більш реалістичні цілі** (макс 2000 замість 10000)
- **Більше різноманітності** (8 нових типів досягнень)
- **Краща залученість** (досягнення за регулярне відкриття)
