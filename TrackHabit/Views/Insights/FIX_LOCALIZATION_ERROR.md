# 🔧 Виправлення помилки локалізації

## Проблема:
```
Multiple commands produce 'en.lprojLocalizable.strings'
Multiple commands produce 'uk.lprojLocalizable.strings'
```

Файли створені неправильно. Потрібно створити їх вручну в Xcode.

## ✅ Рішення:

### Крок 1: Видаліть неправильні файли

У Xcode Project Navigator:
1. Знайдіть файли `uk.lprojLocalizable.strings` та `en.lprojLocalizable.strings`
2. Клікніть правою кнопкою → Delete
3. Виберіть "Move to Trash"

### Крок 2: Створіть правильну локалізацію

#### А) Створіть базовий файл:

1. У Xcode: **File → New → File...**
2. Виберіть **Strings File**
3. Назвіть файл: `Localizable` (БЕЗ розширення .strings!)
4. Збережіть у головній папці проекту
5. Натисніть **Create**

#### Б) Додайте локалізації:

1. Виберіть файл `Localizable.strings` у Project Navigator
2. Відкрийте **File Inspector** (права панель, іконка 📄)
3. Знайдіть секцію **Localization**
4. Натисніть кнопку **Localize...**
5. Виберіть **English** → Localize
6. Тепер натисніть **+** під Localizations
7. Виберіть **Ukrainian (uk)**
8. Поставте галочку біля `Localizable.strings`

#### В) Тепер у вас буде:
```
▼ Localizable.strings
  ├── Localizable.strings (English)
  └── Localizable.strings (Ukrainian)
```

### Крок 3: Скопіюйте переклади

#### Для української (uk):
1. Клікніть на `Localizable.strings (Ukrainian)`
2. Скопіюйте вміст з файлу нижче ↓

