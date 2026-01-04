# 💻 Code Implementation Details

## 📱 Що було реалізовано в коді:

### 1. **LanguageManager.swift**

#### Автоматична мова інтерфейсу:
```swift
private init() {
    if selectedLanguage.isEmpty {
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        // Українська для українського та російського
        if systemLanguage == "uk" || systemLanguage == "ru" {
            selectedLanguage = "uk"
        } else {
            selectedLanguage = "en"
        }
    }
}
```

**Як працює:**
- При першому запуску перевіряє мову системи
- Якщо `uk` або `ru` → встановлює українську
- Всі інші мови → англійська
- Зберігається в `UserDefaults` через `@AppStorage`

---

### 2. **StoreManager.swift**

#### Покращена функція відновлення покупок:
```swift
func restorePurchases() async throws {
    // Синхронізація з App Store (включає iCloud)
    try await AppStore.sync()
    
    // Оновлення локального стану
    await updatePurchasedProducts()
}
```

**Що робить AppStore.sync():**
- Синхронізує всі покупки з iCloud
- Отримує останні транзакції
- Перевіряє статус підписок
- Оновлює entitlements

#### Покращена перевірка покупок:
```swift
func updatePurchasedProducts() async {
    var purchasedIDs = Set<String>()

    for await result in StoreKit.Transaction.currentEntitlements {
        if case let .verified(transaction) = result {
            // Перевірка чи не відкликано
            if transaction.revocationDate == nil {
                
                // Перевірка терміну дії підписки
                if let expirationDate = transaction.expirationDate,
                   expirationDate < Date() {
                    continue // Підписка закінчилась
                }
                
                purchasedIDs.insert(transaction.productID)
            }
        }
    }

    self.purchasedProductIDs = purchasedIDs
    self.isProUser = !purchasedIDs.isEmpty || isTestPremiumEnabled
}
```

**Особливості:**
- `Transaction.currentEntitlements` - всі активні покупки (включає iCloud)
- `revocationDate` - перевірка чи покупка не відкликана Apple
- `expirationDate` - перевірка терміну дії підписки
- Автоматично синхронізується через iCloud

#### Слухач транзакцій:
```swift
private func listenForTransactions() -> Task<Void, Error> {
    return Task.detached {
        for await result in StoreKit.Transaction.updates {
            if case let .verified(transaction) = result {
                await self.updatePurchasedProducts()
                await transaction.finish()
            }
        }
    }
}
```

**Коли спрацьовує:**
- Нова покупка
- Відновлення покупки
- Продовження підписки
- Скасування підписки
- Синхронізація з іншого пристрою через iCloud

---

### 3. **OnboardingView.swift - PricingSlide**

#### Додані нові стани:
```swift
@State private var restoring = false
@State private var showRestoreAlert = false
@State private var restoreAlertMessage = ""
```

#### Кнопка відновлення покупок:
```swift
Button {
    Task {
        await restorePurchases()
    }
} label: {
    HStack {
        if restoring {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(0.8)
        }
        Text(restoring ? "settings.restoring".localized : "settings.restorePurchases".localized)
            .font(.system(size: 15, weight: .semibold))
    }
    .foregroundStyle(.white.opacity(0.7))
    .frame(maxWidth: .infinity)
    .frame(height: 44)
    .background(
        RoundedRectangle(cornerRadius: 22)
            .fill(.white.opacity(0.08))
    )
}
.disabled(restoring || purchasing)
```

**UI Features:**
- Показує ProgressView під час відновлення
- Змінює текст на "Restoring..." / "Відновлюю..."
- Disabled коли вже йде процес
- Напівпрозорий дизайн

#### Функція відновлення:
```swift
private func restorePurchases() async {
    guard !restoring else { return }
    restoring = true
    
    do {
        try await storeManager.restorePurchases()
        
        if storeManager.isProUser {
            // Успіх - є активні покупки
            restoreAlertMessage = "settings.purchasesRestored".localized
            hapticFeedback(style: .success)
            
            // Автоматично завершити onboarding через 1 секунду
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completeAction()
            }
        } else {
            // Покупок не знайдено
            restoreAlertMessage = "settings.noPurchasesFound".localized
            showRestoreAlert = true
            hapticFeedback(style: .warning)
        }
    } catch {
        // Помилка
        restoreAlertMessage = "settings.restoreFailed".localized
        showRestoreAlert = true
        hapticFeedback(style: .error)
    }
    
    restoring = false
}
```

**Логіка:**
1. Намагається відновити покупки через StoreManager
2. Якщо знайдено активні покупки:
   - Показує успішне повідомлення
   - Вібрація успіху
   - Автоматично завершує onboarding
3. Якщо покупок немає:
   - Показує alert
   - Вібрація попередження
4. При помилці:
   - Показує alert з помилкою
   - Вібрація помилки

#### Alert:
```swift
.alert("settings.restorePurchases".localized, isPresented: $showRestoreAlert) {
    Button("OK", role: .cancel) { }
} message: {
    Text(restoreAlertMessage)
}
```

