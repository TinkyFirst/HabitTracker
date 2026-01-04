# 🎯 Target Membership Guide

## ⚠️ ВАЖЛИВО: Налаштування Target Membership

Якщо ви бачите помилку **'main' attribute can only apply to one type in a module**, це означає що файли додані до неправильних targets.

---

## 📋 Правильна Конфігурація

### 1️⃣ ТІЛЬКИ TrackHabit (основний додаток):

```
✅ TrackHabitApp.swift          (@main для додатка)
✅ MainTabView.swift
✅ TodayView.swift
✅ AddHabitView.swift
✅ InsightsView.swift
✅ SettingsView.swift
✅ PaywallView.swift
✅ OnboardingView.swift
✅ NotificationManager.swift
✅ GlassCard.swift
✅ ProgressRing.swift
✅ StreakChip.swift
```

---

### 2️⃣ ТІЛЬКИ HabitWidget (Widget Extension):

```
✅ HabitWidgetBundle.swift       (@main для віджетів)
```

**⚠️ Це ЄДИНИЙ файл який має бути ТІЛЬКИ у Widget target!**

---

### 3️⃣ ОБА Targets (TrackHabit + HabitWidget):

#### Models:
```
✅ Habit.swift
✅ CheckIn.swift
✅ HabitTemplate.swift
```

#### Shared Code:
```
✅ AppTheme.swift
✅ SharedModelContainer.swift
```

#### Widget Code:
```
✅ HabitWidgetProvider.swift
✅ HabitWidgets.swift
✅ InteractiveHabitWidgets.swift
✅ LockScreenWidgets.swift
✅ StandByWidgets.swift
✅ HabitIntents.swift
✅ WidgetHelpers.swift
```

---

## 🔧 Як Виправити Помилку

### Крок 1: Знайти проблемний файл
Файл з помилкою: **HabitWidgetBundle.swift**

### Крок 2: Відкрити File Inspector
1. Клікнути на `HabitWidgetBundle.swift` у Project Navigator
2. Відкрити File Inspector (праворуч, іконка 📄)

### Крок 3: Налаштувати Target Membership
У секції **Target Membership**:

```
☐ TrackHabit        ← ЗНЯТИ галочку
☑ HabitWidget       ← ЗАЛИШИТИ галочку
```

### Крок 4: Clean Build
```bash
Shift + Command + K    (Clean Build Folder)
Command + B            (Build)
```

---

## ✅ Checklist

Перевірте наступне:

### TrackHabitApp.swift:
- [ ] @main присутній
- [ ] Target Membership: ☑ TrackHabit, ☐ HabitWidget

### HabitWidgetBundle.swift:
- [ ] @main присутній
- [ ] Target Membership: ☐ TrackHabit, ☑ HabitWidget

### Habit.swift:
- [ ] Target Membership: ☑ TrackHabit, ☑ HabitWidget

### SharedModelContainer.swift:
- [ ] Target Membership: ☑ TrackHabit, ☑ HabitWidget

---

## 🐛 Інші Можливі Помилки

### "Cannot find 'Habit' in scope" у віджетах:
```
Рішення: Додати Habit.swift до HabitWidget target
```

### "Cannot find 'SharedModelContainer' in scope":
```
Рішення: Додати SharedModelContainer.swift до HabitWidget target
```

### "Cannot find 'AppTheme' in scope":
```
Рішення: Додати AppTheme.swift до HabitWidget target
```

### Віджети не показують дані:
```
Рішення: 
1. Перевірити App Group налаштування
2. Перевірити що всі Model файли у Widget target
```

---

## 📱 Як Перевірити

### 1. Build основного додатка:
```bash
Scheme: TrackHabit
Command + B
```
Має компілюватись без помилок.

### 2. Build Widget Extension:
```bash
Scheme: HabitWidget
Command + B
```
Має компілюватись без помилок.

### 3. Run додаток:
```bash
Scheme: TrackHabit
Command + R
```

---

## 🎯 Швидка Довідка

| Файл | TrackHabit | HabitWidget |
|------|-----------|-------------|
| TrackHabitApp.swift | ✅ | ❌ |
| HabitWidgetBundle.swift | ❌ | ✅ |
| Habit.swift | ✅ | ✅ |
| TodayView.swift | ✅ | ❌ |
| HabitWidgets.swift | ❌ | ✅ |
| SharedModelContainer.swift | ✅ | ✅ |

---

## 💡 Порада

Якщо не впевнені - краще додати файл до ОБОХ targets (окрім файлів з @main).

Виняток: Файли з `@main` мають бути тільки у ОДНОМУ target кожен!

---

**Створено:** 28 грудня 2024  
**Версія:** 1.0
