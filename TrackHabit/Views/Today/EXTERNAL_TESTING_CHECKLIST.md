# ✅ External Testing Checklist для Apple Review

## 📋 Перед відправкою на External Testing

Apple більш суворо перевіряє додатки для External Testing, ніж для Internal. Ось що потрібно перевірити:

---

## 1️⃣ App Store Connect - Базові налаштування

### ✅ App Information
- [ ] **App Name**: Унікальна та описова назва (макс 30 символів)
- [ ] **Subtitle**: Короткий опис (макс 30 символів)
- [ ] **Primary Language**: Вибрано основну мову
- [ ] **Category**: Вибрано правильну категорію (Productivity або Health & Fitness)
- [ ] **Content Rights**: Підтверджено права на контент

### ✅ Contact Information
- [ ] **Email**: AndriyPopovich_temp@icloud.com ✅ (вже додано)
- [ ] **Phone Number**: Додано контактний номер
- [ ] **Marketing URL**: (опціонально) - сайт додатку

---

## 2️⃣ Privacy & Legal

### ✅ Privacy Policy
**Статус: ⚠️ ПОТРІБНО ПЕРЕВІРИТИ**

Apple **вимагає** Privacy Policy якщо ваш додаток:
- ❌ Збирає user data
- ❌ Використовує analytics (навіть якщо анонімно)
- ❌ Має IAP (In-App Purchases)
- ❌ Використовує iCloud

**Ваш випадок:**
- ✅ Є In-App Purchases
- ✅ Є iCloud Sync
- ✅ Можливо є analytics

**Що треба:**
```
1. Створити Privacy Policy (можна використати генератори):
   - https://www.privacypolicygenerator.info/
   - https://www.termsfeed.com/privacy-policy-generator/

2. Розмістити на:
   - Website (trackhabit.app/privacy)
   - Або використати GitHub Pages
   
3. Додати в App Store Connect:
   - App Information → Privacy Policy URL
```

### ✅ Terms of Service
**Статус: ⚠️ ОПЦІОНАЛЬНО, але рекомендовано**

Потрібно якщо:
- Є підписки (у вас є!)
- Користувачі створюють контент
- Є правила використання

**Що треба:**
```
1. Створити Terms of Service
2. Розмістити на: trackhabit.app/terms
3. Додати в AboutView (вже є! ✅)
```

### ✅ Privacy Nutrition Labels
**Статус: 🔍 ПОТРІБНО ЗАПОВНИТИ**

App Store Connect → App Privacy → "Get Started"

**Що збирає ваш додаток:**
```
✅ Дані НЕ пов'язані з користувачем:
   - Crash Data (якщо використовуєте analytics)
   - Performance Data (якщо використовуєте analytics)

✅ Дані пов'язані з користувачем:
   - User ID (для iCloud sync)
   - Purchase History (для IAP)

✅ Використання даних:
   - App Functionality (основна функціональність)
   - Analytics (якщо є)
```

**Приклад заповнення:**
```
Data Collected: YES
- Identifiers → User ID
  - Linked to User: YES
  - Used for Tracking: NO
  - Purposes: App Functionality

- Purchases → Purchase History
  - Linked to User: YES
  - Used for Tracking: NO
  - Purposes: App Functionality
```

---

## 3️⃣ Info.plist - Privacy Descriptions

**Статус: 🔍 ПОТРІБНО ПЕРЕВІРИТИ**

Apple вимагає пояснення для кожного дозволу (permission).

### Які дозволи використовує ваш додаток?

```xml
<!-- Info.plist -->

<!-- ✅ ОБОВ'ЯЗКОВО якщо є нагадування -->
<key>NSUserNotificationsUsageDescription</key>
<string>We need notifications to remind you about your daily habits.</string>

<!-- ✅ ОБОВ'ЯЗКОВО для StoreKit (iOS 17+) -->
<key>SKAdNetworkItems</key>
<array/>

<!-- ⚠️ Тільки якщо використовуєте камеру -->
<key>NSCameraUsageDescription</key>
<string>Take photos to track your habit progress visually.</string>

<!-- ⚠️ Тільки якщо використовуєте фото з бібліотеки -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Select photos to associate with your habits.</string>

<!-- ⚠️ Тільки якщо використовуєте календар -->
<key>NSCalendarsUsageDescription</key>
<string>Add habit reminders to your calendar.</string>
```

**Як перевірити що у вас:**
1. Xcode → Target → Info
2. Custom iOS Target Properties
3. Перевірте чи є ці ключі

**Що точно потрібно:**
- ✅ NSUserNotificationsUsageDescription (для нагадувань)

