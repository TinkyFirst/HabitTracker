# ⚡ ШВИДКИЙ CHECKLIST - Перед Submit на External Testing

**Track Habit v1.0**  
**5 січня 2026**

---

## 📱 В XCODE (5 хвилин)

### Перевірити перед Archive:

```
□ Bundle ID правильний (Target → General)
  Приклад: com.yourname.trackhabit
  
□ Version: 1.0, Build: 1
  
□ Signing працює (Target → Signing & Capabilities)
  ✓ Automatically manage signing
  ✓ Team обрано
  
□ Capabilities додані:
  ✓ iCloud (CloudKit)
  ✓ App Groups (group.com.trackhabit.shared)
  ✓ In-App Purchase
  ✓ Push Notifications
  
□ Clean Build успішний (Cmd + Shift + K, потім Cmd + B)

□ Запускається на симуляторі без crashes
```

---

## 🏗️ ARCHIVE & UPLOAD (15 хвилин)

```
□ Схема: Any iOS Device (arm64) обрано
  
□ Product → Archive (почекати 5-10 хв)
  
□ Validate App (в Organizer)
  ✓ No issues found
  
□ Distribute App → App Store Connect → Upload
  ✓ Upload your app's symbols
  ✓ Manage Version and Build Number
  
□ Почекати processing (15-30 хв, можна піти на каву ☕)
```

---

## 🌐 APP STORE CONNECT (45 хвилин)

### 1. App Information (5 хв)

```
My Apps → Track Habit → App Information

□ Privacy Policy URL:
  https://tinkyfirst.github.io/HabitTracker/privacy-policy.html
  
□ Subtitle (до 30 символів):
  EN: "Build Better Daily Habits"
  UK: "Будуй Кращі Щоденні Звички"
  
□ Category:
  Primary: Health & Fitness
  Secondary: Productivity
```

### 2. Privacy Nutrition Labels (15 хв)

```
App Privacy → Get Started

□ Does your app collect data? → YES

□ Identifiers → User ID:
  Collected: YES
  Linked to User: YES
  Used for Tracking: NO
  Purposes: ✓ App Functionality
  
□ Purchases → Purchase History:
  Collected: YES
  Linked to User: YES
  Used for Tracking: NO
  Purposes: ✓ App Functionality
  
□ Usage Data → Product Interaction (опціонально):
  Collected: YES
  Linked to User: NO
  Used for Tracking: NO
  Purposes: ✓ Analytics, ✓ App Functionality
  
□ Diagnostics → Crash Data (опціонально):
  Collected: YES
  Linked to User: NO
  Used for Tracking: NO
  Purposes: ✓ App Functionality
  
□ Do you use data for tracking? → NO
```

### 3. Age Rating (5 хв)

```
Age Rating → Edit

□ Пройти анкету (всі відповіді "None")
□ Результат: 4+
□ Save
```

### 4. Screenshots (30 хв)

```
Version 1.0 → App Store → Screenshots

□ iPhone 6.7" (15 Pro Max):
  Мінімум 3 screenshots:
  
  Screenshot 1: Today View (головний екран)
  - 3-5 звичок показано
  - 2-3 completed (зелені галочки)
  - Streak numbers видимі
  - Світла тема
  
  Screenshot 2: Insights/Progress (статистика)
  - Графіки з даними
  - Streak cards
  - Weekly/monthly progress
  
  Screenshot 3: Settings або Calendar
  - Показати features
  - Або історію виконання
  
  (Опціонально) Screenshot 4-5:
  - Habit creation screen
  - Habits list з категоріями
```

### 5. TestFlight Information (5 хв)

```
TestFlight → Test Information

□ Beta App Description:
  (Скопіювати з APP_STORE_DESCRIPTION.md або написати своє)
  
□ Beta App Review Information:
  Email: AndriyPopovich_temp@icloud.com
  Phone: [ваш номер]
  Sign-in required: NO
  
□ What to Test:
  (Описати що саме тестувати)
  
□ Export Compliance:
  Uses encryption: YES
  Type: Exempt (HTTPS only)
```

---

## 🚀 SUBMIT (2 хвилини)

```
□ TestFlight → Build → Select build
  
□ Перевірити що build "Ready to Submit"
  
□ External Testing → Create Group або Use existing
  
□ Group Name: "Beta Testers"
  
□ Add build to group
  
□ Submit for Review
  
□ ✅ ГОТОВО! Чекати 1-3 дні Apple Review
```

---

## ✅ ПІСЛЯ SUBMIT

```
□ Перевірити email (Apple може писати)
  
□ Статус в App Store Connect:
  "Waiting for Review" → "In Review" → "Approved"
  
□ Якщо Approved:
  □ Додати beta testers
  □ Відправити інвайти
  □ Збирати фідбек
  
□ Якщо Rejected:
  □ Прочитати rejection email
  □ Виправити проблеми
  □ Submit знову
```

---

