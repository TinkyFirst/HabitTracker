# 🚀 ПОЧНИ ЗАРАЗ - Швидкий старт Firebase

## 👉 Що робити прямо зараз (покроково)

---

## ✅ Крок 1: Перевір файл GoogleService-Info.plist

Ти вже додав файл в проект. Давай перевіримо чи правильно:

### В Xcode:

1. **Project Navigator** (ліва панель, ⌘+1)
2. Знайди **`GoogleService-Info.plist`**
3. Клікни на файл
4. В **правій панелі** (File Inspector, ⌘+⌥+1) знайди **"Target Membership"**
5. **Має бути галочка:** ✅ TrackHabit

### ❌ Якщо галочки немає:
- Постав галочку вручну
- Або видали файл і додай заново (дивись FIREBASE_STEP_BY_STEP.md → Крок 3.3)

### ✅ Якщо галочка є:
→ Йди до **Кроку 2**

---

## 📦 Крок 2: Додай Firebase SDK

### В Xcode:

1. **File** (в меню вгорі) → **Add Package Dependencies...**

2. В полі пошуку вклей:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```

3. Натисни **Enter** або кнопку пошуку

4. Дочекайся поки з'явиться **firebase-ios-sdk**

5. **Dependency Rule:** залиш як є (Up to Next Major Version)

6. Натисни **Add Package** (внизу справа)

7. **Зачекай 1-3 хвилини** (перший раз довго завантажується!)

8. Коли з'явиться вікно **"Choose Package Products"**:
   ```
   ✅ FirebaseMessaging  ← ПОСТАВ ГАЛОЧКУ!
   ✅ FirebaseAnalytics  ← опціонально
   ```

9. Натисни **Add Package**

10. Дочекайся завершення

### ✅ Коли побачиш в Project Navigator → Package Dependencies → firebase-ios-sdk:
→ Йди до **Кроку 3**

---

## ⚙️ Крок 3: Додай Capabilities

### В Xcode:

1. Клікни на **синю іконку проекту** в Project Navigator (самий верх, TrackHabit)

2. Вибери **TARGET: TrackHabit** (в центральній панелі)

3. Перейди на таб **"Signing & Capabilities"** (вгорі)

4. Натисни **"+ Capability"** (вгорі зліва)

5. В пошуку введи: `Push Notifications`

6. Клікни на **"Push Notifications"** → з'явиться нова секція

7. Знову натисни **"+ Capability"**

8. Введи: `Background Modes`

9. Клікни на **"Background Modes"**

10. В секції **Background Modes** постав галочку:
    ```
    ✅ Remote notifications
    ```

### ✅ Коли бачиш обидві секції:
- Push Notifications
- Background Modes (✅ Remote notifications)

→ Йди до **Кроку 4**

---

## 💻 Крок 4: Розкоментуй код

### Відкрий файл `FirebaseNotificationManager.swift`:

1. В Project Navigator знайди файл

2. **В самому верху файлу** (рядки 1-3) є:
   ```swift
   import Foundation
   import UserNotifications
   import UIKit
   ```

3. **ДОДАЙ ДВА РЯДКИ:**
   ```swift
   import Foundation
   import UserNotifications
   import UIKit
   import Firebase          ← ДОДАЙ ЦЕЙ РЯДОК
   import FirebaseMessaging ← ДОДАЙ ЦЕЙ РЯДОК
   ```

4. **Знайди метод `configure()`** (біля рядка 52)

5. **БУЛО:**
   ```swift
   func configure() {
       // РОЗКОМЕНТУЙ КОЛИ ДОДАСИ FIREBASE:
       // import Firebase
       // import FirebaseMessaging
       //
       // FirebaseApp.configure()
       // Messaging.messaging().delegate = self
       
       print("🔥 Firebase configured")
   }
   ```

6. **ЗМІНИ НА:**
   ```swift
   func configure() {
       FirebaseApp.configure()
       Messaging.messaging().delegate = self
       
       print("🔥 Firebase configured")
   }
   ```

7. **Scroll вниз до рядка ~109** (шукай `// MARK: - Firebase Messaging Delegate`)

8. **ЗНАЙДИ:**
   ```swift
   // РОЗКОМЕНТУЙ КОЛИ ДОДАСИ FIREBASE SDK:
   /*
   import FirebaseMessaging
   
   extension FirebaseNotificationManager: MessagingDelegate {
   ```

9. **ВИДАЛИ:**
   - Рядок `// РОЗКОМЕНТУЙ...`
   - Символ `/*` (на початку)
   - Рядок `import FirebaseMessaging` (імпорт вже вгорі)
   - Символ `*/` (в кінці всіх extensions, після останньої закритої дужки)

10. **МАЄ ВИЙТИ:**
    ```swift
    // MARK: - Firebase Messaging Delegate
    extension FirebaseNotificationManager: MessagingDelegate {
        /// Отримуємо FCM токен
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("🔥 Firebase token: \(fcmToken ?? "nil")")
            ...
        }
    }
    
    extension FirebaseNotificationManager: UNUserNotificationCenterDelegate {
        ...
    }
    ```

11. **Збережи файл:** ⌘+S

### ✅ Коли код розкоментовано:
→ Йди до **Кроку 5**

---

## 📝 Крок 5: Створи AppDelegate.swift

### В Xcode:

1. В **Project Navigator** клікни **правою кнопкою** на папку (де TrackHabitApp.swift)

2. **New File...** (або ⌘+N)

3. Вибери **Swift File**

4. Next

5. **Save As:**
   ```
   AppDelegate.swift
   ```

6. **Targets:** ✅ TrackHabit

7. Create

8. **ВИДАЛИ весь вміст файлу** (якщо щось є)

