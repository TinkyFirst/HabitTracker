# ✅ Firebase Швидкий Checklist (для друку)

Роздрукуй або май під рукою під час налаштування.

---

## ☁️ FIREBASE CONSOLE

### 1. Створити проект
- [ ] Зайшов на https://console.firebase.google.com
- [ ] Add project → Назва: **Track Habit**
- [ ] Google Analytics: вимкнено (опціонально)
- [ ] Create project

### 2. Додати iOS додаток
- [ ] iOS іконка
- [ ] Bundle ID з Xcode (скопійований)
- [ ] Register app

### 3. Завантажити файл
- [ ] Download GoogleService-Info.plist
- [ ] Файл в Downloads/

---

## 📱 XCODE - ФАЙЛИ

### 4. Додати GoogleService-Info.plist
- [ ] Файл перетягнуто в папку проекту (з .swift файлами)
- [ ] ✅ Copy items if needed
- [ ] ✅ Create groups
- [ ] ✅ Add to targets: TrackHabit
- [ ] Finish
- [ ] Target Membership: ✅ TrackHabit (права панель)

### 5. Знайти Bundle ID
- [ ] Проект (синя іконка) → TARGET → General
- [ ] Bundle Identifier: записав/скопіював

---

## 📦 SWIFT PACKAGES

### 6. Додати Firebase SDK
- [ ] File → Add Package Dependencies
- [ ] URL: https://github.com/firebase/firebase-ios-sdk
- [ ] Add Package
- [ ] ✅ FirebaseMessaging
- [ ] Add Package
- [ ] Дочекався завершення (~1-3 хв)

---

## ⚙️ CAPABILITIES

### 7. Push Notifications
- [ ] Проект → TARGET → Signing & Capabilities
- [ ] + Capability
- [ ] Push Notifications
- [ ] Додано ✅

### 8. Background Modes
- [ ] + Capability
- [ ] Background Modes
- [ ] ✅ Remote notifications

---

## 💻 КОД

### 9. FirebaseNotificationManager.swift
- [ ] Відкрив файл
- [ ] Додав імпорти (вгорі):
  ```swift
  import Firebase
  import FirebaseMessaging
  ```
- [ ] В configure() залишив:
  ```swift
  FirebaseApp.configure()
  Messaging.messaging().delegate = self
  ```
- [ ] Розкоментував extensions (прибрав /* */)
- [ ] ⌘+S (зберегти)

### 10. AppDelegate.swift
- [ ] Новий файл (⌘+N)
- [ ] Swift File → AppDelegate.swift
- [ ] ✅ TrackHabit
- [ ] Вклеїв код з гайду
- [ ] ⌘+S

### 11. TrackHabitApp.swift
- [ ] Відкрив файл
- [ ] Додав після `struct TrackHabitApp: App {`:
  ```swift
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  ```
- [ ] ⌘+S

---

## 🔐 APNs (ОПЦІОНАЛЬНО - ДЛЯ ПРОДАКШН)

### 12. Apple Developer
- [ ] https://developer.apple.com/account
- [ ] Keys → Create new key
- [ ] ✅ Apple Push Notifications service (APNs)
- [ ] Register
- [ ] Download .p8 файл
- [ ] Записав Key ID
- [ ] Записав Team ID

### 13. Завантажити в Firebase
- [ ] Firebase Console → Settings → Cloud Messaging
- [ ] Upload .p8
- [ ] Ввів Key ID
- [ ] Ввів Team ID
- [ ] Upload
- [ ] ✅ Зелена галочка

---

## 🧪 ТЕСТ

### 14. Build & Run
- [ ] ⌘+B (Build)
- [ ] Без помилок
- [ ] Вибрав РЕАЛЬНИЙ пристрій (не симулятор!)
- [ ] ⌘+R (Run)
- [ ] Додаток запустився

### 15. Консоль
- [ ] ⌘+⇧+C (консоль)
- [ ] Бачу: `✅ Firebase configured`
- [ ] Бачу: `✅ AppDelegate initialized`
- [ ] Немає: `Could not locate GoogleService-Info.plist`

### 16. Локальний пуш
- [ ] Settings → Push-повідомлення
- [ ] Увімкнути повідомлення
- [ ] Allow в системному діалозі
- [ ] Статус: Увімкнено ✅
- [ ] 🧪 Тестове повідомлення
- [ ] Згорнув додаток
- [ ] Повідомлення прийшло через 3 сек ✅

### 17. FCM токен
- [ ] Developer Tools секція видно
- [ ] Token: (не "очікування...")
- [ ] Скопіював токен

### 18. Firebase пуш
- [ ] Firebase Console → Cloud Messaging
- [ ] Send test message
- [ ] Вклеїв токен
- [ ] +
- [ ] Test
- [ ] Повідомлення прийшло на пристрій ✅

### 19. Масова розсилка
- [ ] New campaign
- [ ] Написав Title + Text
- [ ] Next
- [ ] Target: All users
- [ ] Next
- [ ] Scheduling: Now
- [ ] Review → Publish
- [ ] Повідомлення прийшло ✅

---

## 📊 ФІНАЛ

### 20. Аналітика
- [ ] Firebase Console → Messaging → Campaigns
- [ ] Бачу статистику (Sent, Delivered, Opened)

---

## ✅ ВСЕ ГОТОВО!

Якщо всі пункти відзначені — Firebase працює!

---

**Роздруковано:** _________  
**Дата:** _________  
**Пройшов тест:** ☐ Так ☐ Ні

---

💾 **Збережи це:** Може знадобитись для наступних проектів!

🆘 **Якщо щось не так:** Дивись FIREBASE_STEP_BY_STEP.md
