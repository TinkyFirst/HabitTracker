# Посібник з емодзі для досягнень

## ✅ Що виправлено:

1. **Додано підтримку емодзі** до `AchievementDefinition`
2. **Затемнення незакритих досягнень** - grayscale та opacity
3. **Виправлено анімацію розблокування** - додано dismiss при кліку

## 📝 Емодзі для всіх досягнень (50):

### First Steps (5)
- `first_habit`: ⭐ (вже додано)
- `first_checkin`: ✅ (вже додано)
- `three_habits`: 3️⃣ (вже додано)
- `five_habits`: 5️⃣
- `ten_habits`: 🔟

### Streaks (10)
- `streak_3`: 🔥
- `streak_7`: 🔥
- `streak_14`: 🔥
- `streak_21`: 🔥
- `streak_30`: 🔥
- `streak_50`: 🔥
- `streak_100`: 💯
- `streak_200`: 🚀
- `streak_365`: 🏆
- `streak_500`: 👑

### Completions (10)
- `checkins_10`: ✅
- `checkins_25`: ✨
- `checkins_50`: 🌟
- `checkins_100`: 💫
- `checkins_250`: ⭐
- `checkins_500`: 🏅
- `checkins_1000`: 🥇
- `checkins_2000`: 🥈
- `checkins_5000`: 🥉
- `checkins_10000`: 👑

### Consistency (10)
- `perfect_week`: 📅
- `perfect_month`: 🗓️
- `early_bird`: 🌅
- `night_owl`: 🌙
- `weekend_warrior`: ⚔️
- `all_habits_day`: 🎯
- `comeback_kid`: 💪
- `no_skip_month`: 🎖️
- `goal_crusher`: 🎯
- `overachiever`: 🚀

### Milestones (10)
- `one_week`: 📆
- `one_month`: 🗓️
- `three_months`: 📊
- `six_months`: 🎊
- `one_year`: 🎉
- `two_years`: 🥳
- `habit_master`: 🎓
- `dedication`: ❤️
- `resilient`: 🛡️
- `legendary_status`: 👑

### Special (10)
- `new_year_new_me`: 🎆
- `birthday_celebration`: 🎂
- `leap_day`: 🦘
- `midnight_warrior`: 🌃
- `multitasker`: 🎪
- `speed_demon`: ⚡
- `social_butterfly`: 🦋
- `collector`: 🗂️
- `perfectionist`: 💎
- `unlock_all`: 🏆

## 🔧 Як додати емодзі до решти досягнень:

Додайте параметр `emoji:` після `icon:` у кожному `AchievementDefinition`:

```swift
AchievementDefinition(
    id: "five_habits",
    titleKey: "achievement.five_habits.title",
    descriptionKey: "achievement.five_habits.description",
    icon: "5.circle.fill",
    emoji: "5️⃣",  // 👈 Додайте цей рядок
    color: "9C27B0",
    category: .habits,
    requirement: 5,
    rarity: .uncommon
)
```

## 🎨 Візуальний ефект:

- ✅ **Відкриті досягнення**: кольорові емодзі + кольоровий фон
- 🔒 **Закриті досягнення**: grayscale емодзі + сірий фон + знижена прозорість

## 🐛 Виправлення завису:

Анімація розблокування тепер:
1. Закривається при кліку на затемнений фон
2. Автоматично закривається через 3 секунди
3. Показує емодзі замість іконки (якщо вказано)
4. Не блокує інтерфейс

## 📱 Локалізація:

Всі досягнення використовують `LocalizedStringKey`, тому:
- Додайте переклади в `Localizable.strings`
- Формат: `"achievement.{id}.title"` та `"achievement.{id}.description"`

Приклад:
```
"achievement.first_habit.title" = "Перша звичка";
"achievement.first_habit.description" = "Створіть вашу першу звичку";
```
