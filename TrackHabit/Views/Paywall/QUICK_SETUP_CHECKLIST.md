# ✅ Quick Setup Checklist

## 🚀 Що вже готово в коді:

- ✅ Автоматична мова (uk/ru → Ukrainian, інші → English)
- ✅ StoreKit 2 integration
- ✅ Покупка підписок
- ✅ Відновлення покупок через iCloud
- ✅ UI кнопка "Restore Purchases"
- ✅ Alerts з результатами
- ✅ Haptic feedback
- ✅ Автоматичне завершення onboarding після відновлення
- ✅ Перевірка термінів підписок
- ✅ Real-time transaction listener
- ✅ SwiftData готовий до iCloud sync

---

## 📝 Що потрібно зробити:

### 1. Xcode (5 хвилин)
```
□ Target → Signing & Capabilities
□ + iCloud → CloudKit
□ + In-App Purchase
□ Перевірити Bundle ID
```

### 2. App Store Connect (20 хвилин)
```
□ Створити 3 In-App Products:
  □ com.trackhabit.pro.monthly ($9.99)
  □ com.trackhabit.pro.yearly ($69.99)
  □ com.trackhabit.pro.lifetime ($99.99)
□ Subscription Group: "Pro Membership"
□ Додати Localization (EN, UK)
□ Встановити ціни
```

### 3. Sandbox Testing (10 хвилин)
```
□ App Store Connect → Sandbox Testers
□ Створити тестовий Apple ID
□ На iPhone: Settings → App Store → Sandbox Account
□ Тестувати покупки (безкоштовно)
```

### 4. Тестування (15 хвилин)
```
□ Test Purchase → Success
□ Test Restore → Success
□ Test на 2 пристроях → Sync працює
□ Test expired subscription → Blocked
```

---

## 🎯 Швидкий старт (для нетерплячих):

### Крок 1: Xcode
1. Open project
2. Target → + Capability → iCloud + In-App Purchase
3. Build & Run

### Крок 2: App Store Connect
1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Your App → In-App Purchases → Add 3 products
3. Copy Product IDs from `StoreManager.swift`

### Крок 3: Test
1. Create Sandbox account
2. Run app → Go to Pricing
3. Try purchase → Should work!

---

## 📚 Детальна документація:

- **Повна інструкція**: `ICLOUD_AND_IAP_SETUP.md`
- **Пояснення коду**: `IAP_CODE_DOCUMENTATION.md`

---

## ⚡ Швидкі команди:

### Скинути onboarding:
```swift
UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
```

### Увімкнути Test Premium:
```swift
UserDefaults.standard.set(true, forKey: "isTestPremiumEnabled")
```

### Перевірити Pro статус:
```swift
print("Is Pro: \(StoreManager.shared.isProUser)")
```

---

## 🐛 Часті проблеми:

| Проблема | Рішення |
|----------|---------|
| "Cannot connect to iTunes Store" | Увійти в Sandbox Account |
| "Product not available" | Почекати 2-4 год після створення |
| iCloud не синхронізується | Увімкнути в Settings → iCloud |
| Покупка не відновлюється | Перевірити Product IDs |

---

## 📱 Контакти для допомоги:

- StoreKit Help: [developer.apple.com/help](https://developer.apple.com/help/)
- CloudKit Help: [developer.apple.com/support/cloudkit](https://developer.apple.com/support/cloudkit/)

---

**Час на setup: ~50 хвилин** ⏱️

Успіхів! 🚀
