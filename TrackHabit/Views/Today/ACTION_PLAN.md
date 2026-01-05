# ⚡ ACTION PLAN - Готовність до External Testing

**Дата:** 5 січня 2026  
**Час до готовності:** ~1-2 години  
**Статус:** 75% готово ✅

---

## 🎯 Три головні завдання

### 🔴 1. PRIVACY POLICY (30 хвилин) - ОБОВ'ЯЗКОВО
**Чому:** Apple вимагає для всіх IAP apps, без цього - rejection

**Що робити:**
1. Перейти на: https://www.privacypolicygenerator.info/
2. Заповнити:
   - App: **Track Habit**
   - Email: **AndriyPopovich_temp@icloud.com**
   - Features: iCloud, IAP, Notifications
3. Generate → Copy текст
4. Upload на GitHub Pages або Google Docs (публічний доступ)
5. Отримати URL
6. Зберегти URL для App Store Connect

**Альтернатива:** Використати готовий template з `FINAL_EXTERNAL_TESTING_CHECKLIST.md`

**Результат:** URL типу `https://trackhabit.app/privacy`

---

### 🔴 2. SCREENSHOTS (30 хвилин) - ОБОВ'ЯЗКОВО
**Чому:** Apple вимагає мінімум 3 screenshots для review

**Що робити:**
1. **Підготувати дані:**
   - Відкрити додаток
   - Створити 4-5 реалістичних звичок:
     * 🧘 Meditation (виконано)
     * 📚 Read 30 min (виконано)
     * 💪 Workout (не виконано)
     * 🌱 Drink water (виконано)
     * 📝 Journal (не виконано)
   - Додати check-ins для історії