---

## 4️⃣ App Icon & Screenshots

### ✅ App Icon
- [ ] **1024x1024 px** (PNG, без прозорості)
- [ ] Додано в Assets.xcassets → AppIcon → App Store iOS slot
- [ ] Не містить текст (рекомендація Apple)
- [ ] Не містить скругленості (Apple додає автоматично)

**Ваш іконка:**
```
⏱️ або 🎯 з градієнтним фоном

Рекомендація: Використати SF Symbol "checkmark.circle" 
або створити просту іконку з вашим градієнтом (blue→purple)
```

### ✅ Screenshots
**Статус: ⚠️ ОБОВ'ЯЗКОВО ДЛЯ EXTERNAL TESTING**

Apple вимагає мінімум **3 screenshots** для:
- iPhone 6.7" (iPhone 15 Pro Max, iPhone 14 Pro Max)
- iPhone 6.5" (iPhone 14 Plus, iPhone 13 Pro Max)

**Як зробити:**
```
1. Запустити на симуляторі iPhone 15 Pro Max
2. Відкрити основні екрани:
   - Головний екран зі списком звичок
   - Екран статистики з графіками
   - Екран створення нової звички
   
3. Cmd + S → зберегти screenshot
4. Upload в App Store Connect → Screenshots
```

**Рекомендації:**
- ✅ Показати реальний контент (не пусті екрани)
- ✅ Використати світлу тему (легше читати)
- ✅ Додати короткі підписи (опціонально)
- ❌ Не показувати email/phone numbers
- ❌ Не показувати test/debug дані

---

## 5️⃣ App Description & Metadata

### ✅ App Description
**Статус: 📝 ПОТРІБНО НАПИСАТИ**

**Максимум:** 4000 символів

**Структура:**
```
🎯 [1-2 речення що робить додаток]

✨ KEY FEATURES:
• Feature 1
• Feature 2
• Feature 3

📊 [Чому ваш додаток кращий]

💎 PRO FEATURES:
• Unlimited habits
• Advanced analytics
• Custom themes

📧 CONTACT & SUPPORT:
Email: AndriyPopovich_temp@icloud.com

🔒 PRIVACY:
Your data stays private with iCloud sync. No tracking, no ads.
```

**Приклад для Track Habit:**
```
🎯 Build Better Habits, Track Your Progress

Track Habit is a beautiful habit tracker that helps you build positive routines and achieve your goals. With an intuitive interface, powerful analytics, and smart reminders, staying consistent has never been easier.

✨ KEY FEATURES:
• 📊 Visual Progress Tracking - See your streaks and patterns
• 🔔 Smart Reminders - Never miss a habit
• 📈 Detailed Analytics - Understand your progress
• 🎨 Beautiful Design - Dark mode & customizable themes
• ☁️ iCloud Sync - Access across all your devices
• 🌍 Localization - Ukrainian & English support

💎 PRO FEATURES:
• ♾️ Unlimited Habits - Track as many habits as you want
• 📊 Advanced Analytics - Deeper insights into your progress
• 🎨 Custom Themes - Personalize your experience
• 📱 Widget Customization - See your habits at a glance
• 🔔 Smart Notifications - Intelligent reminder scheduling

🔒 PRIVACY FIRST:
Your data is stored securely with iCloud. No tracking, no ads, no data selling. Your habits are yours alone.

📧 FEEDBACK & SUPPORT:
We'd love to hear from you! Email: AndriyPopovich_temp@icloud.com

---

Terms of Service: https://trackhabit.app/terms
Privacy Policy: https://trackhabit.app/privacy
```

### ✅ Keywords
**Максимум:** 100 символів (з комами)

**Приклад:**
```
habit,tracker,goals,routine,productivity,self-improvement,daily,streak,reminder,analytics,motivation,health
```

**Не включати:**
- ❌ Назву додатку
- ❌ Категорію
- ❌ "app", "application", "iOS"

### ✅ Promotional Text
**Максимум:** 170 символів (можна змінювати без review)

**Приклад:**
```
🎉 New Year, New Habits! Start 2025 with Track Habit. Build routines that stick with beautiful analytics and smart reminders. Try it free today!
```

---

## 6️⃣ In-App Purchases

### ✅ IAP Configuration
**Статус: 🔍 ПОТРІБНО ПЕРЕВІРИТИ**

**Що треба:**
- [ ] Всі IAP створені в App Store Connect
- [ ] Metadata заповнено (Display Name, Description)
- [ ] Screenshots додано (1 на кожний IAP)
- [ ] Pricing налаштовано
- [ ] Status: "Ready to Submit"

