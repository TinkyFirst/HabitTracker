# 🎯 Швидкий Checklist - Додати Файли до HabitWidget Target

## ⚡️ ОБОВ'ЯЗКОВО додати до HabitWidget target:

Для кожного файлу нижче:
1. Клікнути на файл у Project Navigator
2. File Inspector (праворуч) → Target Membership
3. Поставити галочку біля `HabitWidget`

---

### 📋 Основні Файли Віджетів:

- [ ] **HabitWidgetBundle.swift** (ТІЛЬКИ HabitWidget, БЕЗ TrackHabit!)
- [ ] **HabitWidgetProvider.swift** ⚠️ ВАЖЛИВО!
- [ ] **HabitWidgets.swift**
- [ ] **InteractiveHabitWidgets.swift**
- [ ] **LockScreenWidgets.swift**
- [ ] **StandByWidgets.swift**
- [ ] **HabitIntents.swift**
- [ ] **WidgetHelpers.swift**

---

### 📦 Спільні Файли (ОБА targets):

- [ ] **Habit.swift** (TrackHabit ✅ + HabitWidget ✅)
- [ ] **CheckIn.swift** (TrackHabit ✅ + HabitWidget ✅)
- [ ] **AppTheme.swift** (TrackHabit ✅ + HabitWidget ✅)
- [ ] **SharedModelContainer.swift** (TrackHabit ✅ + HabitWidget ✅)
- [ ] **HabitTemplate.swift** (TrackHabit ✅ + HabitWidget ✅)

---

## 🚨 Найчастіша Помилка:

Якщо бачите:
```
Cannot find 'HabitWidgetProvider' in scope
Cannot find 'HabitSnapshot' in scope
Cannot find 'HabitWidgetEntry' in scope
```

**Це означає:** `HabitWidgetProvider.swift` НЕ доданий до HabitWidget target!

---

## ✅ Як Додати:

### Спосіб 1: Через File Inspector
1. Клікнути на файл
2. File Inspector (праворуч, іконка 📄)
3. Секція "Target Membership"
4. Поставити галочку біля `HabitWidget`

### Спосіб 2: Через Project Settings
1. Project Navigator → Виберіть проект (синя іконка)
2. Targets → HabitWidget
3. Build Phases → Compile Sources
4. Натиснути `+`
5. Додати потрібні файли

---

## 🎯 Правильна Конфігурація:

### HabitWidgetProvider.swift:
```
Target Membership:
  ☐ TrackHabit        ← ЗНЯТИ
  ☑ HabitWidget       ← ПОСТАВИТИ
```

### Habit.swift, CheckIn.swift, AppTheme.swift:
```
Target Membership:
  ☑ TrackHabit        ← ЗАЛИШИТИ
  ☑ HabitWidget       ← ДОДАТИ
```

### HabitWidgetBundle.swift:
```
Target Membership:
  ☐ TrackHabit        ← ЗНЯТИ!
  ☑ HabitWidget       ← ПОСТАВИТИ
```

---

## 🔍 Як Перевірити:

### Відкрийте HabitWidget Build Phases:
1. Project Navigator → Клік на проект
2. Targets → HabitWidget
3. Build Phases → Compile Sources

### Має бути у списку:
```
✅ HabitWidgetBundle.swift
✅ HabitWidgetProvider.swift
✅ HabitWidgets.swift
✅ InteractiveHabitWidgets.swift
✅ LockScreenWidgets.swift
✅ StandByWidgets.swift
✅ HabitIntents.swift
✅ WidgetHelpers.swift
✅ Habit.swift
✅ CheckIn.swift
✅ AppTheme.swift
✅ SharedModelContainer.swift
```

---

## ⚠️ НЕ додавати до HabitWidget:

```
❌ TrackHabitApp.swift
❌ MainTabView.swift
❌ TodayView.swift
❌ InsightsView.swift
❌ SettingsView.swift
❌ AddHabitView.swift
❌ HabitDetailView.swift
❌ PaywallView.swift
❌ OnboardingView.swift
❌ NotificationManager.swift
```

---

## 🚀 Після Додавання:

```bash
1. ⇧ + ⌘ + K    (Clean Build Folder)
2. ⌘ + B         (Build)
```

Помилки мають зникнути! ✅

---

**Найважливіше:** `HabitWidgetProvider.swift` ОБОВ'ЯЗКОВО має бути у HabitWidget target!