9. **ВКЛЕЙ код з файлу:** `AppDelegate_TEMPLATE.swift` (він вже є в проекті)

   Або скопіюй сюди:
   ```swift
   import UIKit
   import Firebase
   import FirebaseMessaging

   class AppDelegate: NSObject, UIApplicationDelegate {
       func application(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
           FirebaseNotificationManager.shared.configure()
           UNUserNotificationCenter.current().delegate = FirebaseNotificationManager.shared
           print("✅ AppDelegate initialized")
           return true
       }
       
       func application(_ application: UIApplication,
                        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           print("📱 Received APNs token")
           Messaging.messaging().apnsToken = deviceToken
       }
       
       func application(_ application: UIApplication,
                        didFailToRegisterForRemoteNotificationsWithError error: Error) {
           print("❌ Failed to register for remote notifications: \(error)")
       }
   }
   ```

10. **Збережи:** ⌘+S

### ✅ Коли файл створено:
→ Йди до **Кроку 6**

---

## 🔗 Крок 6: Підключи AppDelegate

### Відкрий файл `TrackHabitApp.swift`:

1. **ЗНАЙДИ:**
   ```swift
   @main
   struct TrackHabitApp: App {
       @State private var selectedHabitId: UUID?
       @AppStorage("preferredColorScheme") private var preferredColorScheme = "system"
       ...
   ```

2. **ДОДАЙ ОДИН РЯДОК** одразу після `struct TrackHabitApp: App {`:
   ```swift
   @main
   struct TrackHabitApp: App {
       @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate  ← ДОДАЙ ЦЕЙ РЯДОК
       
       @State private var selectedHabitId: UUID?
       @AppStorage("preferredColorScheme") private var preferredColorScheme = "system"
       ...
   ```

3. **Збережи:** ⌘+S

### ✅ Коли рядок додано:
→ Йди до **Кроку 7**

---

## 🧪 Крок 7: Тест!

### Build проект:

1. Натисни **⌘+B** (Command + B)

2. Дочекайся завершення компіляції (~30 сек - 1 хв)

3. **Якщо є ПОМИЛКИ (червоні):**
   - Напиши мені, виправимо!

4. **Якщо тільки warnings (жовті):**
   - Все ок, ігноруй

### Запусти додаток:

⚠️ **ВАЖЛИВО:** Тільки на **реальному пристрої** (iPhone/iPad)!

1. Підключи iPhone/iPad до Mac

2. В Xcode **вгорі** вибери свій пристрій (не симулятор!)
   ```
   ▶ TrackHabit | ▼ [Твій iPhone]
   ```

3. Натисни **⌘+R** (Command + R)

4. Додаток запуститься на пристрої

### Перевір консоль:

1. В Xcode натисни **⌘+⇧+C** (показати консоль)

2. **Маєш побачити:**
   ```
   ✅ Firebase configured
   ✅ AppDelegate initialized
   ```

3. **Якщо бачиш:**
   ```
   ❌ Could not locate configuration file: 'GoogleService-Info.plist'
   ```
   → Повернись до **Кроку 1** (файл додано неправильно)

### Тест локального пушу:

1. В додатку перейди: **Settings → Push-повідомлення**

2. Натисни **"Увімкнути повідомлення"**

3. В системному діалозі: **Allow**

4. Статус змінився на **"Увімкнено ✅"**

5. Scroll вниз до **"Developer Tools"**

6. Натисни **"🧪 Тестове повідомлення (3 сек)"**

7. **Згорни додаток** (Home button / свайп вгору)

8. **Через 3 секунди** має з'явитись:
   ```
   🎉 Нова версія!
   Оновіть додаток до версії 2.0
   ```

### ✅ Якщо повідомлення прийшло:
→ **Локальні пуші працюють!** 🎉

### ❌ Якщо не прийшло:
- Перевір що дозволив пуші (Settings → Allow)
- Перевір що додаток згорнуто (не відкритий)
- Перевір консоль Xcode на помилки

---

## 🔥 НАСТУПНИЙ КРОК: Firebase Console

Тепер треба налаштувати Firebase в браузері:

1. Зайди на: https://console.firebase.google.com
2. Створи проект: **Track Habit**
3. Додай iOS додаток з твоїм Bundle ID
4. Завантаж APNs ключ (.p8) з developer.apple.com

**Детальна інструкція:**
→ **FIREBASE_STEP_BY_STEP.md** (Кроки 1-2 та 6-10)

---

## 📋 Швидка перевірка (все готово в Xcode?)

- [ ] GoogleService-Info.plist додано (Target Membership: ✅)
- [ ] Firebase SDK встановлено (Package Dependencies)
- [ ] Capabilities додано (Push Notifications + Background Modes)
- [ ] FirebaseNotificationManager.swift розкоментовано
- [ ] AppDelegate.swift створено
- [ ] TrackHabitApp.swift оновлено (AppDelegate підключено)
- [ ] Build успішний (⌘+B без помилок)
- [ ] Додаток запускається на реальному пристрої
- [ ] Консоль показує: ✅ Firebase configured
- [ ] Локальний пуш працює

### Якщо всі ✅ — ти молодець! 🎉

---

## 🆘 Допомога

Якщо щось не виходить:

1. **FIREBASE_CHECKLIST.md** — checklist всіх кроків
2. **XCODE_VISUAL_GUIDE.md** — де що натискати
3. **FIREBASE_STEP_BY_STEP.md** — детальна інструкція
4. Напиши мені — разом розберемось! 💬

---

🚀 **Продовжуй!** Майже готово!

**Наступний файл:** FIREBASE_STEP_BY_STEP.md → Кроки 6-10 (Firebase Console)