**Ваші підписки:**
```
1. Monthly Pro ($4.99/month)
   - Display Name: "Track Habit Pro - Monthly"
   - Description: "Unlimited habits, advanced analytics, custom themes"
   
2. Yearly Pro ($29.99/year) - SAVE 50%
   - Display Name: "Track Habit Pro - Yearly"
   - Description: "Unlimited habits + all pro features. Save 50%!"
   
3. Lifetime (optional) ($49.99)
   - Display Name: "Track Habit Pro - Lifetime"
   - Description: "One-time payment, lifetime access to all pro features"
```

**IAP Screenshot:**
- Покажіть екран з unlock функціями
- Або скріншот PaywallView

### ✅ Subscription Management
**Обов'язково якщо є підписки:**

- [ ] Додати посилання в Settings:
  ```swift
  Link("Manage Subscriptions", destination: URL(string: "https://apps.apple.com/account/subscriptions")!)
  ```
  
- [ ] Показати Terms of Service
- [ ] Показати Privacy Policy
- [ ] Показати ціну та renewal terms

---

## 7️⃣ Age Rating

**Статус: 📝 ПОТРІБНО ЗАПОВНИТИ**

App Store Connect → Age Rating → Complete Questionnaire

**Для habit tracker:**
```
Realistic Violence: None
Cartoon/Fantasy Violence: None
Sexual Content: None
Nudity: None
Profanity/Crude Humor: None
Horror/Fear Themes: None
Mature/Suggestive Themes: None
Alcohol/Tobacco/Drug Use: None
Gambling: None
Medical/Treatment Info: None (якщо НЕ medical app)
```

**Результат:** 4+ (доступно для всіх)

---

## 8️⃣ TestFlight - Beta Information

### ✅ Test Information
**Статус: 📝 ПОТРІБНО ЗАПОВНИТИ**

**What to Test:**
```
🎉 Track Habit - Version 1.0

This is the first beta release. Please test all core features:

✅ CORE FEATURES:
• Creating and editing habits
• Daily check-ins and tracking
• Viewing statistics and charts
• Setting reminders
• iCloud sync (test on 2+ devices)
• Dark/Light theme switching

✅ PRO FEATURES (if unlocked):
• Unlimited habits (try adding 10+)
• Advanced analytics
• Custom themes

📧 FEEDBACK:
Report any bugs or suggestions to: AndriyPopovich_temp@icloud.com

Known Issues:
• None yet!

Thank you for testing! 🚀
```

### ✅ Beta App Review Information
```
First Name: Andriy
Last Name: Popovich
Phone: [Ваш номер]
Email: AndriyPopovich_temp@icloud.com

Sign-in Required: NO
(або YES + test account якщо потрібен)

Notes:
"Track Habit is a habit tracking app with iCloud sync and in-app subscriptions. All features are accessible without login. IAP testing available in sandbox."
```

### ✅ Export Compliance
**Обов'язково!**

```
Does your app use encryption? YES

Is your app exempt from encryption export compliance? YES

Why: App only uses standard encryption (HTTPS) provided by iOS frameworks.
```

---

## 9️⃣ Code Review - Що може відхилити Apple

### ⚠️ Критичні помилки:

#### 1. Missing Restore Purchases
**Статус: 🔍 ПОТРІБНО ПЕРЕВІРИТИ**

Apple вимагає кнопку "Restore Purchases" для IAP.

**Де додати:**
```swift
// В PaywallView або SettingsView
Button("Restore Purchases") {
    Task {
        await storeManager.restore()
    }
}
```

**Перевірте в StoreManager.swift:**
```swift
func restore() async {
    // Має бути метод restore
}
```

#### 2. Missing Subscription Terms
**Статус: 🔍 ПОТРІБНО ПЕРЕВІРИТИ**

В PaywallView мають бути:
- [ ] Ціна та duration
- [ ] Auto-renewal terms
- [ ] Cancellation policy
- [ ] Privacy Policy посилання
- [ ] Terms of Service посилання

**Приклад:**
```swift
Text("Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. Payment will be charged to your Apple ID account.")
    .font(.caption)
    .foregroundColor(.secondary)

Link("Privacy Policy", destination: URL(string: "https://trackhabit.app/privacy")!)
Link("Terms of Service", destination: URL(string: "https://trackhabit.app/terms")!)
```

#### 3. Placeholder Content
**Статус: ✅ ПЕРЕВІРТЕ**

- ❌ Не залишайте "Lorem ipsum"
- ❌ Не залишайте "test@example.com"
- ❌ Не залишайте "Coming soon"
- ❌ Не показуйте пусті екрани в screenshots

