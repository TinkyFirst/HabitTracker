# 🚀 Повний гайд по підготовці та розгортанню Track Habit для TestFlight

## ✅ Чеклист готовності до тестування

### 📱 1. Код і локалізація
- [x] ✅ Всі UI елементи локалізовані (англійська + українська)
- [x] ✅ Виправлено "3 insights of 3" → "3 of 3 habits completed today"
- [ ] ⚠️ Перевірити всі екрани на наявність нелокалізованих рядків
- [ ] ⚠️ Тестування в обох мовах (переключення в Settings)

### 🎨 2. Assets & Бренд матеріали
- [ ] ⚠️ App Icon (потрібен для App Store)
  - 1024x1024 px (App Store)
  - Всі розміри для iOS (генеруються автоматично в Xcode)
- [ ] ⚠️ Launch Screen (екран запуску)
- [ ] ⚠️ Screenshots для App Store (потрібні для публікації):
  - iPhone 6.7" (iPhone 14 Pro Max, 15 Pro Max)
  - iPhone 6.5" (iPhone 11 Pro Max, XS Max)
  - iPhone 5.5" (опціонально)
  - iPad Pro 12.9"
  - iPad Pro 11"

### 🔐 3. Certificates & Provisioning (Apple Developer Account)
- [ ] ⚠️ Apple Developer Account (99$/рік)
- [ ] ⚠️ Distribution Certificate
- [ ] ⚠️ App ID зареєстровано
- [ ] ⚠️ Provisioning Profile для TestFlight

### 💰 4. StoreKit & Покупки
- [ ] ✅ StoreKit інтегровано
- [ ] ⚠️ In-App Purchase Products створені в App Store Connect:
  - Monthly Subscription
  - Yearly Subscription
  - Lifetime Purchase
- [ ] ⚠️ Тестові StoreKit Configuration файли (для локального тестування)

### ☁️ 5. iCloud Sync
- [ ] ✅ SwiftData + CloudKit реалізовано
- [ ] ⚠️ iCloud Capability додано в Xcode
- [ ] ⚠️ CloudKit Container ідентифікатор налаштовано

### 🔔 6. Push Notifications (опціонально для першої версії)
- [ ] ✅ Firebase інтегровано
- [ ] ⚠️ GoogleService-Info.plist додано
- [ ] ⚠️ APNs Key завантажено в Firebase Console
- [ ] ⚠️ Push Notifications Capability додано

### 📊 7. Analytics (опціонально)
- [ ] ⚠️ Firebase Analytics налаштовано
- [ ] ⚠️ Базові події відстежуються

### 🧪 8. Тестування
- [ ] ⚠️ Всі основні flow протестовані:
  - Створення звички
  - Видалення звички
  - Check-in
  - Streaks
  - Goals
  - Settings
  - Language switch
- [ ] ⚠️ Тестування на різних пристроях:
  - iPhone SE (маленький екран)
  - iPhone 14 Pro (звичайний)
  - iPhone 14 Pro Max (великий)
  - iPad
- [ ] ⚠️ Dark Mode / Light Mode

### 📄 9. Правова інформація
- [ ] ⚠️ Privacy Policy URL
- [ ] ⚠️ Terms of Service URL
- [ ] ⚠️ Support URL
- [ ] ⚠️ Marketing URL (website)

### 📝 10. App Store Connect
- [ ] ⚠️ App створено в App Store Connect
- [ ] ⚠️ App Information:
  - Name
  - Subtitle
  - Category
  - Content Rights
- [ ] ⚠️ Pricing & Availability
- [ ] ⚠️ App Privacy (відповіді на запитання про приватність)

---

## 🛠 ПОКРОКОВИЙ ФЛОУ РОЗГОРТАННЯ

### Етап 1: Підготовка проекту в Xcode

#### Крок 1.1: Налаштування Bundle Identifier
```
1. Відкрий проект в Xcode
2. Select Target "Track Habit"
3. General tab
4. Bundle Identifier: com.yourname.trackhabit (має бути унікальним)
5. Version: 1.0.0
6. Build: 1
```

