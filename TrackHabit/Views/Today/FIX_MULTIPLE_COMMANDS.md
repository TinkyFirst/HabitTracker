# 🔧 Виправлення "Multiple commands produce"

## Проблема:
```
Multiple commands produce 'HabitWidgetBundle.stringsdata'
```

## ✅ Рішення:

### Спосіб 1: Через Build Phases (Найшвидший)

1. **Відкрити Project Settings:**
   - Project Navigator → Клік на проект (синя іконка)
   
2. **Вибрати Target:**
   - Targets → `HabitWidgetExtension`
   
3. **Відкрити Build Phases:**
   - Вкладка Build Phases
   
4. **Розгорнути Compile Sources:**
   - Шукати `HabitWidgetBundle.swift`
   - Якщо є **ДВА** однакових файли → видалити один (кнопка `-`)
   
5. **Clean Build:**
   ```
   ⇧ + ⌘ + K
   ⌘ + B
   ```

---

### Спосіб 2: Видалити і додати знову

1. **Видалити HabitWidgetBundle.swift з проекту:**
   - Клік правою → Delete
   - **Remove Reference** (не Move to Trash!)
   
2. **Додати знову:**
   - Drag & Drop файл назад в Project Navigator
   - Діалог "Choose options": 
     - ☐ Copy items if needed
     - ☑ Create groups
     - Targets: ☑ HabitWidgetExtension ТІЛЬКИ!
   
3. **Clean Build:**
   ```
   ⇧ + ⌘ + K
   ⌘ + B
   ```

---

### Спосіб 3: Перевірити Derived Data

Іноді проблема в кеші:

1. **Закрити Xcode**

2. **Видалити Derived Data:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
   
   Або через Xcode:
   ```
   Xcode → Settings → Locations → Derived Data → Стрілка
   Видалити папку TrackHabit-xxx
   ```

3. **Відкрити Xcode і Build:**
   ```
   ⌘ + B
   ```

---

### Спосіб 4: Перевірити Duplicate Files

Можливо файл доданий двічі в різних місцях:

1. **Project Navigator → Пошук:**
   - ⌘ + F
   - Шукати: `HabitWidgetBundle`
   
2. **Перевірити чи немає дублікатів:**
   - Якщо є два файли з однаковою назвою → видалити один

---

## 🔍 Перевірка Правильності:

### Build Phases → Compile Sources має містити ТІЛЬКИ:

```
✅ HabitWidgetBundle.swift (ОДИН РАЗ)
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

### НЕ має бути:

```
❌ TrackHabitApp.swift
❌ MainTabView.swift
❌ TodayView.swift
❌ Дублікатів будь-яких файлів
```

---

## ⚠️ Про "Swift tasks not blocking":

Це попередження, не критична помилка.

### Якщо хочете виправити:

**Build Settings → HabitWidgetExtension:**
```
ENABLE_USER_SCRIPT_SANDBOXING = NO
```

Або:
1. Target → HabitWidgetExtension → Build Settings
2. Пошук: `User Script Sandboxing`
3. Встановити: `NO`

---

## 🎯 Найчастіші Причини:

1. ✅ Файл доданий двічі в Compile Sources
2. ✅ Файл існує двічі в проекті (різні папки)
3. ✅ Проблема з Derived Data (кеш)
4. ✅ Файл в Copy Bundle Resources замість Compile Sources

---

## 🚀 Після Виправлення:

```bash
1. ⇧ + ⌘ + K    (Clean Build Folder)
2. ⌘ + B         (Build)
3. ⌘ + R         (Run)
```

Помилка має зникнути! ✅

---

**Оновлено:** 28 грудня 2024