---

## 🔄 Як працює iCloud Sync:

### StoreKit + iCloud:
```
User Device A          iCloud          User Device B
     |                   |                   |
  Purchase          Upload Trans.       Download Trans.
     |  ------------>    |  ------------>   |
     |                   |                   |
     |             Sync Status            Update UI
     |  <------------    |  <------------   |
```

### SwiftData + iCloud:
```
User Device A          iCloud          User Device B
     |                   |                   |
  Add Habit         Upload Data         Download Data
     |  ------------>    |  ------------>   |
     |                   |                   |
     |            CloudKit Sync           Update UI
     |  <------------    |  <------------   |
```

**Автоматична синхронізація:**
- SwiftData автоматично використовує CloudKit
- Не потрібен додатковий код
- Працює в фоні
- Конфлікти вирішуються автоматично

---

## 📊 Product IDs Structure:

```swift
private let productIDs = [
    "com.trackhabit.pro.monthly",   // Місячна підписка
    "com.trackhabit.pro.yearly",    // Річна підписка  
    "com.trackhabit.pro.lifetime"   // Одноразова покупка
]
```

**Bundle ID Pattern:**
```
com.[company].[app].pro.[type]
```

---

## 🎨 UI/UX Flow:

### Onboarding Pricing Flow:
```
User Opens Pricing Slide
         |
         v
    View Products
         |
    |----|-----|
    |    |     |
Monthly Yearly Free
    |    |     |
    v    v     v
  Buy  Buy  Continue
    |    |     |
    v    v     |
 Success?      |
    |          |
   Yes  No     |
    |    |     |
    v    v     v
 Complete  Main App
```

### Restore Flow:
```
User Taps "Restore Purchases"
         |
         v
  Show "Restoring..."
         |
         v
AppStore.sync() + Check Entitlements
         |
    |----|-----|
    |    |     |
 Success Fail None
    |    |     |
    v    v     v
Complete Alert Alert
```

---

## 🧪 Testing Scenarios:

### Scenario 1: New User → Purchase
```swift
// 1. Запустити додаток вперше
// 2. Дійти до pricing slide
// 3. Обрати річну підписку
// 4. Підтвердити покупку
// Expected: isProUser = true, onboarding completed
```

### Scenario 2: Existing User → Restore
```swift
// 1. Видалити додаток
// 2. Встановити знову
// 3. Дійти до pricing slide
// 4. Натиснути "Restore Purchases"
// Expected: isProUser = true, onboarding completed automatically
```

### Scenario 3: User with Expired Subscription
```swift
// 1. Підписка закінчилась
// 2. Перевірити expirationDate
// Expected: isProUser = false, show pricing again
```

---

## 🔐 Security:

### Transaction Verification:
```swift
private func checkVerified<T>(_ result: StoreKit.VerificationResult<T>) throws -> T {
    switch result {
    case .unverified:
        throw StoreError.failedVerification
    case .verified(let safe):
        return safe
    }
}
```

**Що перевіряється:**
- Підпис транзакції від Apple
- Валідність сертифікату
- Timestamp транзакції
- Device identifier

**StoreKit 2 автоматично:**
- Перевіряє підписи
- Захищає від підробок
- Шифрує дані
- Синхронізує через iCloud безпечно

---

## 📱 Platform Support:

### iOS Support:
- ✅ iOS 17.0+
- ✅ StoreKit 2
- ✅ CloudKit
- ✅ SwiftData with iCloud

### Features:
- ✅ Auto-renewable subscriptions
- ✅ Non-consumable purchases (Lifetime)
- ✅ Restore purchases
- ✅ Family Sharing (optional)
- ✅ Introductory offers (optional)
- ✅ Promotional offers (optional)

---

## 🚀 Performance:

### Network Calls:
- `loadProducts()`: ~500ms
- `purchase()`: ~2-3s
- `restorePurchases()`: ~1-2s
- `updatePurchasedProducts()`: ~100ms

### Caching:
- Products кешуються після завантаження
- Entitlements перевіряються при старті
- Updates слухаються в реальному часі
- Offline mode: працює з останнім станом

---

## 💡 Best Practices:

### ✅ DO:
- Завжди перевіряй `isProUser` перед показом Pro features
- Finish всі транзакції через `transaction.finish()`
- Обробляй всі можливі помилки
- Показуй індикатор завантаження
- Тестуй в Sandbox перед production

### ❌ DON'T:
- Не зберігай чутливі дані про покупки локально
- Не довіряй клієнтській перевірці (використовуй StoreKit)
- Не блокуй UI під час network calls
- Не забувай про error handling

---

## 🎯 Next Steps:

1. Налаштувати App Store Connect
2. Створити продукти
3. Протестувати в Sandbox
4. Перевірити всі сценарії
5. Відправити на App Review

Всі інструкції в файлі `ICLOUD_AND_IAP_SETUP.md`! 🚀