#### Крок 1.2: Додати App Icon
```
1. Assets.xcassets
2. AppIcon
3. Перетягни всі розміри іконок
4. Або згенеруй через: https://appicon.co
```

#### Крок 1.3: Налаштувати Capabilities
```
1. Target → Signing & Capabilities
2. Додати Capabilities:
   - iCloud
     → CloudKit
     → Container: iCloud.com.yourname.trackhabit
   - Push Notifications (якщо потрібні)
   - Background Modes (якщо потрібні для notif)
```

#### Крок 1.4: Налаштувати Info.plist
```xml
<!-- Додати необхідні ключі -->
<key>CFBundleDisplayName</key>
<string>Track Habit</string>

<key>NSUserNotificationsUsageDescription</key>
<string>We'll remind you to complete your daily habits</string>

<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>

<!-- Privacy keys якщо використовуєш -->
```

---

### Етап 2: Apple Developer Program

#### Крок 2.1: Реєстрація
```
1. Зайди на https://developer.apple.com
2. Enroll in Apple Developer Program ($99/рік)
3. Заповни всю інформацію
4. Очікуй підтвердження (1-2 дні)
```

#### Крок 2.2: Створити App ID
```
1. Зайди в Apple Developer Portal
2. Certificates, Identifiers & Profiles
3. Identifiers → + (додати новий)
4. App IDs → Continue
5. Type: App
6. Description: Track Habit
7. Bundle ID: com.yourname.trackhabit (точно як у Xcode)
8. Capabilities:
   - App Groups (якщо widgets)
   - iCloud (CloudKit)
   - Push Notifications (якщо потрібні)
9. Register
```

#### Крок 2.3: Створити Distribution Certificate
```
1. Certificates, Identifiers & Profiles
2. Certificates → + (додати новий)
3. iOS Distribution (App Store and Ad Hoc)
4. Continue
5. Згенерувати Certificate Signing Request (CSR):
   - Відкрий Keychain Access на Mac
   - Keychain Access → Certificate Assistant → Request a Certificate
   - Email: твій email
   - Common Name: твоє ім'я
   - Save to disk
6. Завантаж CSR файл
7. Download Certificate
8. Подвійний клік щоб інсталювати в Keychain
```

#### Крок 2.4: Створити Provisioning Profile
```
1. Profiles → + (додати новий)
2. Distribution → App Store Connect
3. Continue
4. Вибери App ID (Track Habit)
5. Вибери Distribution Certificate
6. Profile Name: Track Habit App Store
7. Generate
8. Download
9. Подвійний клік щоб інсталювати
```

---

### Етап 3: App Store Connect

#### Крок 3.1: Створити App
```
1. Зайди на https://appstoreconnect.apple.com
2. My Apps → + (додати новий app)
3. New App:
   - Platforms: iOS
   - Name: Track Habit
   - Primary Language: English (US)
   - Bundle ID: вибери з dropdown (com.yourname.trackhabit)
   - SKU: TRACKHABIT001 (унікальний ідентифікатор)
   - User Access: Full Access
4. Create
```

#### Крок 3.2: Заповнити App Information
```
1. App Information (ліва панель)
2. Name: Track Habit
3. Subtitle: Build Better Habits Daily (макс 30 символів)
4. Category:
   - Primary: Health & Fitness
   - Secondary: Productivity
5. Content Rights: No (якщо немає третьої сторони)
6. Age Rating: заповни питання (скоріш за все 4+)
7. Save
```

#### Крок 3.3: Pricing and Availability
```
1. Pricing and Availability
2. Price: Free (для base версії)
3. Availability: All countries (або вибери)
4. Save
```

#### Крок 3.4: App Privacy
```
1. App Privacy (ліва панель)
2. Get Started
3. Відповісти на питання:
   - Do you collect data? → Якщо ні analytics/crash: No
   - Якщо використовуєш Firebase:
     → Yes
     → Analytics data: Device ID, Usage Data
     → Purpose: App Functionality, Analytics
     → Linked to user: No (якщо anonymous)
4. Save and Publish
```

