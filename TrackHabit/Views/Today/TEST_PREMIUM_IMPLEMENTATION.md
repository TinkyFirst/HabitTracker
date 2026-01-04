# Test Premium Implementation

## Огляд
Додано функціонал тестового преміума для розробки та тестування без необхідності справжніх покупок.

## Зміни

### 1. SettingsView.swift
**Додано нову секцію "Development":**
- ✅ Toggle для активації/деактивації тестового преміума
- ✅ Візуальний індикатор зі значком корони (👑)
- ✅ Описовий текст "Enable all Pro features for testing"
- ✅ Purple колір для акценту

**Компонент TestPremiumToggle:**
```swift
struct TestPremiumToggle: View {
    @AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Toggle(isOn: $isTestPremiumEnabled) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.purple)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Test Premium Mode")
                    Text("Enable all Pro features for testing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .tint(.purple)
        .onChange(of: isTestPremiumEnabled) { _, _ in
            StoreManager.shared.checkTestPremium()
        }
    }
}
```

**ProStatusRow оновлено:**
- ✅ Перевіряє як тестовий преміум, так і справжній
- ✅ Показує "Pro Member" якщо активний будь-який преміум

### 2. StoreManager.swift
**Додано підтримку тестового преміума:**
- ✅ Computed property `isTestPremiumEnabled` читає з UserDefaults
- ✅ Метод `updatePurchasedProducts()` враховує тестовий преміум
- ✅ Публічний метод `checkTestPremium()` для оновлення статусу

```swift
private var isTestPremiumEnabled: Bool {
    UserDefaults.standard.bool(forKey: "isTestPremiumEnabled")
}

func updatePurchasedProducts() async {
    // ... existing code ...
    self.isProUser = !purchasedIDs.isEmpty || isTestPremiumEnabled
}

func checkTestPremium() {
    Task {
        await updatePurchasedProducts()
    }
}
```

### 3. AddHabitView.swift
**Оновлено перевірку ліміту звичок:**
- ✅ Додано `@AppStorage("isTestPremiumEnabled")`
- ✅ `isFreeUser` тепер перевіряє обидва джерела преміума
- ✅ З тестовим преміумом можна додавати необмежену кількість звичок

```swift
@AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false

var isFreeUser: Bool {
    !isTestPremiumEnabled && !StoreManager.shared.isProUser
}
```

### 4. InsightsView.swift
**Оновлено відображення преміум інсайтів:**
- ✅ Додано `@AppStorage("isTestPremiumEnabled")`
- ✅ Computed property `isProUser` для перевірки
- ✅ Advanced insights доступні з тестовим преміумом

```swift
@AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false

var isProUser: Bool {
    isTestPremiumEnabled || StoreManager.shared.isProUser
}
```

## Як використовувати

### Активація тестового преміума:
1. Відкрийте **Settings** (⚙️)
2. Прокрутіть до секції **"Development"**
3. Увімкніть toggle **"Test Premium Mode"**
4. ✅ Готово! Всі Pro функції активовані

### Що розблоковується:
- ✅ **Необмежена кількість звичок** (замість ліміту 3)
- ✅ **Advanced Insights** в InsightsView
- ✅ **Pro Member** статус в Settings
- ✅ Всі майбутні преміум фічі

### Деактивація:
1. Відкрийте **Settings**
2. Вимкніть toggle **"Test Premium Mode"**
3. ✅ Повернення до безкоштовної версії

## Технічні деталі

### Збереження стану:
- Використовується `@AppStorage` з ключем `"isTestPremiumEnabled"`
- Зберігається в `UserDefaults.standard`
- Персистентне між запусками додатку

### Синхронізація:
- При зміні toggle викликається `StoreManager.shared.checkTestPremium()`
- Оновлюється `isProUser` в StoreManager
- Всі view автоматично реагують через `@Published`

### Пріоритет перевірок:
1. Перевіряється `isTestPremiumEnabled`
2. Якщо false, перевіряється справжня підписка
3. Логіка OR: `isTestPremiumEnabled || StoreManager.shared.isProUser`

## Переваги рішення

✅ **Просто**: Один toggle в налаштуваннях
✅ **Очевидно**: Чітко позначено як "Development"
✅ **Безпечно**: Не впливає на production purchases
✅ **Персистентне**: Зберігається між запусками
✅ **Гнучко**: Легко вимкнути/увімкнути
✅ **Централізовано**: Всі перевірки в одному місці

## Важливо для production

⚠️ Перед релізом:
- [ ] Видалити секцію "Development" з SettingsView
- [ ] Видалити компонент `TestPremiumToggle`
- [ ] Або додати умову `#if DEBUG` навколо секції

```swift
#if DEBUG
Section("Development") {
    TestPremiumToggle()
}
#endif
```

## Тестування

### Сценарій 1: Активація преміума
1. Відкрийте Settings
2. Увімкніть "Test Premium Mode"
3. Спробуйте додати 4+ звичок ✅
4. Перевірте Advanced Insights ✅

### Сценарій 2: Деактивація преміума
1. Додайте 4+ звички з увімкненим преміумом
2. Вимкніть "Test Premium Mode"
3. Спробуйте додати нову звичку ❌ (має показати paywall)
4. Advanced Insights повинні зникнути

### Сценарій 3: Персистентність
1. Увімкніть "Test Premium Mode"
2. Закрийте додаток (force quit)
3. Відкрийте знову
4. Преміум повинен залишитись активним ✅

## Майбутні преміум фічі

Коли додаватимете нові преміум функції, використовуйте таку саму перевірку:

```swift
@AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false

var isProUser: Bool {
    isTestPremiumEnabled || StoreManager.shared.isProUser
}

// Або прямо в view:
if isTestPremiumEnabled || StoreManager.shared.isProUser {
    // Premium feature
} else {
    // Paywall or limited version
}
```

---

**Статус**: ✅ Готово до використання
**Версія**: 1.0
**Дата**: 28 грудня 2025
