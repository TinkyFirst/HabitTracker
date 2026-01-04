# 📱 TrackHabit Widgets

<div align="center">

**Повноцінна система віджетів для вашого додатка відстеження звичок**

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![WidgetKit](https://img.shields.io/badge/WidgetKit-Ready-green.svg)](https://developer.apple.com/widgetkit/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

[Швидкий Старт](#-швидкий-старт) • [Документація](#-документація) • [Особливості](#-особливості) • [FAQ](#-faq)

</div>

---

## 🎯 Що Це?

**TrackHabit Widgets** - це колекція з 9 різних типів віджетів для вашого додатка відстеження звичок, включаючи:

- 📱 **Home Screen Widgets** - інтерактивні віджети на домашньому екрані
- 🔒 **Lock Screen Widgets** - компактні віджети для екрану блокування  
- 📺 **StandBy Mode Widgets** - оптимізовані віджети для режиму очікування

---

## ✨ Особливості

### 🎮 Інтерактивність
- ✅ Позначайте звички як виконані **прямо з віджета**
- ✅ Без необхідності відкривати додаток
- ✅ Миттєве оновлення даних

### 🔗 Deep Linking
- ✅ Тап на звичку відкриває деталі в додатку
- ✅ Швидка навігація між екранами
- ✅ Підтримка URL Scheme

### 🔄 Розумне Оновлення
- ✅ Автоматичне оновлення кожні 15 хвилин
- ✅ Миттєве оновлення при змінах в додатку
- ✅ Енергоефективність

### 🎨 Красивий Дизайн
- ✅ Підтримка Light/Dark режимів
- ✅ Градієнти та анімації
- ✅ Адаптивний layout для всіх розмірів

---

## 📦 Віджети

<table>
<tr>
<td width="33%" align="center">

### 📊 Today Progress
![Small Widget](https://via.placeholder.com/150x150/4A90E2/FFFFFF?text=75%25)

**Small Widget**  
Показує ваш прогрес дня

</td>
<td width="33%" align="center">

### 📝 Habit List
![Medium Widget](https://via.placeholder.com/320x150/9B59B6/FFFFFF?text=Habits)

**Medium/Large Widget**  
Список ваших звичок

</td>
<td width="33%" align="center">

### 🎯 Single Habit
![Small Widget](https://via.placeholder.com/150x150/50C878/FFFFFF?text=🧘)

**Small Widget**  
Фокус на одній звичці

</td>
</tr>

<tr>
<td width="33%" align="center">

### ⚡️ Interactive List
![Medium Widget](https://via.placeholder.com/320x150/F39C12/FFFFFF?text=Interactive)

**Medium/Large Widget**  
З кнопками "Done"

</td>
<td width="33%" align="center">

### 🔒 Lock Screen
![Circular Widget](https://via.placeholder.com/100x100/EC407A/FFFFFF?text=2/3)

**Circular/Rectangular**  
На екрані блокування

</td>
<td width="33%" align="center">

### 📺 StandBy Mode
![Large Widget](https://via.placeholder.com/320x300/1ABC9C/FFFFFF?text=StandBy)

**Medium/Large Widget**  
Для режиму очікування

</td>
</tr>
</table>

---

## 🚀 Швидкий Старт

### ⏱️ 5 хвилин до запуску!

```bash
1️⃣ Створити Widget Extension
   File → New → Target → Widget Extension

2️⃣ Налаштувати App Group
   Signing & Capabilities → App Groups

3️⃣ Додати URL Scheme
   Info → URL Types → +

4️⃣ Додати файли до target
   File Inspector → Target Membership

5️⃣ Build & Run!
   ⌘ + R
```

👉 **[Детальна Інструкція](QUICK_START.md)**

---

## 📚 Документація

| Документ | Опис |
|----------|------|
| 📖 [Quick Start](QUICK_START.md) | Швидкий старт за 5 хвилин |
| ✅ [Setup Checklist](WIDGET_SETUP_CHECKLIST.md) | Покроковий чекліст налаштування |
| 📘 [Full Documentation](WIDGETS_DOCUMENTATION.md) | Повна документація всіх віджетів |
| 🎨 [Visual Guide](WIDGET_VISUAL_GUIDE.md) | Візуальні приклади віджетів |
| ⚙️ [Configuration](WIDGET_CONFIGURATION.md) | Технічні налаштування |
| ❓ [FAQ](WIDGET_FAQ.md) | 50+ найчастіших питань |
| 📋 [Summary](WIDGET_SUMMARY.md) | Підсумок всього що створено |

---

## 🎯 Типи Віджетів

### 📱 Home Screen (4 типи)

#### 1. Today Progress Widget (Small)
Показує загальний прогрес дня з кільцем прогресу та кількістю виконаних звичок.

#### 2. Habit List Widget (Medium/Large)
Список ваших звичок з стріками. До 3 звичок (Medium) або 7 (Large).

#### 3. Single Habit Widget (Small)
Фокус на одній найважливішій звичці з великою іконкою та поточним стріком.

#### 4. Interactive Habit List Widget (Medium/Large) ⭐️
Інтерактивний список з кнопками "Done" що працюють без відкриття додатка!

---

### 🔒 Lock Screen (3 типи)

#### 5. Lock Screen Progress Widget
Прогрес на екрані блокування у трьох варіантах: Circular, Rectangular, Inline.

#### 6. Lock Screen Habit Counter
Простий лічильник виконаних звичок у компактному форматі.

#### 7. Lock Screen Streak Widget
Показує ваш найкращий поточний стрік для мотивації.

---

### 📺 StandBy Mode (2 типи)

#### 8. StandBy Habit Widget
Оптимізований для перегляду з відстані з великими іконками та текстом.

#### 9. StandBy Compact Widget
Мінімалістичний віджет з фокусом на прогресі.

---

## 💻 Технології

<table>
<tr>
<td align="center" width="20%">
<img src="https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png" width="50"><br>
<b>SwiftUI</b>
</td>
<td align="center" width="20%">
<img src="https://developer.apple.com/assets/elements/icons/widgetkit/widgetkit-96x96_2x.png" width="50"><br>
<b>WidgetKit</b>
</td>
<td align="center" width="20%">
<img src="https://developer.apple.com/assets/elements/icons/swift-data/swift-data-96x96_2x.png" width="50"><br>
<b>SwiftData</b>
</td>
<td align="center" width="20%">
<img src="https://developer.apple.com/assets/elements/icons/app-intents/app-intents-96x96_2x.png" width="50"><br>
<b>App Intents</b>
</td>
<td align="center" width="20%">
<img src="https://developer.apple.com/assets/elements/icons/xcode/xcode-96x96_2x.png" width="50"><br>
<b>Xcode 15+</b>
</td>
</tr>
</table>

---

## 📊 Статистика

<div align="center">

| 📈 Метрика | 🔢 Значення |
|-----------|------------|
| Файлів коду | 12 |
| Рядків коду | 1,600+ |
| Рядків документації | 4,000+ |
| Типів віджетів | 9 |
| Конфігурацій | 15+ |
| Час налаштування | ~7 хв |
| iOS версія | 17.0+ |

</div>

---

## 🎨 Дизайн

### Кольорова Палітра

```
🔵 Primary:   #4A90E2 (Blue)
🟣 Secondary: #9B59B6 (Purple)
🟠 Accent:    #F39C12 (Orange)
🟢 Success:   #50C878 (Green)
🔴 Error:     #FF6B6B (Red)
```

### Градієнти

```swift
LinearGradient(
    colors: [.blue, .purple],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

---

## 🔧 Вимоги

- **iOS:** 17.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+
- **Frameworks:** WidgetKit, AppIntents, SwiftData

---

## 📱 Приклад Використання

### Home Screen Layout

```
┌─────────────────────────────┐
│ 📱 Apps                     │
├─────────────────────────────┤
│ ⚡️ Interactive Widget      │
│ (Medium 4x2)                │
│                             │
│ 🧘 Meditate      [✓ Done]  │
│ 📚 Read          [ Done ]   │
│ 💪 Exercise      [ Done ]   │
├──────────┬──────────────────┤
│ 📊 Prog- │  🎯 Single      │
│    ress  │     Habit       │
│   (2x2)  │    (2x2)        │
└──────────┴──────────────────┘
```

---

## ✅ Checklist Налаштування

- [ ] Створити Widget Extension
- [ ] Налаштувати App Group в обох таргетах
- [ ] Додати URL Scheme
- [ ] Додати файли до Widget target
- [ ] Оновити App Group ID у SharedModelContainer
- [ ] Видалити дефолтний файл віджета
- [ ] Build & Run
- [ ] Протестувати віджети
- [ ] Додати на домашній екран
- [ ] Насолодитись! 🎉

---

## 🆘 Troubleshooting

### Віджет не показує дані?

```bash
1. Перевірити App Group
2. Додати хоча б одну звичку
3. Видалити і додати віджет знову
4. Перезапустити пристрій
```

### Кнопки не працюють?

```bash
1. Переконатися iOS 17+
2. Перевірити HabitIntents.swift в target
3. Clean Build Folder (⇧ + ⌘ + K)
4. Rebuild проект
```

👉 **[Більше рішень в FAQ](WIDGET_FAQ.md)**

---

## 🤝 Внесок

Цей проект створено як частина TrackHabit додатка. 

### Ідеї для покращення:

- [ ] Widget Configuration (вибір звичок)
- [ ] Live Activities
- [ ] Графіки прогресу
- [ ] Siri Shortcuts
- [ ] Control Center widgets (iOS 18+)

---

## 📄 Ліцензія

Цей код надається "as is" для використання у проекті TrackHabit.

---

## 🙏 Подяки

- **Apple** - за WidgetKit та App Intents
- **SwiftUI** - за чудовий UI framework
- **Вам** - за використання цих віджетів! 💙

---

## 📞 Підтримка

### Документація:
- 📖 [Quick Start](QUICK_START.md)
- ✅ [Setup Checklist](WIDGET_SETUP_CHECKLIST.md)
- ❓ [FAQ](WIDGET_FAQ.md)

### Проблеми:
1. Перевірити документацію
2. Прочитати FAQ
3. Clean Build Folder
4. Перезапустити Xcode

---

## 🎉 Готові Почати?

<div align="center">

### [📖 Читати Quick Start](QUICK_START.md)

### [✅ Відкрити Checklist](WIDGET_SETUP_CHECKLIST.md)

### [🚀 Почати Зараз!](#-швидкий-старт)

</div>

---

<div align="center">

**Створено з ❤️ для TrackHabit**

⭐️ Якщо вам сподобалось - поділіться з друзями!

[⬆ Повернутись на початок](#-trackhabit-widgets)

</div>

---

## 🗂️ Структура Файлів

```
TrackHabit/
├── 📱 App Files
│   ├── TrackHabitApp.swift (оновлено)
│   ├── MainTabView.swift (оновлено)
│   └── TodayView.swift (оновлено)
│
├── 🎯 Widget Files
│   ├── HabitWidgetBundle.swift
│   ├── HabitWidgetProvider.swift
│   ├── HabitWidgets.swift
│   ├── InteractiveHabitWidgets.swift
│   ├── LockScreenWidgets.swift
│   ├── StandByWidgets.swift
│   ├── HabitIntents.swift
│   ├── SharedModelContainer.swift
│   └── WidgetHelpers.swift
│
└── 📚 Documentation
    ├── README_WIDGETS.md (цей файл)
    ├── QUICK_START.md
    ├── WIDGET_SETUP_CHECKLIST.md
    ├── WIDGETS_DOCUMENTATION.md
    ├── WIDGET_VISUAL_GUIDE.md
    ├── WIDGET_CONFIGURATION.md
    ├── WIDGET_FAQ.md
    └── WIDGET_SUMMARY.md
```

---

## 🎯 Швидкі Посилання

- [Створити Widget Extension](#-швидкий-старт)
- [Налаштувати App Group](WIDGET_SETUP_CHECKLIST.md#крок-3-налаштування-app-group)
- [Додати URL Scheme](WIDGET_SETUP_CHECKLIST.md#крок-4-налаштування-url-scheme)
- [Troubleshooting](WIDGET_FAQ.md#troubleshooting)
- [FAQ - Часті Питання](WIDGET_FAQ.md)

---

<div align="center">

**Version 1.0** • **December 2024** • **iOS 17.0+**

Made with SwiftUI, WidgetKit, and ❤️

</div>
