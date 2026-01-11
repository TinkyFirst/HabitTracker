# About View - Quick Start Guide 🚀

## TL;DR

Новий AboutView готовий! Просто відкрийте Settings → About і насолоджуйтесь.

## Що це?

Повністю перероблена сторінка "Про додаток" з:
- ✨ Сучасним дизайном
- 🌍 Повною локалізацією (UK + EN)
- 🎨 Glass-ефектами
- 📊 Статистикою
- 🔗 Інтерактивними елементами

## Швидкий старт

### 1. Подивитись в Xcode Preview

```swift
// В SettingsView.swift вже є previews:
#Preview("About View - Light") {
    NavigationStack {
        AboutView()
    }
    .preferredColorScheme(.light)
}

#Preview("About View - Ukrainian") {
    NavigationStack {
        AboutView()
    }
    .onAppear {
        LanguageManager.shared.selectedLanguage = "uk"
    }
}
```

### 2. Запустити в Simulator

1. Відкрийте проект в Xcode
2. Виберіть iPhone 15 Pro (або інший)
3. Запустіть (⌘R)
4. Перейдіть: Settings → About
5. Прокрутіть та насолоджуйтесь!

### 3. Перемкнути мову

Settings → Language → Українська/English

### 4. Перемкнути тему

Settings → Theme → Light/Dark/System

## Структура файлів

```
/repo/
├── SettingsView.swift          # 🆕 Новий AboutView тут!
├── LanguageManager.swift       # 🔄 Оновлені переклади
├── ABOUT_VIEW_GUIDE.md         # 📖 Повна документація
├── ABOUT_VIEW_REDESIGN_SUMMARY.md  # 📋 Резюме змін
├── ABOUT_VIEW_TESTING_CHECKLIST.md # ✅ Чеклист
└── ABOUT_VIEW_QUICK_START.md   # 📄 Цей файл!
```

## Основні компоненти

### AboutView
Головна view з 8 секціями:
```swift
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack {
                heroSection        // 1. Іконка + назва + слоган
                descriptionSection // 2. Місія
                featuresSection    // 3. Фічі (5 карток)
                coreValuesSection  // 4. Цінності (3 пункти)
                statsSection       // 5. Статистика (2x2)
                actionsSection     // 6. Кнопки дій
                legalSection       // 7. Юридичні лінки
                footerSection      // 8. Footer
            }
        }
    }
}
```

### Допоміжні компоненти

```swift
// Картка фічі
FeatureCard(
    icon: "chart.line.uptrend.xyaxis",
    iconColor: .blue,
    title: "Progress Tracking",
    description: "Visualize your journey"
)

// Ряд цінності
ValueRow(
    icon: "lock.shield.fill",
    iconColor: .green,
    title: "Privacy First",
    description: "Your data stays private"
)

// Картка статистики
StatCard(
    value: "100K+",
    label: "Downloads",
    icon: "arrow.down.circle.fill",
    color: .blue
)

// Шерінг
ShareSheet(items: ["Check out Track Habit! 🚀"])
```

## Локалізація

### Додати новий текст

1. Відкрийте `LanguageManager.swift`
2. Додайте в `englishStrings`:
```swift
"about.newKey": "English text"
```
3. Додайте в `ukrainianStrings`:
```swift
"about.newKey": "Український текст"
```
4. Використовуйте:
```swift
Text("about.newKey".localized)
```

### Перевірити переклад

```swift
// Швидко в коді
LanguageManager.shared.selectedLanguage = "uk" // або "en"

// Або через UI
Settings → Language → Українська
```

## Налаштування

### Змінити статистику

В `AboutView.statsSection`:
```swift
StatCard(
    value: "200K+",  // 👈 Змініть тут
    label: "about.downloads".localized,
    icon: "arrow.down.circle.fill",
    color: .blue
)
```

### Додати нову фічу

В `AboutView.featuresSection`:
```swift
FeatureCard(
    icon: "sparkles",           // SF Symbol
    iconColor: .yellow,         // Колір
    title: "about.feature6Title".localized,
    description: "about.feature6Desc".localized
)
```

### Змінити колір фону