#### Крок 3.5: In-App Purchases (якщо є)
```
1. In-App Purchases (ліва панель)
2. Create → Auto-Renewable Subscription
3. Reference Name: Track Habit Pro Monthly
4. Product ID: com.yourname.trackhabit.pro.monthly
5. Subscription Group: Track Habit Pro
6. Subscription Duration: 1 month
7. Price: вибери ціну (наприклад $4.99)
8. Localization:
   - Display Name: Track Habit Pro
   - Description: Unlock unlimited habits and insights
9. Review Information (screenshot та опис для Apple reviewers)
10. Save

Повтори для:
- Yearly (com.yourname.trackhabit.pro.yearly)
- Lifetime (Non-Consumable) (com.yourname.trackhabit.pro.lifetime)
```

---

### Етап 4: Збірка та завантаження

#### Крок 4.1: Archive в Xcode
```
1. В Xcode вибери пристрій: Any iOS Device (arm64)
2. Product → Clean Build Folder (Shift + Cmd + K)
3. Product → Archive (Cmd + Shift + B)
4. Очікуй компіляції (5-10 хвилин)
5. Коли закінчиться → відкриється Organizer
```

#### Крок 4.2: Validate архів
```
1. В Organizer вибери свій архів
2. Натисни "Validate App"
3. Вибери Distribution Method: App Store Connect
4. Вибери Distribution Certificate
5. Automatically manage signing
6. Next → Next → Validate
7. Очікуй результатів (2-5 хвилин)
8. Якщо OK → можна завантажувати
9. Якщо є помилки → виправи і повтори Archive
```

#### Крок 4.3: Завантажити на App Store Connect
```
1. В Organizer натисни "Distribute App"
2. Method: App Store Connect
3. Upload
4. Вибери Distribution Certificate
5. Automatically manage signing
6. Next → Next → Upload
7. Очікуй завантаження (5-15 хвилин)
8. Коли завершиться → побачиш "Upload Successful"
```

#### Крок 4.4: Обробка біл0ду на App Store Connect
```
1. Зайди в App Store Connect
2. My Apps → Track Habit
3. TestFlight (ліва панель)
4. iOS Builds
5. Очікуй обробки білду (20-60 хвилин)
6. Статус зміниться з "Processing" на "Ready to Submit"
```

---

### Етап 5: TestFlight

#### Крок 5.1: Налаштувати TestFlight
```
1. В App Store Connect → TestFlight
2. Test Information:
   - Beta App Name: Track Habit
   - Beta App Description: опиши що тестувати
   - Feedback Email: твій email для фідбеку
   - Marketing URL: (якщо є)
   - Privacy Policy URL: (обов'язково!)
3. What to Test:
   - Напиши що потрібно протестувати в цій версії
   - Наприклад: "Test habit creation, check-ins, goals, and localization"
4. Test Details:
   - Sign-In Required: No (якщо не потрібен логін)
   - Beta App Review Information: контакт і notes для Apple
5. Save
```

#### Крок 5.2: Submit for Beta Review (Internal Testing)
```
1. Вибери білд
2. Submit for Review
3. Export Compliance: No (якщо не використовуєш шифрування крім стандартного)
4. Натисни "Submit"
5. Очікуй Apple Review (6-48 годин, зазвичай ~12 годин)
```

#### Крок 5.3: Додати Internal Testers
```
1. App Store Connect → Users and Access
2. Testers → Internal Testers
3. + → додати email адреси команди (до 100 осіб)
4. Вони отримають email з посиланням на TestFlight
```

#### Крок 5.4: Додати External Testers (опціонально)
```
1. TestFlight → External Testing
2. Create New Group
3. Group Name: Beta Testers
4. Add External Testers: можна додати до 10,000 email адрес
5. Add Build to Group
6. Submit for Beta App Review (потрібен окремий review)
```

#### Крок 5.5: Інструкція для тестерів
```
Відправ тестерам:

1. Скачати TestFlight з App Store
2. Відкрити посилання з email або:
   - Відкрити TestFlight
   - Accept Invitation
3. Install Track Habit
4. Тестувати функціонал
5. Надати фідбек через TestFlight:
   - Скріншот → Share → TestFlight
   - Або Screenshot → виділити → Send to Developer
```

