# Інструкція з налаштування віджетів для TrackHabit

## Крок 1: Створення Widget Extension

1. В Xcode відкрийте ваш проект
2. Натисніть **File → New → Target**
3. Виберіть **Widget Extension**
4. Назвіть його `HabitWidget`
5. Зніміть галочку "Include Configuration Intent" (якщо потрібно)
6. Натисніть **Finish**

## Крок 2: Налаштування App Group

Для обміну даними між основним додатком і віджетами потрібно налаштувати App Group:

### У основному додатку:
1. Виберіть ваш головний таргет
2. Перейдіть на вкладку **Signing & Capabilities**
3. Натисніть **+ Capability**
4. Додайте **App Groups**
5. Натисніть **+** і створіть групу: `group.com.yourcompany.trackhabit`
   - Замініть `com.yourcompany` на ваш Bundle Identifier префікс

### У Widget Extension:
1. Виберіть таргет `HabitWidget`
2. Повторіть ті ж кроки
3. Виберіть **ту саму** App Group

## Крок 3: Налаштування URL Scheme

Для роботи deep linking потрібно додати URL scheme:

1. Виберіть головний таргет
2. Перейдіть на вкладку **Info**
3. Розгорніть **URL Types**
4. Натисніть **+** для додавання нового URL Type
5. У полі **Identifier** введіть: `com.yourcompany.trackhabit`
6. У полі **URL Schemes** введіть: `trackhabit`

## Крок 4: Додавання файлів до Widget Extension

Після створення Widget Extension, додайте наступні файли до таргета:

### Файли, які потрібно додати до Widget Extension target:
1. `HabitWidgetBundle.swift` (замінить початковий файл)
2. `HabitWidgetProvider.swift`
3. `HabitWidgets.swift`
4. `InteractiveHabitWidgets.swift`
5. `HabitIntents.swift`
6. `SharedModelContainer.swift`
7. `Habit.swift` (існуючий)
8. `CheckIn.swift` (існуючий)
9. `AppTheme.swift` (існуючий) - для Color extension

### Як додати файли до таргета:
1. Виберіть файл у Project Navigator
2. У File Inspector (праворуч) знайдіть секцію **Target Membership**
3. Поставте галочку біля `HabitWidget`

## Крок 5: Оновлення SharedModelContainer

У файлі `SharedModelContainer.swift` замініть:
```swift
groupContainer: .identifier("group.com.yourcompany.trackhabit")
```

На вашу реальну App Group назву.

## Крок 6: Оновлення MainTabView

Переконайтеся, що `MainTabView` підтримує параметр `selectedHabitId`:

```swift
struct MainTabView: View {
    @Binding var selectedHabitId: UUID?
    
    var body: some View {
        TabView {
            TodayView(selectedHabitId: $selectedHabitId)
                .tabItem {
                    Label("Today", systemImage: "checkmark.circle")
                }
            
            // ... інші таби
        }
    }
}
```

## Крок 7: Білд і запуск

1. Оберіть схему вашого основного додатка
2. Запустіть додаток на симуляторі або пристрої
3. Згорніть додаток
4. На домашньому екрані затисніть порожнє місце
5. Натисніть **+** у верхньому лівому куті
6. Знайдіть ваші віджети "TrackHabit"
7. Виберіть потрібний розмір і додайте на домашній екран

## Типи віджетів

### 1. Today's Progress (Малий)
- Показує загальний прогрес за день
- Кільце прогресу з відсотками
- Відображає скільки звичок виконано

### 2. Habit List (Середній/Великий)
- Список ваших звичок
- Можна переглянути статус кожного
- Тап на звичок відкриває деталі в додатку

### 3. Favorite Habit (Малий)
- Показує перший звичок зі списку
- Відображає стрік
- Швидкий доступ до звички

### 4. Interactive Habit List (Середній/Великий)
- Інтерактивний список звичок
- Можна позначати звичок як виконаний прямо з віджета
- Кнопка "Done" на кожній звичці

## Тестування

1. Додайте кілька звичок у додатку
2. Додайте віджети на домашній екран
3. Перевірте, що дані відображаються правильно
4. Спробуйте натиснути на віджет - повинен відкритися додаток
5. У інтерактивному віджеті спробуйте натиснути кнопку "Done"

## Можливі проблеми

### Віджет не показує дані:
- Перевірте, що App Group налаштована правильно
- Переконайтеся, що всі потрібні файли додані до Widget Extension target
- Перевірте, що `SharedModelContainer` використовує правильну App Group

### Deep linking не працює:
- Переконайтеся, що URL Scheme налаштований
- Перевірте, що `TrackHabitApp` має модифікатор `.handlesExternalEvents`
- Переконайтеся, що `TodayView` має метод `handleDeepLink`

### Інтерактивні кнопки не працюють:
- App Intents доступні тільки на iOS 16+
- Переконайтеся, що `HabitIntents.swift` додано до Widget Extension target
- Перевірте, що `ToggleHabitIntent` правильно зберігає дані

## Підтримка

Віджети підтримують:
- iOS 17.0+
- Light і Dark режими
- Різні розміри екранів
- Динамічне оновлення кожні 15 хвилин
- Ручне оновлення через Widget Center

## Наступні кроки

Можна додати:
- Конфігурацію віджета (вибір конкретних звичок)
- Live Activities для нагадувань
- StandBy режим
- Lock Screen віджети (тільки для малих віджетів)
- Siri Shortcuts інтеграцію
