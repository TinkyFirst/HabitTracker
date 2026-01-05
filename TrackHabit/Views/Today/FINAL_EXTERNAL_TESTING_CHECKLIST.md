# ✅ ФІНАЛЬНИЙ CHECKLIST: Перед External Testing

**Дата оновлення:** 5 січня 2026  
**Email контакт:** AndriyPopovich_temp@icloud.com ✅  
**App Group:** group.com.trackhabit.shared ✅

---

## 🎯 Що вже готово

### ✅ Код і функціонал
- [x] Email контакт додано в SettingsView.swift
- [x] Email контакт додано в AboutView.swift
- [x] App Group виправлено (group.com.trackhabit.shared)
- [x] SharedModelContainer використовує App Group
- [x] Widgets мають доступ до даних
- [x] Restore Purchases кнопка є в PaywallView
- [x] Subscription terms показано в PaywallView
- [x] Локалізація (Ukrainian + English)
- [x] Онбординг з анімаціями
- [x] iCloud sync працює
- [x] Темна/світла тема
- [x] Нагадування
- [x] Статистика та графіки
- [x] AboutView з повною інформацією

### ✅ Документація
- [x] QUICK_FIX_APP_GROUP.md - швидке виправлення помилки
- [x] APP_GROUP_SETUP_GUIDE.md - детальний гайд
- [x] READY_FOR_EXTERNAL_TESTING.md - checklist
- [x] TestFlight інструкції для тестерів

---

## 🔴 ЩО ТРЕБА ЗРОБИТИ ЗАРАЗ (Обов'язково!)

### 1. Перевірити App Group в Xcode (5 хвилин) ⚠️

**Дії:**
1. Відкрийте проєкт в Xcode
2. Виберіть target **TrackHabit**
3. Signing & Capabilities → перевірте що є **App Groups**
4. Переконайтесь що галочка стоїть біля: `group.com.trackhabit.shared`
5. Повторіть для target **TrackHabitWidgets**
6. Clean Build Folder (Cmd + Shift + K)
7. Перезапустіть Xcode
8. Build проєкт

**Перевірка:**
- Запустіть додаток
- В Console шукайте: `✅ ModelContainer created successfully with App Group`
- Якщо бачите - все працює!

**Якщо помилка:**
- Дивіться `QUICK_FIX_APP_GROUP.md` - швидке виправлення за 3 хвилини

---

### 2. Створити Privacy Policy (30 хвилин) 🔴 КРИТИЧНО

**Чому обов'язково:**
- Apple вимагає Privacy Policy для ВСІХ додатків з IAP
- Без цього - автоматичний rejection

**Як зробити:**

**Варіант А: Використати генератор (швидко)**
1. Перейдіть на: https://www.privacypolicygenerator.info/
2. Заповніть форму:
   - App Name: **Track Habit**
   - Email: **AndriyPopovich_temp@icloud.com**
   - Features: iCloud sync, In-App Purchases, Push Notifications
3. Generate Policy
4. Copy текст

**Варіант Б: Використати готовий шаблон (нижче)**

**Де розмістити:**
- GitHub Pages (безкоштовно): https://pages.github.com/
- Або простий hosting (Netlify, Vercel)
- Або навіть Google Docs з публічним доступом

**Приклад тексту:**

```markdown
# Privacy Policy for Track Habit

Last updated: January 5, 2026

## Introduction

Track Habit ("we", "our", or "us") respects your privacy and is committed to protecting your personal data.

## Data We Collect

### Information You Provide:
- Habit names and descriptions you create
- Check-in times and dates
- Notes and goals you add to habits
- Notification preferences
- App settings and preferences

### Automatically Collected:
- Device information (for crash reporting)
- Purchase history (for subscription management)
- iCloud User ID (for synchronization)

## How We Use Your Data

- **iCloud Sync:** Store your habits across your devices
- **Purchases:** Manage your subscription status
- **Notifications:** Send reminders you configured
- **Analytics:** Improve app performance (optional)

## Data Storage

- All habit data stored in your **private iCloud** account
- We don't have access to your personal data
- Your data is encrypted in transit and at rest
- You can delete all data anytime from Settings

## Data Sharing

We do NOT:
- ❌ Sell your data
- ❌ Track you across websites
- ❌ Share data with third parties for marketing
- ❌ Show ads

## Your Rights

You can:
- ✅ Access all your data (it's in the app!)
- ✅ Delete your data (Settings → Delete All)
- ✅ Export your data
- ✅ Contact us with questions

## In-App Purchases

- Subscription managed through Apple
- Cancel anytime via App Store subscriptions
- No refunds for partial periods (Apple policy)

## Children's Privacy

Track Habit is suitable for ages 4+. We don't knowingly collect data from children under 13 without parental consent.

## Changes to This Policy

We may update this policy. Check this page for updates.

## Contact Us

Questions? Email us:
**AndriyPopovich_temp@icloud.com**

Or visit our website:
**https://trackhabit.app**

---

© 2026 Track Habit. All rights reserved.
```