#### 4. Missing Error Handling
**Статус: 🔍 РЕКОМЕНДОВАНО**

Показувати user-friendly помилки:
```swift
.alert("Error", isPresented: $showError) {
    Button("OK", role: .cancel) {}
} message: {
    Text("Failed to load purchases. Please check your internet connection.")
}
```

#### 5. Hardcoded Text (Localization)
**Статус: ✅ У вас є локалізація!**

Перевірте що всі тексти локалізовані:
- Settings
- Onboarding
- PaywallView
- Alerts & Errors

---

## 🔟 Final Checklist перед Submit

### Pre-flight:
- [ ] Запустити на реальному пристрої (не тільки симулятор)
- [ ] Перевірити IAP в Sandbox mode
- [ ] Тест iCloud sync на 2+ пристроях
- [ ] Перевірити нагадування (notifications)
- [ ] Тест Dark/Light theme
- [ ] Перевірити українську/англійську локалізацію
- [ ] Force quit + relaunch (перевірка збереження даних)

### App Store Connect:
- [ ] App Description написано (4000 chars)
- [ ] Keywords додано (100 chars)
- [ ] Screenshots upload (мін 3)
- [ ] App Icon 1024x1024 upload
- [ ] Privacy Policy URL додано
- [ ] Privacy Nutrition Labels заповнено
- [ ] Age Rating completed (4+)
- [ ] IAP metadata complete
- [ ] Contact info (AndriyPopovich_temp@icloud.com) ✅

### TestFlight:
- [ ] Beta App Description написано
- [ ] What to Test інструкції
- [ ] Beta Review info заповнено
- [ ] Export Compliance answered

### Code:
- [ ] Restore Purchases button є
- [ ] Subscription terms показані
- [ ] Error handling для IAP
- [ ] No placeholder content
- [ ] All text localized
- [ ] No debug prints у production

---

## 🚨 Типові причини відхилення

### 1. Guideline 2.1 - App Completeness
❌ "App crashes on launch"
✅ **Рішення:** Тестувати на реальному пристрої, додати crash analytics

### 2. Guideline 3.1.1 - In-App Purchase
❌ "Missing restore purchases button"
✅ **Рішення:** Додати кнопку Restore в PaywallView/Settings

❌ "Subscription terms not displayed"
✅ **Рішення:** Показати auto-renewal terms, cancellation policy

### 3. Guideline 5.1.1 - Privacy
❌ "Privacy policy missing"
✅ **Рішення:** Створити і upload privacy policy URL

❌ "Privacy nutrition labels incomplete"
✅ **Рішення:** Заповнити всі data collection fields

### 4. Guideline 4.2 - Minimum Functionality
❌ "App is just a wrapper for website"
✅ **Ваш додаток OK** - native SwiftUI app

### 5. Guideline 2.3.10 - Accurate Metadata
❌ "Screenshots don't match app functionality"
✅ **Рішення:** Використати реальні screenshots з актуальним UI

---

## ✅ Ready to Submit!

Коли все зроблено:
1. Archive → Upload до App Store Connect
2. Почекати "Processing" (10-60 хв)
3. App Store Connect → TestFlight → External Testing
4. Create New Group → Add Testers
5. Submit for Review → Очікування 1-3 дні

---

## 📞 Контакти

**Developer:** Andriy Popovich  
**Email:** AndriyPopovich_temp@icloud.com  
**Support:** AndriyPopovich_temp@icloud.com ✅

---

## 🎯 Priority Actions

### 🔴 High Priority (зробити зараз):
1. ✅ **Email додано** → AndriyPopovich_temp@icloud.com
2. ⚠️ **Privacy Policy** → створити і upload
3. ⚠️ **Screenshots** → мінімум 3 для iPhone 6.7"
4. ⚠️ **App Description** → написати для App Store
5. ⚠️ **Restore Purchases** → перевірити чи є в коді

### 🟡 Medium Priority (перед submit):
6. Privacy Nutrition Labels → заповнити
7. Age Rating → пройти questionnaire
8. Beta App Description → написати What to Test
9. IAP Screenshots → upload для кожної підписки

### 🟢 Low Priority (can do later):
10. Promotional Text → додати seasonal messaging
11. Terms of Service → створити (опціонально)
12. Localized Screenshots → Ukrainian + English versions

---

**Статус:** 🟡 Майже готово! Потрібно Privacy Policy та Screenshots.

**Estimated time to submit:** 2-4 години роботи

**Good luck! 🚀**
