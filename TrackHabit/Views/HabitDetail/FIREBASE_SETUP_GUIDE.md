# 🔥 Firebase Cloud Messaging Setup Guide

Це повна інструкція для налаштування **безкоштовних** push-повідомлень через Firebase.

---

## 📋 Що вже готово

✅ `FirebaseNotificationManager.swift` - менеджер для роботи з FCM  
✅ `PushNotificationsSettingsView.swift` - UI для налаштувань  
✅ Локалізація (українська + англійська)  
✅ Секція в Settings  

---

## 🚀 Крок 1: Створи Firebase проект

1. Зайди на [Firebase Console](https://console.firebase.google.com)
2. Натисни **"Add project"** (Додати проект)
3. Назва: `Track Habit` (або своя)
4. Google Analytics: **можна вимкнути** (не обов'язково)
5. Натисни **"Create project"**

---

## 📱 Крок 2: Додай iOS додаток

1. В Firebase Console натисни **iOS** іконку
2. **Bundle ID**: `com.yourcompany.trackhabit` (бери з Xcode → Target → Bundle Identifier)
3. **App nickname**: `Track Habit iOS` (необов'язково)
4. **App Store ID**: залиш порожнім (поки що)
5. Натисни **"Register app"**

---

## 📥 Крок 3: Завантаж GoogleService-Info.plist

1. Firebase покаже кнопку **"Download GoogleService-Info.plist"**
2. Завантаж файл
3. В Xcode:
   - Перетягни файл в корінь проекту (поруч з `Info.plist`)
   - ✅ **Copy items if needed**
   - ✅ Вибери target проекту
4. Переконайся що файл з'явився в **Project Navigator**

---

## 📦 Крок 4: Додай Firebase SDK через Swift Package Manager

1. В Xcode: **File → Add Package Dependencies**
2. URL: 
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
3. Version: **Latest** (або `10.0.0` і вище)
4. Натисни **Add Package**
5. Вибери **тільки ці пакети**:
   - ✅ `FirebaseMessaging`
   - ✅ `FirebaseAnalytics` (опціонально, для статистики)
6. Натисни **Add Package**

⏳ Зачекай поки Xcode завантажить пакети (~1-2 хвилини)

---

## 🔧 Крок 5: Налаштуй Capabilities в Xcode

1. Вибери **Project** → **Target** → **Signing & Capabilities**
2. Натисни **"+ Capability"**
3. Додай:
   - ✅ **Push Notifications**
   - ✅ **Background Modes** → увімкни **"Remote notifications"**

---

## 💻 Крок 6: Розкоментуй код в FirebaseNotificationManager

Відкрий `FirebaseNotificationManager.swift` та розкоментуй:

### В `configure()`:
```swift
func configure() {
    // РОЗКОМЕНТУЙ:
    import Firebase
    import FirebaseMessaging
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    
    print("🔥 Firebase configured")
}
```

### В кінці файлу розкоментуй extension'и:
```swift
// РОЗКОМЕНТУЙ увесь блок з:
extension FirebaseNotificationManager: MessagingDelegate {
    // ...
}

extension FirebaseNotificationManager: UNUserNotificationCenterDelegate {
    // ...
}
```

---

## 🎯 Крок 7: Ініціалізуй Firebase в AppDelegate

Створи або відредагуй **AppDelegate**:

```swift
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Ініціалізуємо Firebase
        FirebaseNotificationManager.shared.configure()
        
        // Налаштовуємо delegates
        UNUserNotificationCenter.current().delegate = FirebaseNotificationManager.shared
        
        return true
    }
    
    // Обробка APNs token
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Firebase автоматично отримає токен через Messaging.messaging().apnsToken
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
    }
}
```

Потім в **головному App файлі**:

```swift
import SwiftUI

@main
struct TrackHabitApp: App {
    // Додай AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## 🔑 Крок 8: Налаштуй APNs ключ в Firebase (важливо!)

### Варіант A: APNs Authentication Key (рекомендовано)

1. Зайди на [Apple Developer Portal](https://developer.apple.com/account/resources/authkeys/list)
2. **Certificates, Identifiers & Profiles** → **Keys**
3. Натисни **"+"** → Створи новий ключ
4. Назва: `Firebase Push Key`
5. ✅ Увімкни **Apple Push Notifications service (APNs)**
6. Натисни **Continue** → **Register**
7. **Завантаж .p8 файл** (⚠️ можна завантажити тільки раз!)
8. Збережи:
   - Key ID (з екрану)
   - Team ID (верхній правий кут, біля твого імені)

### Тепер в Firebase:

1. Firebase Console → **Project Settings** (⚙️ зверху зліва)
2. **Cloud Messaging** таб
3. **Apple app configuration** → Знайди свій iOS додаток
4. **APNs Authentication Key** → Натисни **Upload**
5. Завантаж `.p8` файл
6. Введи:
   - **Key ID**
   - **Team ID**
7. Натисни **Upload**

✅ Готово! Тепер Firebase може надсилати пуші.

---

## 🧪 Крок 9: Тестування

### Локальне тестове повідомлення:
1. Запусти додаток в симуляторі або на реальному пристрої
2. Зайди в **Settings → Push-повідомлення**
3. Натисни **"Увімкнути повідомлення"**
4. Дозволь пуші в системному діалозі
5. В DEBUG розділі натисни **"🧪 Тестове повідомлення"**
6. Через 3 секунди з'явиться локальний пуш

### Firebase пуш (реальний тест):
1. В додатку зайди в **Settings → Push-повідомлення**
2. Натисни **"📋 Скопіювати FCM токен"** (тільки в DEBUG)
3. Зайди в [Firebase Console](https://console.firebase.google.com)
4. **Cloud Messaging** → **Send your first message**
5. Назва: `Тест` / Message: `Привіт з Firebase! 🔥`
6. Натисни **Send test message**
7. Вклей **FCM токен** з буфера
8. Натисни **Test**

📱 Повідомлення прийде на твій пристрій!

---

## 📬 Крок 10: Надсилай пуші всім юзерам

1. Firebase Console → **Cloud Messaging** → **New campaign**
2. **Create notification**:
   - Title: `🎉 Нова версія 2.0!`
   - Text: `Оновіть додаток для нових функцій`
3. Натисни **Next**
4. **Target**: Виберіть `All users` або свій iOS додаток
5. **Scheduling**: `Now` (або запланувати на потім)
6. Натисни **Review** → **Publish**

✨ Всі користувачі отримають повідомлення!

---

## 📊 Відстежування (опціонально)

Firebase автоматично показує:
- 📈 Скільки повідомлень доставлено
- 👆 Скільки юзерів відкрили
- ⏰ Кращий час для надсилання

Дивись в **Firebase Console → Cloud Messaging → Campaigns**

---

## 🎨 Типи повідомлень які можеш надсилати

### 1. Оновлення версії
```
Title: 🎉 Нова версія 2.0!
Body: Оновіть додаток для нових функцій
```

### 2. Нова фіча
```
Title: ✨ Нова фіча: Досягнення!
Body: Розблоковуйте бейджі за успіхи
```

### 3. Спеціальна пропозиція
```
Title: 🎁 -50% на Pro версію!
Body: Тільки сьогодні - безліміт звичок
```

### 4. Мотиваційне
```
Title: 🔥 Не забувай про свої звички!
Body: Твої цілі чекають на тебе
```

---

## 🔐 Приватність та GDPR

- ✅ Firebase токени **анонімні** (не прив'язані до email/імені)
- ✅ Ти **не збираєш** персональні дані
- ✅ Користувач **контролює** підписку (Settings)
- ✅ Юзер може **вимкнути** в будь-який момент

---

## 💰 Ціна: БЕЗКОШТОВНО ✅

Firebase Cloud Messaging **повністю безкоштовний**:
- ✅ Необмежена кількість повідомлень
- ✅ Необмежена кількість користувачів
- ✅ Аналітика включена
- ✅ Планування кампаній

---

## 🆘 Проблеми та рішення

### Повідомлення не приходять:
1. ✅ Перевір що `.p8` ключ завантажений в Firebase
2. ✅ Перевір `Bundle ID` (Xcode має збігатися з Firebase)
3. ✅ Переконайся що **Push Notifications** Capability додана
4. ✅ Запусти на **реальному пристрої** (симулятор не підтримує APNs)

### Помилка "No APNs token":
- Додай `Messaging.messaging().apnsToken = deviceToken` в AppDelegate

### FCM токен не генерується:
- Перевір що `GoogleService-Info.plist` в проекті
- Переконайся що `FirebaseApp.configure()` викликається

---

## 📚 Корисні посилання

- [Firebase Console](https://console.firebase.google.com)
- [Apple Developer Portal](https://developer.apple.com)
- [Firebase iOS Documentation](https://firebase.google.com/docs/cloud-messaging/ios/client)
- [APNs Keys Guide](https://developer.apple.com/documentation/usernotifications)

---

## ✅ Checklist

Перед запуском в продакшн:

- [ ] Firebase проект створено
- [ ] iOS додаток зареєстровано
- [ ] `GoogleService-Info.plist` додано в Xcode
- [ ] Firebase SDK встановлено
- [ ] Push Notifications Capability додана
- [ ] Background Modes → Remote notifications увімкнено
- [ ] APNs ключ (.p8) завантажений в Firebase
- [ ] AppDelegate налаштований
- [ ] Код в `FirebaseNotificationManager` розкоментований
- [ ] Тестовий пуш відправлено і отриманий
- [ ] UI в Settings працює

---

🎉 **Готово!** Тепер ти можеш надсилати пуші всім юзерам безкоштовно!

Питання? Пиши мені або дивись [Firebase Docs](https://firebase.google.com/docs) 🚀