## 📋 ГОТОВНІСТЬ КОДУ (швидка перевірка)

### ✅ Вже готово (можна не перевіряти):

```
✓ Privacy Policy URL в коді:
  PaywallView.swift (лінія 235)
  SettingsView.swift (лінія 650)
  
✓ Terms URL в коді:
  PaywallView.swift (лінія 230)
  SettingsView.swift (лінія 671)
  
✓ Email контакт:
  AndriyPopovich_temp@icloud.com
  
✓ Restore Purchases:
  PaywallView.swift (лінія 287-297)
  
✓ Subscription Terms:
  PaywallView.swift (лінія 227)
  
✓ App Group:
  group.com.trackhabit.shared
  
✓ Локалізація:
  UK + EN
```

---

## 🐛 TROUBLESHOOTING

### Якщо Archive не працює:

```
1. Clean Build Folder:
   Cmd + Shift + K (Clean)
   Cmd + Option + Shift + K (Clean Build Folder)
   
2. Restart Xcode
   
3. Перевірити Signing:
   Xcode → Preferences → Accounts → Manage Certificates
   
4. Перевірити Capabilities:
   Target → Signing & Capabilities → Перевірити App Groups
```

### Якщо Validation failed:

```
Common issues:

Issue: "Missing Privacy Description"
Fix: Info.plist → додати NSUserNotificationsUsageDescription

Issue: "Invalid Bundle ID"
Fix: Перевірити Bundle ID в App Store Connect

Issue: "Signing error"
Fix: Перевірити Team в Signing settings

Issue: "Missing iCloud Container"
Fix: Target → Signing & Capabilities → iCloud → додати контейнер
```

### Якщо Processing довго (>1 год):

```
1. Почекати ще 30 хв (перший upload може бути повільним)
2. Перевірити email (Apple може надіслати помилку)
3. Перевірити статус в App Store Connect → Activity
4. Якщо "Invalid Binary" → прочитати email, виправити, upload знову
```

---

## ⏱️ ESTIMATED TIME

```
Xcode checks:        5 хв
Archive + Upload:   15 хв
Processing:         15-30 хв (wait)
App Store Connect:  45 хв
Submit:              2 хв
─────────────────────────
Total active time:  ~1 година 7 хв
Total real time:    ~1.5-2 години (з processing)
```

---

## 💡 TIPS

### Перед початком:

```
☕ Приготуй каву/чай (processing буде тривати)
📱 Майте під рукою iPhone (для screenshots)
📧 Відкрийте email (для перевірки під час processing)
📄 Відкрийте APP_STORE_DESCRIPTION.md (для копіювання текстів)
```

### Під час роботи:

```
✅ Зберігайте часто в App Store Connect (може глючити)
✅ Не закривайте вкладку під час збереження
✅ Робіть screenshots у світлій темі (краще читається)
✅ Використовуйте реальні назви звичок (не "Test Habit")
```

### Після submit:

```
📧 Перевіряйте email щодня
📱 Тримайте пристрій під рукою (якщо Apple попросить demo)
🚫 Не змінюйте нічого в App Store Connect під час review
⏳ Review зазвичай 1-2 дні (рідко 3 дні)
```

---

## 📞 ЯКЩО ЩОСЬ НЕ ТАК

**Детальні гайди:**
- `TESTFLIGHT_GUIDE.md` - повна інструкція
- `READY_FOR_EXTERNAL_TESTING_SUMMARY.md` - детальний підсумок
- `FINAL_EXTERNAL_TESTING_CHECKLIST.md` - розширений checklist

**Якщо застрягли:**
1. Пошукати помилку в документації вище
2. Google: "Xcode [your error message]"
3. Apple Developer Forums
4. Stack Overflow

**Email для фідбеку:**
AndriyPopovich_temp@icloud.com

---

## 🎯 ПРОСТИМИ СЛОВАМИ

```
1. Відкрий Xcode → Archive → Upload
2. Почекай processing
3. Зайди в App Store Connect
4. Заповни форми (копіюй з APP_STORE_DESCRIPTION.md)
5. Зроби 3 screenshots
6. Submit for External Testing
7. Чекай 1-3 дні
8. ✅ Approved → запроси beta testers!
```

**ВСЕ! Не складно, просто довго заповнювати форми. 💪**

---

## ✅ FINAL CHECK

Перед тим як натиснути "Submit for Review":

```
□ Build uploaded і показує "Ready to Submit"
□ Privacy Policy URL додано
□ Privacy Labels заповнені
□ Age Rating обрано
□ Screenshots uploaded (мінімум 3)
□ TestFlight Information заповнено
□ Export Compliance відповіли
□ Email correct: AndriyPopovich_temp@icloud.com
□ Додаток не крашиться на симуляторі
```

**Якщо всі галочки ✅ → SUBMIT! 🚀**

---

**Версія:** 1.0  
**Дата:** 5 січня 2026  

**READY? GO! 💪**