---

### Етап 6: Тестування та фідбек

#### Крок 6.1: Чеклист тестування для Internal Testers
```
Основний функціонал:
- [ ] Створення звички (custom і з template)
- [ ] Редагування звички
- [ ] Видалення звички
- [ ] Check-in
- [ ] Multiple check-ins (якщо dailyRepetitions > 1)
- [ ] Streak calculation
- [ ] Goals (weekly, monthly, yearly)
- [ ] Goals progress відображення
- [ ] Insights екран
- [ ] Calendar heatmap
- [ ] Локалізація (перемикання UK ↔️ EN)
- [ ] Dark/Light mode
- [ ] Notifications/Reminders
- [ ] Settings

Критичні баги:
- [ ] Crash при запуску
- [ ] Crash при створенні звички
- [ ] Data loss (дані пропадають)
- [ ] iCloud sync не працює
```

#### Крок 6.2: Збирати фідбек
```
Створи форму Google Forms або Notion:

1. Який пристрій? (iPhone/iPad, модель, iOS версія)
2. Що тестував?
3. Що працює добре?
4. Які баги знайшов?
5. Що можна покращити?
6. Скріншоти (якщо є)
```

#### Крок 6.3: Випустити нову версію
```
Якщо є баги:

1. Виправити код
2. Збільшити Build Number (наприклад 1.0.0 (2))
3. Повторити: Archive → Validate → Upload
4. В TestFlight додати новий білд до групи тестерів
5. Тестери отримають оновлення автоматично
```

---

### Етап 7: Підготовка до Production (App Store)

#### Крок 7.1: Скріншоти для App Store
```
Потрібні розміри (використай Simulator або реальні пристрої):

iPhone 6.7" (1290 x 2796 px):
- Screenshot 1: Today View з кількома звичками
- Screenshot 2: Insights з графіками
- Screenshot 3: Goals progress
- Screenshot 4: Habit detail з streaks
- Screenshot 5: Customization (colors, icons)

iPad Pro 12.9" (2048 x 2732 px):
- Мінімум 1-2 скріншоти

Поради:
- Використай красиві mock дані
- Додай overlay text з features
- Використай Figma або Sketch для полірування
```

#### Крок 7.2: App Preview Video (опціонально)
```
15-30 секунд відео:
- Показати flow: створення → check-in → progress
- Розмір: такі ж як screenshots
- Формат: .mov or .mp4
```

#### Крок 7.3: Заповнити App Store Listing
```
1. App Store → Prepare for Submission
2. Version Information:
   - What's New in This Version:
     "Initial release! Track your daily habits, set goals, 
     view insights, and build streaks. 
     • Create unlimited habits
     • Beautiful insights and charts
     • Set weekly, monthly, and yearly goals
     • Dark mode support
     • iCloud sync across devices"

3. Promotional Text (170 chars):
   "Build lasting habits with beautiful tracking, 
   goals, and insights. Start your journey today! 🚀"

4. Description (4000 chars):
   [Напиши детальний опис з features, benefits, key highlights]

5. Keywords (100 chars):
   "habit,tracker,goals,productivity,health,fitness,routine,streak,planner"

6. Support URL: https://yourwebsite.com/support
7. Marketing URL: https://yourwebsite.com

8. Screenshots: завантаж для всіх розмірів

9. Build: вибери білд з TestFlight

10. Save
```

#### Крок 7.4: Submit for Review
```
1. Перевір всю інформацію
2. App Store → Submit for Review
3. Export Compliance: відповісти
4. Content Rights: відповісти
5. Advertising Identifier: No (якщо не використовуєш)
6. Submit
7. Очікуй review (1-3 дні, в середньому ~24 години)
```

#### Крок 7.5: App Store Review
```
Статуси:
- Waiting for Review: в черзі
- In Review: команда Apple перевіряє (4-24 години)
- Pending Developer Release: Approved! (можеш релізити)
- Ready for Sale: Live в App Store!

Якщо Rejected:
- Прочитай Resolution Center notes
- Виправ проблеми
- Resubmit білд
```