```strings
/* 🇺🇦 Ukrainian Localization */

// MARK: - Категорії
"achievement.category.streaks" = "Серії";
"achievement.category.completions" = "Виконання";
"achievement.category.habits" = "Звички";
"achievement.category.consistency" = "Постійність";
"achievement.category.milestones" = "Віхи";
"achievement.category.special" = "Особливі";
"achievement.category.all" = "Всі";

// MARK: - Загальне
"achievement.unlocked" = "ДОСЯГНЕННЯ ВІДКРИТО!";
"achievements.title" = "Досягнення";
"achievements.of" = "з";
"achievements.common" = "Звичайні";
"achievements.rare" = "Рідкісні";
"achievements.legendary" = "Легендарні";
"achievements.unlocked_on" = "Відкрито";
"achievements.progress" = "Прогрес";
"achievements.category" = "Категорія";
"achievements.rarity" = "Рідкість";
"achievements.requirement" = "Вимога";
"achievements.done" = "Готово";

// MARK: - Рідкість
"achievements.rarity.common" = "Звичайне";
"achievements.rarity.uncommon" = "Незвичайне";
"achievements.rarity.rare" = "Рідкісне";
"achievements.rarity.epic" = "Епічне";
"achievements.rarity.legendary" = "Легендарне";

// MARK: - Перші кроки (5)
"achievement.first_habit.title" = "Перший блін";
"achievement.first_habit.description" = "Створено першу звичку! Як кажуть, перший блін комом, але у тебе вийшов ідеальний! 🥞";

"achievement.first_checkin.title" = "Зробив справу!";
"achievement.first_checkin.description" = "Перше виконання! Гарний початок — це вже половина справи, як казала баба 👵";

"achievement.three_habits.title" = "Три богатирі";
"achievement.three_habits.description" = "Три звички — міцна команда! Як три богатирі, тільки без коней 🐴";

"achievement.five_habits.title" = "П'ятірочка!";
"achievement.five_habits.description" = "5 звичок! Як п'ять пальців на руці — всі потрібні! ✋";

"achievement.ten_habits.title" = "Збірна України";
"achievement.ten_habits.description" = "10 звичок! Ціла команда готова перемагати! 🇺🇦⚽";

// MARK: - Серії (10)
"achievement.streak_3.title" = "Розігрівся!";
"achievement.streak_3.description" = "3 дні поспіль! Вогник розгорається 🔥";

"achievement.streak_7.title" = "Тиждень сили!";
"achievement.streak_7.description" = "7 днів без пропусків! Як робочий тиждень, тільки з мотивацією 💪";

"achievement.streak_14.title" = "Двотижневик";
"achievement.streak_14.description" = "14 днів! Як відпустка, тільки корисніша ☀️";

"achievement.streak_21.title" = "Три тижні = Звичка";
"achievement.streak_21.description" = "21 день! Кажуть, це час формування звички. Тепер офіційно! 📜";

"achievement.streak_30.title" = "Місяць мотивації";
"achievement.streak_30.description" = "Цілий місяць! Як зарплата — прийшов регулярно! 💰";

"achievement.streak_50.title" = "Півсотні!";
"achievement.streak_50.description" = "50 днів! Як півсотня на весіллі — важлива віха! 🎊";

"achievement.streak_100.title" = "Сотка!";
"achievement.streak_100.description" = "100 днів поспіль! Як перша зарплата в доларах — круто звучить! 💯";

"achievement.streak_200.title" = "Двісті — не жарти!";
"achievement.streak_200.description" = "200 днів! Це вже не серія, це образ життя! 🚀";

"achievement.streak_365.title" = "Ювілей року!";
"achievement.streak_365.description" = "Рік без пропусків! Як Новий рік — раз на рік, але ти це зробив! 🎆";

"achievement.streak_500.title" = "Півтисячі = Легенда";
"achievement.streak_500.description" = "500 днів! Ти вже легенда, як Тарас Шевченко! 👑📚";

// MARK: - Виконання (10)
"achievement.checkins_10.title" = "Десятка!";
"achievement.checkins_10.description" = "10 виконань! Як перша десятка в щоденнику — приємно! ✏️";

"achievement.checkins_25.title" = "Чвертьсотня";
"achievement.checkins_25.description" = "25 разів! Як копійки в скарбничці — збираються! 🪙";

"achievement.checkins_50.title" = "Півсотні виконань";
"achievement.checkins_50.description" = "50 виконань! Як святкувати ювілей — гучно та весело! 🎉";

"achievement.checkins_100.title" = "Сотка виконань!";
"achievement.checkins_100.description" = "100 виконань! Це вже не просто звичка, це професія! 💼";

"achievement.checkins_250.title" = "Чверть тисячі";
"achievement.checkins_250.description" = "250 разів! Як кіно подивитись — але корисніше! 🎬";

"achievement.checkins_500.title" = "П'ятсот!";
"achievement.checkins_500.description" = "500 виконань! Як гривень в гаманці — приємно рахувати! 💵";

"achievement.checkins_1000.title" = "Тисяча!";
"achievement.checkins_1000.description" = "1000 виконань! Як «Тисяча і одна ніч», тільки днів! 🌙✨";

"achievement.checkins_2000.title" = "Дві тисячі!";
"achievement.checkins_2000.description" = "2000 разів! Як рік — звучить масштабно! 🗓️";

"achievement.checkins_5000.title" = "П'ять тисяч!";
"achievement.checkins_5000.description" = "5000 виконань! Ти — мегазірка, як співак на фестивалі! 🎤⭐";

"achievement.checkins_10000.title" = "Десять тисяч!";
"achievement.checkins_10000.description" = "10 000 разів! Ти вже майстер, як козак з булавою! ⚔️";

// MARK: - Постійність (10)
"achievement.perfect_week.title" = "Ідеальний тиждень";
"achievement.perfect_week.description" = "Всі звички 7 днів поспіль! Як ідеальна неділя — тільки без сала! 🥓";

"achievement.perfect_month.title" = "Досконалий місяць";
"achievement.perfect_month.description" = "30 днів без пропусків! Як зарплата — прийшла вчасно! 💰";

"achievement.early_bird.title" = "Жайворонок";
"achievement.early_bird.description" = "7 виконань до 8 ранку! Як бабуся на ринку — рано і продуктивно! 🌅👵";

"achievement.night_owl.title" = "Нічна пташка";
"achievement.night_owl.description" = "7 виконань після 22:00! Як студент перед сесією — працює вночі! 🌙📚";

"achievement.weekend_warrior.title" = "Воїн вихідних";
"achievement.weekend_warrior.description" = "10 ідеальних вікендів! Як шашлик на природі — обов'язкова програма! 🍖🏕️";

"achievement.all_habits_day.title" = "День перемоги";
"achievement.all_habits_day.description" = "Всі звички за один день! Як зібрати всю родину на свята! 🎄👨‍👩‍👧‍👦";

"achievement.comeback_kid.title" = "Повернувся!";
"achievement.comeback_kid.description" = "Відновив серію після падіння! Як футболіст після травми — сильніший! ⚽💪";

"achievement.no_skip_month.title" = "Без вихідних";
"achievement.no_skip_month.description" = "30 днів щодня! Як працювати в селі — без вихідних! 🚜";

"achievement.goal_crusher.title" = "Дробитель цілей";
"achievement.goal_crusher.description" = "10 цілей виконано! Як борщ зварити — все по рецепту! 🥣";

"achievement.overachiever.title" = "Перфекціоніст";
"achievement.overachiever.description" = "50 разів перевиконав ціль! Як відмінник у школі! 📚🅰️";

// MARK: - Віхи (10)
"achievement.one_week.title" = "Перший тиждень";
"achievement.one_week.description" = "7 днів з програмою! Як перша неділя на роботі! 📅";

"achievement.one_month.title" = "Місяць разом";
"achievement.one_month.description" = "30 днів! Як пройти випробувальний термін! ✅";

"achievement.three_months.title" = "Квартал сили";
"achievement.three_months.description" = "3 місяці! Як сезон — зима, весна, літо або осінь! 🍂";

"achievement.six_months.title" = "Півроку!";
"achievement.six_months.description" = "Пів року разом! Як до Нового року — але вже зараз! 🎄";

"achievement.one_year.title" = "Ювілей року!";
"achievement.one_year.description" = "Цілий рік! Як весілля відсвяткувати — гучно та весело! 💒🎊";

"achievement.two_years.title" = "Два роки!";
"achievement.two_years.description" = "Два роки! Як дитина вже говорити вміє! 👶💬";

"achievement.habit_master.title" = "Майстер звичок";
"achievement.habit_master.description" = "100 днів підряд! Ти — майстер, як гончар за кругом! 🏺";

"achievement.dedication.title" = "Відданість справі";
"achievement.dedication.description" = "3+ звички 90 днів! Як служити в армії — важко, але гартує! 🎖️";

"achievement.resilient.title" = "Незламний";
"achievement.resilient.description" = "5 разів відновив серію! Як козак після бою — не здається! ⚔️🛡️";

"achievement.legendary_status.title" = "Легендарний статус";
"achievement.legendary_status.description" = "40 досягнень! Ти — легенда, як Кобзар! 👑📖";

// MARK: - Особливі (10)
"achievement.new_year_new_me.title" = "З Новим роком!";
"achievement.new_year_new_me.description" = "Звичка 1 січня! Як обіцянка під бій курантів! 🎆🥂";

"achievement.birthday_celebration.title" = "День народження";
"achievement.birthday_celebration.description" = "Виконання в день народження! Як задути свічки на торті! 🎂🕯️";

"achievement.leap_day.title" = "Високосний день";
"achievement.leap_day.description" = "Виконання 29 лютого! Рідкісність, як кінь п'ятикопійчаний! 🦄";

"achievement.midnight_warrior.title" = "Полуночник";
"achievement.midnight_warrior.description" = "Виконання о 00:00! Як Попелюшка — але не втікаєш! 🕐👸";

"achievement.multitasker.title" = "Багатозадачник";
"achievement.multitasker.description" = "5+ звичок за день! Як мама на кухні — все встигає! 👩‍🍳🍳";

"achievement.speed_demon.title" = "Швидкісник";
"achievement.speed_demon.description" = "10 виконань за годину! Швидше, ніж маршрутка в годину пік! 🚐💨";

"achievement.social_butterfly.title" = "Метелик";
"achievement.social_butterfly.description" = "Поділився досягненням! Як розповісти новини сусідам! 🦋🗣️";

"achievement.collector.title" = "Колекціонер";
"achievement.collector.description" = "25 досягнень! Як марки збирати — з любов'ю! 📬🎖️";

"achievement.perfectionist.title" = "Ідеаліст";
"achievement.perfectionist.description" = "30 днів 100%! Як прибирання перед святами — все ідеально! ✨🧹";

"achievement.unlock_all.title" = "Збірка завершена!";
"achievement.unlock_all.description" = "Всі 49 досягнень! Ти — чемпіон, як збірна на Олімпіаді! 🏆🥇";
```

#### Для англійської (en):
1. Клікніть на `Localizable.strings (English)`
2. Вставте англійські переклади з файлу `ACHIEVEMENTS_LOCALIZATIONS.md`

### Крок 4: Clean Build

1. **Product → Clean Build Folder** (Shift+Cmd+K)
2. **Product → Build** (Cmd+B)

## ✅ Перевірка:

Після build у вас має бути:
```
Build/Products/Debug-iphoneos/YourApp.app/
├── en.lproj/
│   └── Localizable.strings
└── uk.lproj/
    └── Localizable.strings
```

## 🎯 Альтернативний спосіб (якщо перший не спрацював):

1. У Project Settings → Info → Localizations
2. Натисніть **+**
3. Додайте **Ukrainian**
4. Поставте галочку біля `Localizable.strings`
5. Повторіть для English (якщо немає)

---

**Примітка:** Файли `uk.lprojLocalizable.strings` та `en.lprojLocalizable.strings` були створені неправильно і їх потрібно видалити!
