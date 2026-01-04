# Widget Extension Configuration

## Info.plist конфігурація

Цей файл автоматично створюється Xcode при створенні Widget Extension.
Але ось основні ключі, які варто знати:

### Основні налаштування:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Bundle Identifier -->
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <!-- Bundle Name -->
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    
    <!-- Bundle Version -->
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <!-- Widget Extension -->
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>
    </dict>
    
    <!-- Minimum iOS Version -->
    <key>MinimumOSVersion</key>
    <string>17.0</string>
</dict>
</plist>
```

---

## Build Settings (важливі налаштування)

### У головному таргеті (TrackHabit):

```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.trackhabit
MARKETING_VERSION = 1.0
CURRENT_PROJECT_VERSION = 1
IPHONEOS_DEPLOYMENT_TARGET = 17.0
```

### У Widget Extension (HabitWidget):

```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.trackhabit.HabitWidget
MARKETING_VERSION = 1.0
CURRENT_PROJECT_VERSION = 1
IPHONEOS_DEPLOYMENT_TARGET = 17.0
```

⚠️ **Важливо:** Bundle ID віджета ПОВИНЕН починатися з Bundle ID головного додатка!

Правильно:
```
App:    com.yourcompany.trackhabit
Widget: com.yourcompany.trackhabit.HabitWidget
```

Неправильно:
```
App:    com.yourcompany.trackhabit
Widget: com.yourcompany.habitwidget  ❌
```

---

## Entitlements файли

### TrackHabit.entitlements:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Groups -->
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.yourcompany.trackhabit</string>
    </array>
    
    <!-- Siri (опціонально) -->
    <key>com.apple.developer.siri</key>
    <true/>
    
    <!-- App Intents (для iOS 16+) -->
    <key>com.apple.developer.appintents-extension</key>
    <true/>
</dict>
</plist>
```

### HabitWidget.entitlements:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Groups (ОБОВ'ЯЗКОВО) -->
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.yourcompany.trackhabit</string>
    </array>
    
    <!-- App Intents (для інтерактивних віджетів) -->
    <key>com.apple.developer.appintents-extension</key>
    <true/>
</dict>
</plist>
```

---

## Capabilities (що потрібно увімкнути)

### У головному додатку:
- ✅ App Groups
- ✅ Siri (якщо хочете Siri Shortcuts)
- ✅ Background Modes → Remote notifications (для нагадувань)

### У Widget Extension:
- ✅ App Groups (обов'язково!)
- ✅ App Intents (для інтерактивності)

---

## URL Scheme Configuration

У головному Info.plist додати:

```xml
<!-- URL Types -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.trackhabit</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>trackhabit</string>
        </array>
    </dict>
</array>
```

Це дозволяє відкривати додаток через:
```
trackhabit://today
trackhabit://habit/12345-UUID-HERE
trackhabit://addhabit
```

---

## Privacy Permissions (якщо потрібно)

### Якщо використовуєте нотифікації:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We need permission to send you habit reminders</string>
```

### Якщо плануєте Siri:

```xml
<key>NSSiriUsageDescription</key>
<string>Allow Siri to help you track your habits</string>
```

---

## Signing & Provisioning

### Automatic Signing (рекомендовано для розробки):
```
Team: Ваша команда
Automatically manage signing: ✅
```

### Manual Signing (для App Store):
```
Team: Ваша команда
Provisioning Profile: iOS Team Provisioning Profile
Certificate: Apple Development / Distribution
```

⚠️ **Важливо:** 
- App Groups потребують правильного provisioning profile
- Переконайтеся, що App Group доступна у вашому Apple Developer Account

---

## App Store Configuration

### Перед публікацією:

1. **Archive Build:**
   ```
   Product → Archive
   ```

2. **Перевірити:**
   - ✅ Bundle IDs правильні
   - ✅ Version numbers однакові
   - ✅ Всі capabilities налаштовані
   - ✅ App Groups працюють

3. **Metadata:**
   - Додати скріншоти віджетів
   - Описати функціональність у App Store Description
   - Згадати про інтерактивні віджети

---

## Privacy Manifest (iOS 17+)

Якщо використовуєте аналітику або треті сторонні SDK, додайте:

### PrivacyInfo.xcprivacy:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <!-- Опишіть які дані збираєте -->
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <!-- Опишіть які API використовуєте -->
    </array>
</dict>
</plist>
```

---

## Локалізація (опціонально)

### Якщо хочете підтримку мов:

У Widget Extension додайте локалізовані рядки:

**en.lproj/Localizable.strings:**
```
"GOOD_MORNING" = "Good Morning";
"GOOD_AFTERNOON" = "Good Afternoon";
"GOOD_EVENING" = "Good Evening";
"COMPLETED" = "Completed";
```

**uk.lproj/Localizable.strings:**
```
"GOOD_MORNING" = "Доброго ранку";
"GOOD_AFTERNOON" = "Доброго дня";
"GOOD_EVENING" = "Доброго вечора";
"COMPLETED" = "Виконано";
```

---

## Checklist перед публікацією:

### Налаштування:
- [ ] Bundle IDs правильні
- [ ] App Groups налаштовані в обох таргетах
- [ ] URL Scheme додано
- [ ] Entitlements файли правильні
- [ ] Version numbers однакові

### Тестування:
- [ ] Віджети відображають дані
- [ ] Інтерактивні кнопки працюють
- [ ] Deep linking працює
- [ ] Light/Dark режими підтримуються
- [ ] Протестовано на різних розмірах екрану
- [ ] Протестовано на реальному пристрої

### App Store:
- [ ] Archive успішно створений
- [ ] Всі capabilities схвалені
- [ ] Privacy manifest додано (якщо потрібно)
- [ ] Скріншоти віджетів готові
- [ ] Опис оновлено

---

## Корисні команди Xcode

### Clean Build:
```
Shift + Command + K
```

### Build:
```
Command + B
```

### Run:
```
Command + R
```

### Archive:
```
Product → Archive
```

### View Entitlements:
```
Target → Signing & Capabilities
```

### View Build Settings:
```
Target → Build Settings
```

---

## Troubleshooting Configuration

### "App Group not found":
```
1. Перевірити Bundle ID
2. Перевірити Team у Signing
3. Зайти на developer.apple.com
4. Створити App Group вручну
5. Regenerate provisioning profile
```

### "Widget not appearing":
```
1. Перевірити Bundle ID віджета
2. Переконатися, що закінчується на .HabitWidget
3. Перевірити Deployment Target (iOS 17.0+)
4. Clean Build Folder
```

### "Deep linking not working":
```
1. Перевірити URL Types у Info.plist
2. Переконатися в URL Scheme: trackhabit
3. Перевірити .handlesExternalEvents у App
4. Перезапустити пристрій
```

---

## Підтримка версій iOS

### iOS 17.0+ (Рекомендовано):
```swift
@available(iOS 17.0, *)
struct InteractiveHabitWidget: Widget { ... }
```

### iOS 16.0+ (Базова підтримка):
Без App Intents, але базові віджети працюють

### iOS 15.0 і нижче:
Віджети не підтримуються (потребують iOS 14+)

---

Готово! Тепер у вас є вся інформація про конфігурацію! 🎉
