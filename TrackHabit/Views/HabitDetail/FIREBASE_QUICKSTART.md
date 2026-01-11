# 🚀 Firebase Quick Start (5 хвилин)

## Швидке налаштування Firebase Cloud Messaging

### 1️⃣ Firebase проект (2 хв)
```
1. https://console.firebase.google.com → Add project
2. iOS app → Bundle ID: твій з Xcode
3. Download GoogleService-Info.plist → додай в Xcode
```

### 2️⃣ Swift Package (1 хв)
```
Xcode → File → Add Package Dependencies
URL: https://github.com/firebase/firebase-ios-sdk
Вибери: FirebaseMessaging
```

### 3️⃣ Capabilities (30 сек)
```
Target → Signing & Capabilities → +
- Push Notifications
- Background Modes → Remote notifications
```

### 4️⃣ APNs Key (1 хв)
```
developer.apple.com → Keys → Create → APNs
Download .p8
Firebase Console → Settings → Cloud Messaging → Upload .p8
```

### 5️⃣ Код (30 сек)
Розкоментуй в `FirebaseNotificationManager.swift`:
- import Firebase, FirebaseMessaging
- configure() метод
- extensions в кінці

Створи `AppDelegate.swift`:
```swift
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseNotificationManager.shared.configure()
        UNUserNotificationCenter.current().delegate = FirebaseNotificationManager.shared
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
```

В головному App:
```swift
@main
struct TrackHabitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // ...
}
```

### 6️⃣ Тест
```
1. Запусти додаток
2. Settings → Push-повідомлення → Увімкнути
3. Скопіюй FCM токен (DEBUG секція)
4. Firebase Console → Cloud Messaging → Send test message
5. Paste token → Test
```

✅ **Готово!** Тепер можеш надсилати пуші всім юзерам!

---

**Повна інструкція:** Дивись `FIREBASE_SETUP_GUIDE.md`