В `AboutView.backgroundGradient`:
```swift
LinearGradient(
    gradient: Gradient(colors: [
        // 👇 Змініть кольори тут
        colorScheme == .dark ? Color.black : Color(white: 0.95),
        colorScheme == .dark ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1),
        colorScheme == .dark ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
```

## Часті питання

### Q: Як тестувати ShareSheet в Simulator?
**A:** ShareSheet має обмеження в Simulator. Деякі опції (Instagram, Facebook) не показуються. Тестуйте на реальному пристрої.

### Q: Чому не показується rating prompt?
**A:** SKStoreReviewController має обмеження:
- Не працює в режимі розробки
- Apple контролює частоту показу
- Може не з'явитись взагалі
Це нормально!

### Q: Як змінити email для підтримки?
**A:** В `AboutView.actionsSection` змініть:
```swift
Link(destination: URL(string: "mailto:YOUR_EMAIL@example.com")!) {
    // ...
}
```

### Q: Як оновити версію додатку?
**A:** Версія береться автоматично з `Info.plist`. Змініть:
- CFBundleShortVersionString (1.0.0)
- CFBundleVersion (1)

### Q: Де змінити URL сайту?
**A:** В `AboutView.legalSection`:
```swift
Link(destination: URL(string: "https://YOUR-WEBSITE.com")!) {
    // ...
}
```

## Дебаг

### Перевірити локалізацію
```swift
// Додайте breakpoint або print
let currentLang = LanguageManager.shared.selectedLanguage
let testKey = "about.title".localized
print("Language: \(currentLang), Text: \(testKey)")
```

### Перевірити ShareSheet
```swift
// Додайте в ShareSheet
func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    print("ShareSheet opened with items: \(items)")
    return controller
}
```

### Перевірити рейтинг
```swift
private func rateApp() {
    print("Rating requested")
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        print("Scene found: \(scene)")
        SKStoreReviewController.requestReview(in: scene)
    } else {
        print("No scene found")
    }
}
```

## Корисні команди

### Build & Run
```bash
⌘R  # Build and Run
⌘B  # Build
⌘.  # Stop
```

### Preview
```bash
⌘⌥P  # Refresh Preview
⌘⌥⏎  # Show/Hide Preview
```

### Simulator
```bash
⌘K  # Open Keyboard
⌘⇧H # Home Button
⌘⇧L # Lock Screen
```

## Наступні кроки

1. ✅ Протестуйте на реальному пристрої
2. ✅ Перевірте обидві мови
3. ✅ Перевірте Dark/Light режими
4. ✅ Оновіть статистику (якщо є реальні дані)
5. ✅ Перевірте всі лінки
6. ✅ Протестуйте на різних розмірах екрану
7. ✅ Запросіть feedback від команди

## Ресурси

- 📖 [ABOUT_VIEW_GUIDE.md](ABOUT_VIEW_GUIDE.md) - Повна документація
- 📋 [ABOUT_VIEW_REDESIGN_SUMMARY.md](ABOUT_VIEW_REDESIGN_SUMMARY.md) - Що змінилось
- ✅ [ABOUT_VIEW_TESTING_CHECKLIST.md](ABOUT_VIEW_TESTING_CHECKLIST.md) - Чеклист тестування
- 🍎 [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) - Design guidelines
- 🎨 [SF Symbols](https://developer.apple.com/sf-symbols/) - Іконки Apple

## Підтримка

Якщо виникли питання:
1. Перевірте документацію вище
2. Подивіться код в `SettingsView.swift`
3. Запустіть Preview для швидкого тестування
4. Перевірте консоль на помилки

## Контрибюція

При внесенні змін:
1. Додайте переклади в обидві мови
2. Протестуйте Dark/Light режими
3. Перевірте на різних екранах
4. Оновіть документацію (якщо потрібно)
5. Запустіть всі Preview

## Ліцензія

Цей код є частиною Track Habit додатку.

---

**Готово! Розробляйте з радістю! 🎉**

Питання? Проблеми? Ідеї?
→ Відкрийте issue або напишіть команді!

**Зроблено з ❤️ в Україні 🇺🇦**
