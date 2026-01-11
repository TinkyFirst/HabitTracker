# 🎨 Повний список емодзі для всіх досягнень

## Інструкція: Додайте `emoji: "X"` після `icon:` в кожному AchievementDefinition

### Streaks (решта)
```swift
emoji: "🔥", // streak_7
emoji: "🔥", // streak_14
emoji: "🔥", // streak_21  
emoji: "🔥", // streak_30
emoji: "🔥", // streak_50
emoji: "💯", // streak_100
emoji: "🚀", // streak_200
emoji: "🏆", // streak_365
emoji: "👑", // streak_500
```

### Completions
```swift
emoji: "✅", // checkins_10
emoji: "✨", // checkins_25
emoji: "🌟", // checkins_50
emoji: "💫", // checkins_100
emoji: "⭐", // checkins_250
emoji: "🏅", // checkins_500
emoji: "🥇", // checkins_1000
emoji: "🥈", // checkins_2000
emoji: "🥉", // checkins_5000
emoji: "👑", // checkins_10000
```

### Consistency
```swift
emoji: "📅", // perfect_week
emoji: "🗓️", // perfect_month
emoji: "🌅", // early_bird
emoji: "🌙", // night_owl
emoji: "⚔️", // weekend_warrior
emoji: "🎯", // all_habits_day
emoji: "💪", // comeback_kid
emoji: "🎖️", // no_skip_month
emoji: "🎯", // goal_crusher
emoji: "🚀", // overachiever
```

### Milestones
```swift
emoji: "📆", // one_week
emoji: "🗓️", // one_month
emoji: "📊", // three_months
emoji: "🎊", // six_months
emoji: "🎉", // one_year
emoji: "🥳", // two_years
emoji: "🎓", // habit_master
emoji: "❤️", // dedication
emoji: "🛡️", // resilient
emoji: "👑", // legendary_status
```

### Special
```swift
emoji: "🎆", // new_year_new_me
emoji: "🎂", // birthday_celebration
emoji: "🦘", // leap_day
emoji: "🌃", // midnight_warrior
emoji: "🎪", // multitasker
emoji: "⚡", // speed_demon
emoji: "🦋", // social_butterfly
emoji: "🗂️", // collector
emoji: "💎", // perfectionist
emoji: "🏆", // unlock_all
```

## 📝 Приклад застосування:

### БУЛО:
```swift
AchievementDefinition(
    id: "streak_7",
    titleKey: "achievement.streak_7.title",
    descriptionKey: "achievement.streak_7.description",
    icon: "flame.fill",
    color: "FF6F00",
    category: .streaks,
    requirement: 7,
    rarity: .uncommon
),
```

### СТАЛО:
```swift
AchievementDefinition(
    id: "streak_7",
    titleKey: "achievement.streak_7.title",
    descriptionKey: "achievement.streak_7.description",
    icon: "flame.fill",
    emoji: "🔥",  // 👈 ДОДАТИ ЦЕЙ РЯДОК
    color: "FF6F00",
    category: .streaks,
    requirement: 7,
    rarity: .uncommon
),
```

## 🎯 Швидка заміна

Якщо хочете швидко додати всі емодзі, використовуйте пошук та заміну в Xcode:

1. Відкрийте Achievement.swift
2. Для кожного ID знайдіть відповідний блок
3. Додайте рядок `emoji: "X",` після `icon:`

Або скопіюйте повний файл з наступного розділу ↓
