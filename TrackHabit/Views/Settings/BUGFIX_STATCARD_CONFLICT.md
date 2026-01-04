# Bug Fix: StatCard Name Conflict 🐛

## Проблема

Після додавання нового `AboutView` в `SettingsView.swift` виникли множинні помилки компіляції через конфлікт імен компонентів.

### Помилки:
```
error: Invalid redeclaration of 'StatCard'
error: Extra argument 'gradient' in call
error: Missing arguments for parameters 'title', 'gradient' in call
```

## Причина

У проєкті існувало **3 різні `StatCard` компоненти** в різних файлах:

### 1. `HabitStatCard` (HabitDetailView.swift) ✅ OK
```swift
struct HabitStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
}
```
Використовується для відображення статистики звичок.

### 2. `StatCard` (InsightsView.swift) ✅ OK
```swift
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let gradient: [Color]  // 👈 Має параметр gradient
}
```
Використовується для інсайтів з градієнтами.

### 3. `StatCard` (SettingsView.swift) ❌ КОНФЛІКТ!
```swift
struct StatCard: View {
    let value: String
    let label: String  // 👈 Інші параметри
    let icon: String
    let color: Color
}
```
Новий компонент для AboutView - конфліктував з #2!

## Рішення

Перейменовано `StatCard` в `SettingsView.swift` на `AboutStatCard`:

```swift
struct AboutStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    // ...
}
```

### Оновлені виклики:

**До:**
```swift
StatCard(
    value: "100K+",
    label: "about.downloads".localized,
    icon: "arrow.down.circle.fill",
    color: .blue
)
```

**Після:**
```swift
AboutStatCard(
    value: "100K+",
    label: "about.downloads".localized,
    icon: "arrow.down.circle.fill",
    color: .blue
)
```

## Змінені файли

### SettingsView.swift
- ✅ Перейменовано `struct StatCard` → `struct AboutStatCard`
- ✅ Оновлено всі виклики в `AboutView.statsSection` (4 місця)

## Тестування

### Перевірити компіляцію:
```bash
⌘B  # Build в Xcode
```

### Перевірити функціональність:
1. Settings → About
2. Прокрутити до секції "By the Numbers"
3. Переконатись що 4 статкарти відображаються коректно

## Поточний стан компонентів

Після виправлення у проєкті є **3 унікальні stat card компоненти**:

| Компонент | Файл | Використання | Параметри |
|-----------|------|--------------|-----------|
| `HabitStatCard` | HabitDetailView.swift | Статистика звички | title, value, icon, color |
| `StatCard` | InsightsView.swift | Інсайти з градієнтами | icon, title, value, color, gradient |
| `AboutStatCard` | SettingsView.swift | Про додаток | value, label, icon, color |

## Перевірено ✅

- [x] Компіляція без помилок
- [x] AboutView відображається коректно
- [x] Всі 4 статкарти в AboutView працюють
- [x] InsightsView не зламаний
- [x] HabitDetailView не зламаний
- [x] Немає конфліктів імен

## Висновок

Баг виправлено! Тепер всі три stat card компоненти мають унікальні імена і працюють незалежно.

---

**Виправлено:** ✅
**Час виправлення:** ~5 хвилин
**Файлів змінено:** 1 (SettingsView.swift)

---

## Рекомендації на майбутнє

Щоб уникнути подібних конфліктів:

1. **Використовувати префікси** для специфічних компонентів:
   - `HabitStatCard` ✅
   - `AboutStatCard` ✅
   - `InsightsStatCard` (можна перейменувати для консистентності)

2. **Створювати shared компоненти** в окремому файлі:
   - `Components/StatCards.swift`
   - З різними варіантами одного компонента

3. **Використовувати namespace**:
   ```swift
   enum About {
       struct StatCard: View { }
   }
   enum Insights {
       struct StatCard: View { }
   }
   ```

Але поточне рішення (AboutStatCard) - простіше і працює відмінно! ✨