---

## 🚨 Поширені проблеми та рішення

### Проблема 1: "No provisioning profiles found"
```
Рішення:
1. Xcode → Preferences → Accounts
2. Вибери Apple ID → Download Manual Profiles
3. Або створи новий профіль в Developer Portal
4. Target → Signing & Capabilities → Automatically manage signing
```

### Проблема 2: "Code signing error"
```
Рішення:
1. Видали Derived Data:
   Xcode → Preferences → Locations → Derived Data → стрілка → delete
2. Clean Build Folder (Shift + Cmd + K)
3. Revoke старі certificates і створи нові
4. Перезавантаж Xcode
```

### Проблема 3: "Invalid bundle identifier"
```
Рішення:
1. Перевір що Bundle ID в Xcode точно співпадає з App ID в Developer Portal
2. Без пробілів, спецсимволів
3. Формат: com.companyname.appname
```

### Проблема 4: "Missing Privacy Policy"
```
Рішення:
1. Створи Privacy Policy сторінку (можна використати generator)
2. Хости на GitHub Pages, Notion, або свому сайті
3. Додай URL в App Store Connect → App Privacy
4. Додай link в Settings екран додатку
```

### Проблема 5: "App crashed during review"
```
Рішення:
1. Перевір Crashlytics/Firebase для crash logs
2. Тестуй на різних пристроях і iOS версіях
3. Додай defensive programming (перевірки nil, guard statements)
4. Використовуй TestFlight extensively перед production
```

### Проблема 6: "Missing localization"
```
Рішення:
1. Перевір що ВСІ strings використовують .localized
2. Перевір LanguageManager.swift на наявність всіх ключів
3. Тестуй app в обох мовах перед submit
```

---

## 📋 QUICK CHECKLIST - Швидка перевірка перед submit

### Pre-Submit Checklist
```
- [ ] App Icon встановлено (всі розміри)
- [ ] Launch Screen налаштовано
- [ ] Bundle ID співпадає з App ID
- [ ] Version 1.0.0, Build 1
- [ ] Signing Certificate валідний
- [ ] Provisioning Profile активний
- [ ] Privacy Policy URL додано
- [ ] Support URL додано
- [ ] In-App Purchases налаштовані (якщо є)
- [ ] Tested на iPhone і iPad
- [ ] Tested Dark/Light mode
- [ ] Tested локалізацію UK + EN
- [ ] No crashes
- [ ] No debug prints в production коді
- [ ] Analytics працює (якщо є)
- [ ] Notifications працюють (якщо є)
```

---

## 🎉 Після успішного релізу

### День 1-7: Моніторинг
```
- [ ] Перевіряй App Store Connect → Analytics
- [ ] Моніторь crashes (Crashlytics)
- [ ] Збирай перші відгуки
- [ ] Відповідай на запитання в Support
- [ ] Fixes critical bugs швидко
```

### Marketing
```
- [ ] Share на соцмережах (Twitter, Reddit r/SideProject)
- [ ] Product Hunt launch
- [ ] Indie Hackers post
- [ ] Email друзям/early adopters
- [ ] Create landing page
```

### Continuous Improvement
```
- [ ] Збирай feature requests
- [ ] Plan version 1.1
- [ ] A/B test onboarding
- [ ] Optimize conversion to Pro
- [ ] Improve retention
```

---

## 📞 Контакти та Resources

### Офіційна документація
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Корисні Tools
- [App Icon Generator](https://appicon.co)
- [Screenshot Generator](https://www.screenshotone.com)
- [Privacy Policy Generator](https://www.privacypolicies.com/blog/privacy-policy-template/)

### Community
- [r/iOSProgramming](https://reddit.com/r/iOSProgramming)
- [Swift Forums](https://forums.swift.org)
- [Indie Hackers](https://indiehackers.com)

---

## ✅ ГОТОВО!

Коли пройдеш всі ці кроки, твій Track Habit буде готовий до тестування і запуску! 🚀

**Успіхів! 💪**
