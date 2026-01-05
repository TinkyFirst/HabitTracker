# 📁 App Group Setup Guide

## ❌ Помилка: "Unable to find App Group Container in Entitlements"

Ця помилка виникає коли SwiftData не може знайти App Group контейнер. Це **обов'язково** для роботи віджетів!

---

## 🔧 Швидке виправлення (5 хвилин)

### Крок 1: Налаштувати головний Target (TrackHabit)

1. **Відкрийте Xcode проєкт**
2. **Виберіть Target:** TrackHabit (головний додаток)
3. **Перейдіть до:** Signing & Capabilities
4. **Додайте App Groups capability:**
   - Натисніть `+ Capability`
   - Виберіть `App Groups`
5. **Увімкніть App Group:**
   - Поставте галочку біля: `group.com.trackhabit.shared`
   - Якщо немає в списку - натисніть `+` і додайте:
     ```
     group.com.trackhabit.shared
     ```

### Крок 2: Налаштувати Widget Extension Target

1. **Виберіть Target:** TrackHabitWidgets (або як називається ваш widget extension)
2. **Перейдіть до:** Signing & Capabilities
3. **Додайте App Groups capability** (якщо немає)
4. **Увімкніть той самий App Group:**
   - ✅ `group.com.trackhabit.shared`

### Крок 3: Перевірити Entitlements файли

**TrackHabit.entitlements** повинен містити:
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.trackhabit.shared</string>
</array>
```

**TrackHabitWidgets.entitlements** повинен містити те саме:
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.trackhabit.shared</string>
</array>
```

### Крок 4: Clean Build

1. **Product → Clean Build Folder** (Cmd + Shift + K)
2. **Перезапустіть Xcode** (важливо!)
3. **Build** проєкт заново

---

## ✅ Перевірка що все працює

Після запуску додатку в Console ви повинні побачити:

```
📁 SwiftData storage path: /Users/.../Shared App Group/.../TrackHabit.sqlite
✅ ModelContainer created successfully with App Group
```

Якщо бачите це - **все працює!** 🎉

---

## 🚨 Можливі проблеми

### Problem 1: "No such module 'WidgetKit'"

**Рішення:**
1. Target → Build Phases → Link Binary With Libraries
2. Додайте: `WidgetKit.framework`

### Problem 2: App Group не з'являється в списку