2. **Запустити simulator:**
   - iPhone 15 Pro Max (6.7")
   - Або iPhone 14 Pro Max (6.5")

3. **Зробити screenshots (Cmd + S):**
   - Screenshot 1: Головний екран зі звичками
   - Screenshot 2: Статистика з графіками
   - Screenshot 3: Екран деталей звички
   - Screenshot 4 (optional): Settings або About
   - Screenshot 5 (optional): Onboarding

4. **Знайти на Desktop**

**Важливо:**
- ✅ Світла тема (легше читати)
- ✅ Реальні дані
- ❌ Не порожні екрани
- ❌ Не "Test Habit"

---

### 🟡 3. APP STORE CONNECT (20 хвилин) - ВАЖЛИВО
**Чому:** Metadata потрібний для review

**Що робити:**
1. **Privacy Policy URL:**
   - App Store Connect → App Information
   - Вставити URL з кроку 1

2. **Screenshots:**
   - App Store Connect → App Store → Media
   - Upload screenshots з кроку 2

3. **Privacy Nutrition Labels:**
   - App Store Connect → App Privacy
   - Відповісти на питання:
     * User ID (iCloud) - YES
     * Purchase History - YES
     * Fitness Data (habits) - YES
   - Детальні інструкції в `FINAL_EXTERNAL_TESTING_CHECKLIST.md`

4. **Age Rating:**
   - App Store Connect → Age Rating
   - "None" на всі питання → 4+

5. **Export Compliance:**
   - TestFlight → Export Compliance
   - Uses encryption: YES
   - Exempt: YES (HTTPS only)

---

## ⚡ Швидка перевірка перед початком

### Перевірити що код готовий (5 хвилин):

```bash
# Checklist:
1. ✅ Відкрити Xcode
2. ✅ Target TrackHabit → Signing & Capabilities
3. ✅ Перевірити: App Groups → group.com.trackhabit.shared
4. ✅ Target TrackHabitWidgets → теж саме
5. ✅ Product → Clean Build Folder
6. ✅ Restart Xcode
7. ✅ Build проєкт (Cmd + B)
8. ✅ Run (Cmd + R)
9. ✅ Перевірити Console: "✅ ModelContainer created successfully"
```

**Якщо помилка "Unable to find App Group":**
→ Дивись `QUICK_FIX_APP_GROUP.md` (3 хв виправлення)

---

## 📋 Фінальний Checklist

### Перед Submit for External Testing:

#### Code & Build:
- [ ] ✅ App Group працює (group.com.trackhabit.shared)
- [ ] ✅ Додаток запускається без crashes
- [ ] ✅ Email AndriyPopovich_temp@icloud.com працює (Settings → Contact)
- [ ] ✅ Restore Purchases кнопка є (Paywall)
- [ ] ✅ iCloud sync працює
- [ ] ✅ Обидві мови працюють (UK + EN)

#### App Store Connect:
- [ ] 🔴 Privacy Policy URL додано
- [ ] 🔴 Screenshots upload (мінімум 3)
- [ ] 🟡 Privacy Nutrition Labels заповнено
- [ ] 🟡 Age Rating: 4+
- [ ] 🟡 Export Compliance: answered

#### TestFlight:
- [ ] 🟢 Build uploaded
- [ ] 🟢 Build status: "Ready to Submit"
- [ ] 🟢 What to Test написано
- [ ] 🟢 Beta description написано

---

## 🚀 Submit процес

**Коли все зроблено:**

1. TestFlight → External Testing
2. Вибрати build
3. Test Information:
   - What to Test: "Initial beta. Test creating habits, completions, statistics."
   - Feedback Email: AndriyPopovich_temp@icloud.com
4. **Submit for Review**
5. Чекати 1-3 дні

**Email notification:**
```
"Your app is ready for external testing"
```

---

## ⏱️ Timeline

### Сьогодні (5 січня):
- [x] App Group виправлено ✅
- [x] Email додано ✅
- [x] Restore Purchases покращено ✅
- [ ] Privacy Policy (30 хв) ⬅️ ЗАРАЗ
- [ ] Screenshots (30 хв) ⬅️ ЗАРАЗ
- [ ] App Store Connect (20 хв) ⬅️ ПОТІМ

### Завтра (6 січня):
- [ ] Submit for External Testing ⬅️ РАНОК
- [ ] Чекати review

### 7-9 січня:
- ⏳ Apple review (1-3 дні)

### 10+ січня:
- ✅ Approved!
- 📱 Invite testers
- 🐛 Beta testing (2-3 тижні)

### Кінець січня:
- 🚀 Production submit
- 🎉 App Store launch!

---

## 💡 Швидкі поради

### Privacy Policy:
- Використайте генератор (5 хв) - швидше ніж писати самому
- GitHub Pages - безкоштовно і швидко
- Або Google Docs з публічним доступом

### Screenshots:
- Робіть на светлій темі - краще видно
- Використайте реальні емоджі і назви
- Не обов'язково додавати текст - Apple приймає і чисті screenshots

### App Store Connect:
- Privacy Labels - не лякайтеся форми, просто чесно відповідайте
- Age Rating - для трекера звичок завжди 4+
- Export Compliance - стандартна відповідь для всіх iOS apps

---

## 🆘 Якщо щось не працює

### App Group помилка:
→ `QUICK_FIX_APP_GROUP.md` (3 хв)

### Widget не показує дані:
→ `APP_GROUP_SETUP_GUIDE.md` (детальний troubleshooting)

### Загальні питання:
→ `FINAL_EXTERNAL_TESTING_CHECKLIST.md` (повний гайд)

### Про Apple requirements:
→ `READY_FOR_EXTERNAL_TESTING.md` (що може відхилити Apple)

---

## 📞 Контакти

**Developer:** Andriy Popovich  
**Email:** AndriyPopovich_temp@icloud.com ✅  
**App:** Track Habit  
**Version:** 1.0  

---

## ✅ TL;DR (Дуже коротко)

**Що зробити зараз:**
1. Privacy Policy (30 хв) → https://www.privacypolicygenerator.info/
2. Screenshots (30 хв) → iPhone 15 Pro Max simulator, Cmd+S
3. App Store Connect (20 хв) → Upload всього вище

**Total:** ~1-2 години

**Потім:** Submit → чекати 1-3 дні → Beta testing! 🎉

---

**START NOW! 🚀**

Питання? AndriyPopovich_temp@icloud.com