**Після створення:**
1. Upload на hosting
2. Отримайте URL (наприклад: https://trackhabit.app/privacy)
3. Запишіть цей URL - він потрібен в App Store Connect

---

### 3. Зробити Screenshots (30 хвилин) 🔴 КРИТИЧНО

**Вимоги Apple:**
- Мінімум **3 screenshots** для iPhone 6.7" (iPhone 15 Pro Max)
- Або хоча б для iPhone 6.5" (iPhone 14 Pro Max)

**Покрокова інструкція:**

1. **Підготуйте тестові дані:**
   - Відкрийте додаток на симуляторі
   - Створіть 4-5 звичок з реалістичними назвами:
     * 🧘 Meditation (виконано)
     * 📚 Read 30 minutes (виконано)
     * 💪 Workout (не виконано)
     * 🌱 Drink water (виконано)
     * 📝 Journal (не виконано)
   - Додайте кілька check-ins для історії
   - Перейдіть на екран статистики - щоб були графіки

2. **Запустіть правильний simulator:**
   - Xcode → Window → Devices and Simulators
   - Виберіть **iPhone 15 Pro Max** (6.7")
   - Або **iPhone 14 Pro Max** (6.5")

3. **Зробіть screenshots (Cmd + S):**

   **Screenshot 1: Головний екран**
   - Покажіть список звичок (4-5 штук)
   - Деякі виконані, деякі ні
   - Світла тема (легше читати)
   
   **Screenshot 2: Статистика**
   - Екран з графіками
   - Показує прогрес за тиждень/місяць
   - Streak indicators
   
   **Screenshot 3: Екран деталей звички**
   - Відкрийте одну звичку
   - Покажіть історію check-ins
   - Calendar view
   
   **Screenshot 4 (опціонально): Settings або About**
   - Красивий екран з функціями
   
   **Screenshot 5 (опціонально): Onboarding**
   - Перший екран онбордингу
   - Показує цінність додатку

4. **Де знайти screenshots:**
   - Desktop (Робочий стіл)
   - Файли типу: `Simulator Screen Shot - iPhone 15 Pro Max - 2026-01-05...png`

5. **Обробка (опціонально):**
   - Можна додати text labels (в Preview або Figma)
   - Або upload як є

**Важливо:**
- ✅ Реальні дані (не "Test Habit")
- ✅ Красиво оформлено
- ✅ Світла тема (краще видно)
- ❌ Не порожні екрани
- ❌ Не особиста інформація

---

### 4. Заповнити App Store Connect Metadata (20 хвилин) 🟡

**Що заповнити:**

#### A. Privacy Policy URL
- App Store Connect → App Information
- Privacy Policy URL: **[ваш URL з кроку 2]**
- Наприклад: `https://trackhabit.app/privacy`

#### B. App Privacy (Nutrition Labels)
- App Store Connect → App Privacy → Get Started

**Відповідайте:**

```
1. Does your app collect data?
   → YES

2. Data Types:

   a) Identifiers → User ID
      - Linked to User: YES
      - Used for Tracking: NO
      - Purposes: App Functionality (iCloud sync)
   
   b) Purchases → Purchase History
      - Linked to User: YES
      - Used for Tracking: NO
      - Purposes: App Functionality (manage subscriptions)
   
   c) Health & Fitness → Fitness
      - Linked to User: YES
      - Used for Tracking: NO
      - Purposes: App Functionality (habit tracking)
      - Note: Habits як fitness data
   
   d) Usage Data → Product Interaction (якщо є analytics)
      - Linked to User: NO
      - Used for Tracking: NO
      - Purposes: Analytics
```

#### C. Age Rating
- App Store Connect → Age Rating
- Відповідайте **None** на всі питання (violence, sexual content, etc.)
- Результат: **4+** (всі вікові категорії)

#### D. Export Compliance
- TestFlight → Export Compliance Information
- Does your app use encryption? → **YES**
- Is it exempt? → **YES** (uses only standard iOS encryption - HTTPS)

---

### 5. Upload Build до TestFlight (якщо ще не зроблено) 🟡

**Перевірте перед upload:**
- [ ] Version number (наприклад: 1.0)
- [ ] Build number (наприклад: 1)
- [ ] No debug code або test features
- [ ] Працює на simulator БЕЗ crashes

**Upload:**
1. Xcode → Product → Archive
2. Validate App (перевірка перед upload)
3. Distribute App → App Store Connect
4. Upload
5. Очікуйте "Processing" → "Ready to Submit"

---

### 6. Submit for External Testing 🟢

**Коли готово:**
- [x] Privacy Policy URL додано
- [x] Screenshots upload
- [x] Privacy Nutrition Labels заповнено
- [x] Age Rating completed
- [x] Export Compliance answered
- [x] Build uploaded і "Ready to Submit"

**Фінальні кроки:**
1. TestFlight → версія вашого додатку
2. Test Information:
   - What to Test: "Initial beta release. Please test creating habits, marking completions, and viewing statistics."
   - Beta App Description: (copy з APP_STORE_DESCRIPTION.md)
   - Feedback Email: AndriyPopovich_temp@icloud.com
3. **Submit for Review**
4. Чекайте 1-3 дні на Apple approval

---

## 🎯 Швидкий checklist

Відмітьте перед submit:

### Code готовий:
- [ ] App Group працює (group.com.trackhabit.shared)
- [ ] Додаток запускається без crashes
- [ ] Можна створити звичку
- [ ] Можна відмітити як completed
- [ ] Статистика показує дані
- [ ] Widgets працюють (якщо є)
- [ ] Restore Purchases кнопка є
- [ ] iCloud sync працює
- [ ] Обидві мови (UK + EN) працюють

### App Store Connect:
- [ ] Privacy Policy URL додано ⚠️
- [ ] Screenshots upload (3+) ⚠️
- [ ] Privacy Nutrition Labels заповнено ⚠️
- [ ] Age Rating: 4+ ⚠️
- [ ] Export Compliance: answered ⚠️
- [ ] App Description написано
- [ ] Keywords додано
- [ ] Contact info: AndriyPopovich_temp@icloud.com

### TestFlight:
- [ ] Build uploaded
- [ ] Build status: "Ready to Submit"
- [ ] What to Test написано
- [ ] Beta description написано

---

## ⏱️ Скільки часу потрібно

**Якщо все робити зараз:**
- App Group перевірка: **5 хв** ⚠️
- Privacy Policy: **30 хв** 🔴
- Screenshots: **30 хв** 🔴
- App Store Connect metadata: **20 хв** 🟡
- Upload build: **10 хв** 🟡
- Submit: **5 хв** 🟢

**Total: ~1.5-2 години роботи**

**Після submit:**
- Apple review: 1-3 дні ⏳
- Отримаєте email коли approved ✅

---

## 📧 Контакт і підтримка

**Developer:** Andriy Popovich  
**Email:** AndriyPopovich_temp@icloud.com ✅  
**App Name:** Track Habit  
**Bundle ID:** com.trackhabit.app (або ваш)  
**App Group:** group.com.trackhabit.shared ✅

---

## 💡 Поради для успіху

1. **Тестуйте на реальному пристрої**
   - Simulator не завжди показує всі баги
   - TestFlight потребує real device testing

2. **Зробіть fresh install**
   - Видаліть і переустановіть додаток
   - Пройдіть onboarding заново
   - Переконайтесь що все працює

3. **Перевірте обидві мови**
   - Українська: Settings → Мова
   - Англійська: Settings → Language
   - Всі екрани мають бути локалізовані

4. **Test IAP в Sandbox**
   - Xcode → Preferences → Accounts → Sandbox Tester
   - Спробуйте купити підписку
   - Спробуйте Restore Purchases

5. **Запишіть demo відео для себе**
   - Допоможе знайти UX issues
   - Можна показати Apple якщо будуть питання

---

## 🚨 Типові причини rejection (як уникнути)

### ❌ Guideline 3.1.1 - Missing Restore
**Проблема:** Немає кнопки Restore Purchases  
**Ваш статус:** ✅ Є в PaywallView (line 115)

### ❌ Guideline 5.1.1 - No Privacy Policy
**Проблема:** Немає Privacy Policy URL  
**Ваш статус:** ⚠️ Треба створити (крок 2 вище)

### ❌ Guideline 3.1.2 - Unclear Subscription Terms
**Проблема:** Не показано умови підписки  
**Ваш статус:** ✅ Показано в PaywallView legal section

### ❌ Guideline 2.3.10 - Bad Screenshots
**Проблема:** Порожні екрани або тестові дані  
**Ваш статус:** ⚠️ Треба зробити (крок 3 вище)

### ❌ Guideline 2.1 - App Crashes
**Проблема:** Додаток crash при testing  
**Ваш статус:** ⚠️ Перевірте App Group setup!

---

## 🎉 Після Approval

Коли отримаєте email "External Testing Approved":

1. **Invite testers:**
   - TestFlight → External Testing → Add Testers
   - Public Link або Email invites
   
2. **Share link:**
   - Друзям/родині
   - Social media
   - Beta testing communities
   
3. **Collect feedback:**
   - Читайте reviews в TestFlight
   - Email: AndriyPopovich_temp@icloud.com
   - Fix bugs для наступного build
   
4. **Iterate:**
   - 2-3 тижні beta testing
   - Release updates (build 2, 3, etc.)
   - Polish для production

5. **Submit to App Store:**
   - Коли все stable і polished
   - Production review: 1-3 дні
   - 🎉 **LIVE ON APP STORE!**

---

## 📚 Додаткові ресурси

- `QUICK_FIX_APP_GROUP.md` - якщо App Group не працює (3 хв fix)
- `APP_GROUP_SETUP_GUIDE.md` - детальний troubleshooting
- `READY_FOR_EXTERNAL_TESTING.md` - розширений checklist
- `TESTFLIGHT_GUIDE.md` - інструкції для beta testers

---

**Good luck! Ви майже на фініші! 🚀**

Питання? Пишіть: AndriyPopovich_temp@icloud.com
