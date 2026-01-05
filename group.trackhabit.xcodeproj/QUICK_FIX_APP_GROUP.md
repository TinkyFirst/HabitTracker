# 🚀 Швидкий старт: Виправлення App Group помилки

## ❌ Помилка: "Unable to find App Group Container in Entitlements: group.trackhabit"

Ця помилка означає що віджети не можуть отримати доступ до даних додатку.

---

## ✅ Швидке виправлення (3 хвилини)

### Крок 1: Головний додаток (TrackHabit)

1. Відкрийте проєкт в Xcode
2. Виберіть target **TrackHabit** (зліва в списку targets)
3. Перейдіть на вкладку **Signing & Capabilities**
4. Натисніть **+ Capability** → виберіть **App Groups**
5. Поставте галочку біля `group.com.trackhabit.shared`
   - Якщо немає в списку - натисніть **+** і додайте вручну:
     ```
     group.com.trackhabit.shared
     ```

### Крок 2: Widget Extension

1. Виберіть target **TrackHabitWidgets** (або назву вашого widget extension)
2. Перейдіть на вкладку **Signing & Capabilities**
3. Додайте **App Groups** capability (якщо немає)
4. Поставте галочку біля того самого App Group:
   ```
   group.com.trackhabit.shared
   ```

### Крок 3: Clean & Build

1. **Product → Clean Build Folder** (або Cmd + Shift + K)
2. **Перезапустіть Xcode** (важливо!)
3. **Build** проєкт заново (Cmd + B)
4. **Run** на simulator або пристрої

---

## ✅ Перевірка

Після запуску в Console ви повинні побачити:

```
📁 SwiftData storage path: .../Shared/AppGroup/.../TrackHabit.sqlite
✅ ModelContainer created successfully with App Group
```

Якщо бачите це - **проблема вирішена!** 🎉

---

## 🔴 Якщо все ще не працює

### Варіант А: App Group не з'являється в списку

**Причина:** App Group не створено на developer.apple.com

**Рішення:**
1. Зайдіть на [developer.apple.com/account](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles → **Identifiers**
3. Виберіть ваш **App ID** (Bundle ID вашого додатку)
4. Прокрутіть до **App Groups** → поставте галочку
5. Натисніть **Configure**
6. **Create new App Group:** `group.com.trackhabit.shared`
7. **Save**
8. У Xcode: Signing & Capabilities → натисніть **Refresh** (кнопка в правому нижньому куті)

### Варіант Б: App Group є, але помилка залишається

**Причина:** Старі build artifacts

**Рішення:**
1. **Видаліть додаток** з симулятора/пристрою
2. У Xcode: **Product → Clean Build Folder**
3. Закрийте Xcode
4. Видаліть Derived Data:
   ```
   ~/Library/Developer/Xcode/DerivedData/
   ```
   Або: Xcode → Preferences → Locations → Derived Data → Delete
5. Перезапустіть Xcode
6. Rebuild проєкт

### Варіант В: Працює на симуляторі, але не на пристрої

**Причина:** Provisioning profile не містить App Groups

**Рішення:**
1. Xcode → Preferences → Accounts
2. Виберіть ваш Apple ID
3. **Download Manual Profiles**
4. Target → Signing & Capabilities
5. **Automatically manage signing** - вимкнути і увімкнути знову
6. Xcode згенерує новий profile з App Groups

---

## 📝 Що було змінено в коді

### До (не працювало):
```swift
let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false
)
// ❌ Дані тільки в додатку, віджети не мають доступу
```

### Після (працює):
```swift
guard let appGroupURL = FileManager.default.containerURL(
    forSecurityApplicationGroupIdentifier: "group.com.trackhabit.shared"
) else {
    fatalError("Unable to find App Group Container")
}

let storeURL = appGroupURL.appendingPathComponent("TrackHabit.sqlite")

let modelConfiguration = ModelConfiguration(
    schema: schema,
    url: storeURL,  // ✅ Дані в App Group, доступні всім
    isStoredInMemoryOnly: false
)
```

---

## 🎯 Checklist

Перевірте ці пункти:

- [ ] ✅ App Groups capability додано в TrackHabit target
- [ ] ✅ App Groups capability додано в TrackHabitWidgets target
- [ ] ✅ Обидва targets мають **однаковий** App Group: `group.com.trackhabit.shared`
- [ ] ✅ Clean Build зроблено
- [ ] ✅ Xcode перезапущено
- [ ] ✅ Додаток запускається без crashes
- [ ] ✅ В Console з'являється "✅ ModelContainer created successfully"

---

## 📱 Наступні кроки

Після виправлення помилки:

1. **Додайте тестові дані**
   - Створіть 3-5 звичок
   - Відмітьте деякі як виконані

2. **Перевірте віджети**
   - Додайте widget на Home Screen
   - Переконайтесь що звички відображаються

3. **Тестуйте на реальному пристрої**
   - Simulator може поводитись інакше
   - TestFlight потребує тестування на реальних пристроях

4. **Готуйтесь до External Testing**
   - Дивіться `READY_FOR_EXTERNAL_TESTING.md`
   - Privacy Policy, Screenshots, etc.

---

## 💡 Корисні поради

**Де знаходяться дані:**

- **БЕЗ App Group:** кожен target має свої дані (не працює для віджетів)
- **З App Group:** всі targets діляться однією базою даних (працює!)

**Чому це важливо:**

- Віджети - це окремий process
- Вони не мають доступу до app sandbox
- App Groups створює shared контейнер доступний всім

**Production готовність:**

- ✅ Працює на всіх пристроях
- ✅ Дані синхронізуються між додатком і віджетами
- ✅ iCloud sync працює через App Group
- ✅ Готово до TestFlight/App Store

---

## 📚 Додаткові ресурси

- `APP_GROUP_SETUP_GUIDE.md` - детальний гайд з troubleshooting
- `WIDGET_SETUP_README.md` - інструкції по налаштуванню віджетів
- `READY_FOR_EXTERNAL_TESTING.md` - checklist для TestFlight

---

**Питання?** Пишіть на AndriyPopovich_temp@icloud.com

Good luck! 🚀
