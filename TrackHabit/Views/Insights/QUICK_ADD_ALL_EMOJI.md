# 🚀 Швидке додавання ВСІХ емодзі

## Використайте Find & Replace в Xcode

### Крок 1: Відкрийте Achievement.swift

### Крок 2: Для кожного досягнення використовуйте Replace:

#### Streaks (7-500)
```
ЗНАЙТИ: id: "streak_7",\n            titleKey: "achievement.streak_7.title",\n            descriptionKey: "achievement.streak_7.description",\n            icon: "flame.fill",
ЗАМІНИТИ: id: "streak_7",\n            titleKey: "achievement.streak_7.title",\n            descriptionKey: "achievement.streak_7.description",\n            icon: "flame.fill",\n            emoji: "🔥",
```

Повторіть для: streak_14, streak_21, streak_30, streak_50 (emoji: "🔥")

```
streak_100 → emoji: "💯"
streak_200 → emoji: "🚀"  
streak_365 → emoji: "🏆"
streak_500 → emoji: "👑"
```

#### Completions (10-10000)
```
checkins_10 → emoji: "✅"
checkins_25 → emoji: "✨"
checkins_50 → emoji: "🌟"
checkins_100 → emoji: "💫"
checkins_250 → emoji: "⭐"
checkins_500 → emoji: "🏅"
checkins_1000 → emoji: "🥇"
checkins_2000 → emoji: "🥈"
checkins_5000 → emoji: "🥉"
checkins_10000 → emoji: "👑"
```

#### Consistency
```
perfect_week → emoji: "📅"
perfect_month → emoji: "🗓️"
early_bird → emoji: "🌅"
night_owl → emoji: "🌙"
weekend_warrior → emoji: "⚔️"
all_habits_day → emoji: "🎯"
comeback_kid → emoji: "💪"
no_skip_month → emoji: "🎖️"
goal_crusher → emoji: "🎯"
overachiever → emoji: "🚀"
```

#### Milestones
```
one_week → emoji: "📆"
one_month → emoji: "🗓️"
three_months → emoji: "📊"
six_months → emoji: "🎊"
one_year → emoji: "🎉"
two_years → emoji: "🥳"
habit_master → emoji: "🎓"
dedication → emoji: "❤️"
resilient → emoji: "🛡️"
legendary_status → emoji: "👑"
```

#### Special
```
new_year_new_me → emoji: "🎆"
birthday_celebration → emoji: "🎂"
leap_day → emoji: "🦘"
midnight_warrior → emoji: "🌃"
multitasker → emoji: "🎪"
speed_demon → emoji: "⚡"
social_butterfly → emoji: "🦋"
collector → emoji: "🗂️"
perfectionist → emoji: "💎"
unlock_all → emoji: "🏆"
```

## 📝 АБО: Скопіюйте готовий шаблон

Для кожного AchievementDefinition, вставте рядок після `icon:`:

### Шаблон:
```swift
AchievementDefinition(
    id: "achievement_id",
    titleKey: "achievement.achievement_id.title",
    descriptionKey: "achievement.achievement_id.description",
    icon: "icon.name",
    emoji: "🔥",  // 👈 ДОДАТИ ТУТ
    color: "HEXCOLOR",
    category: .category,
    requirement: N,
    rarity: .rarity
),
```

## ⚡ Найшвидший спосіб:

1. Використайте Multi-Cursor в Xcode (Option + Click)
2. Поставте курсори після кожного `icon: "...",`
3. Натисніть Enter та додайте `emoji: "X",`

## ✅ Після додавання перевірте:

- Всі досягнення мають поле `emoji`
- Емодзі відображаються в app
- Незакриті досягнення grayscale
- Закриті досягнення кольорові

🎉 Готово!