**Рішення:**
1. Перейдіть на [developer.apple.com/account](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles → Identifiers
3. Виберіть ваш App ID (com.trackhabit.app або ваш Bundle ID)
4. Увімкніть "App Groups" capability
5. Configure → Create new App Group: `group.com.trackhabit.shared`
6. Save
7. У Xcode: Signing & Capabilities → Refresh (кнопка в правому нижньому куті)

### Problem 3: Widgets не показують дані

**Перевірте:**
1. ✅ App Group увімкнено в ОБОХ targets
2. ✅ Bundle ID правильний в обох targets
3. ✅ Обидва targets мають однакові entitlements для App Groups
4. ✅ Ви зробили Clean Build

**Debug:**
```swift
// Додайте це в SharedModelContainer init:
if let groupURL = FileManager.default.containerURL(
    forSecurityApplicationGroupIdentifier: "group.com.trackhabit.shared"
) {
    print("✅ App Group URL: \(groupURL.path)")
} else {
    print("❌ App Group NOT FOUND")
}
```

### Problem 4: Дані не синхронізуються між додатком і віджетом

**Причини:**
1. Різні App Groups в targets
2. Не зроблено Clean Build після змін
3. Старі дані в симуляторі

**Рішення:**
1. Reset simulator: Device → Erase All Content and Settings
2. Clean Build Folder
3. Rebuild проєкт
4. Додайте тестові звички заново

---

## 📝 Код що використовує App Group

### SharedModelContainer.swift ✅
```swift
class SharedModelContainer {
    private static let appGroupIdentifier = "group.com.trackhabit.shared"
    
    private init() {
        guard let appGroupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: Self.appGroupIdentifier
        ) else {
            fatalError("Unable to find App Group Container")
        }
        
        let storeURL = appGroupURL.appendingPathComponent("TrackHabit.sqlite")
        // ... створення ModelContainer з цим URL
    }
}
```

### Widget Provider ✅
```swift
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    Task {
        // Використовує SharedModelContainer
        let modelContainer = SharedModelContainer.shared.container
        let context = ModelContext(modelContainer)
        
        // Fetch data
        let habits = try context.fetch(descriptor)
        // ...
    }
}
```

---

## 🎯 Checklist для External Testing

Перед відправкою на TestFlight переконайтесь:

### App Groups:
- [ ] ✅ `group.com.trackhabit.shared` в TrackHabit target
- [ ] ✅ `group.com.trackhabit.shared` в Widget target
- [ ] ✅ Обидва entitlements файли містять App Group
- [ ] ✅ App Group створено на developer.apple.com
- [ ] ✅ Clean Build зроблено після змін

### Тестування:
- [ ] ✅ Додаток запускається без crashes
- [ ] ✅ Можна створити звичку
- [ ] ✅ Звичка відображається в головному екрані
- [ ] ✅ Widget показує звички (якщо додано на Home Screen)
- [ ] ✅ Marking complete в додатку оновлює widget
- [ ] ✅ Console показує "✅ ModelContainer created successfully"

### Code:
- [ ] ✅ `SharedModelContainer.swift` використовує App Group
- [ ] ✅ `HabitWidgetProvider.swift` використовує SharedModelContainer
- [ ] ✅ Всі Widget targets мають правильні imports
- [ ] ✅ No force unwraps (!) в widget коді

---

## 🔍 Додаткова діагностика

### Де знаходяться дані?

**БЕЗ App Group:**
```
/Users/yourname/Library/Developer/CoreSimulator/Devices/
[DEVICE_ID]/data/Containers/Data/Application/[APP_ID]/
Library/Application Support/default.store
```

**З App Group:**
```
/Users/yourname/Library/Developer/CoreSimulator/Devices/
[DEVICE_ID]/data/Containers/Shared/AppGroup/[GROUP_ID]/
TrackHabit.sqlite
```

### Як перевірити в Terminal:

```bash
# Знайти App Group контейнер
xcrun simctl get_app_container booted com.trackhabit.app group.com.trackhabit.shared

# Подивитись файли
ls -la /path/to/app/group/container/
```

---

## 💡 Best Practices

1. **Завжди використовуйте SharedModelContainer** 
   - Не створюйте окремі ModelContainer в widgets
   - Це гарантує що всі дані з одного джерела

2. **Логування**
   - Додайте print statements для debug
   - В production використовуйте os_log

3. **Error Handling**
   - Обробляйте помилки при fetch в widgets
   - Показуйте placeholder коли дані недоступні

4. **Testing**
   - Тестуйте на реальному пристрої
   - Simulator може поводитись інакше

---

## 📱 Тестування на реальному пристрої

**Важливо!** App Groups можуть поводитись інакше на симуляторі vs реальному пристрої.

### Перед TestFlight:
1. Підключіть реальний iPhone/iPad
2. Build & Run на пристрої
3. Додайте widget на Home Screen
4. Перевірте що дані синхронізуються
5. Перевірте Console на пристрої (Window → Devices and Simulators)

---

## 🚀 Готовність до Production

### Фінальний чекліст:

- [ ] ✅ App Group працює на simulator
- [ ] ✅ App Group працює на реальному пристрої
- [ ] ✅ Widgets показують правильні дані
- [ ] ✅ Marking complete оновлює widget
- [ ] ✅ No crashes в widget
- [ ] ✅ No debug prints (або закоментовані)
- [ ] ✅ Entitlements правильні в ОБОХ targets
- [ ] ✅ Provisioning profiles up-to-date

---

## 📞 Якщо все ще не працює

**Спробуйте:**
1. Видаліть додаток з симулятора/пристрою
2. Видаліть Derived Data: Xcode → Preferences → Locations → Derived Data → Delete
3. Clean Build Folder
4. Перезапустіть Xcode
5. Rebuild проєкт
6. Переустановіть додаток

**Якщо проблема залишається:**
- Перевірте Bundle IDs (мають бути правильними)
- Перевірте Signing (Development/Distribution)
- Перевірте що використовуєте правильний Team ID

---

## ✅ Висновок

App Groups - це **обов'язково** для роботи widgets з SwiftData. 

Після правильного налаштування:
- ✅ Додаток і widgets мають доступ до однієї бази даних
- ✅ Дані синхронізуються автоматично
- ✅ Widgets показують актуальну інформацію
- ✅ Все готово до External Testing!

**Час на налаштування:** ~5-10 хвилин  
**Складність:** Середня (але цей гайд спрощує процес!)

Good luck! 🚀
