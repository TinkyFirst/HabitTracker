import Foundation
import UserNotifications

/// Manager для роботи з Firebase Cloud Messaging (FCM)
/// 
/// ## Налаштування:
/// 1. Додай Firebase до проекту через Swift Package Manager:
///    - File → Add Package Dependencies
///    - URL: https://github.com/firebase/firebase-ios-sdk
///    - Вибери: FirebaseMessaging
///
/// 2. Завантаж GoogleService-Info.plist з Firebase Console
///    - https://console.firebase.google.com
///    - Додай в корінь проекту
///
/// 3. В AppDelegate викликай FirebaseNotificationManager.shared.configure()
///
/// ## Використання:
/// ```swift
/// // Запит дозволу на пуші
/// FirebaseNotificationManager.shared.requestPermission()
///
/// // Отримати FCM токен
/// if let token = FirebaseNotificationManager.shared.fcmToken {
///     print("Firebase token: \(token)")
/// }
/// ```
///
/// ## Надсилання пушів:
/// 1. Зайди на https://console.firebase.google.com
/// 2. Cloud Messaging → New Campaign
/// 3. Напиши повідомлення та надішли!

class FirebaseNotificationManager: NSObject, ObservableObject {
    static let shared = FirebaseNotificationManager()
    
    @Published var fcmToken: String?
    @Published var isPermissionGranted: Bool = false
    
    private override init() {
        super.init()
        checkPermissionStatus()
    }
    
    /// Налаштування Firebase (викликай в AppDelegate)
    func configure() {
        // РОЗКОМЕНТУЙ КОЛИ ДОДАСИ FIREBASE:
        // import Firebase
        // import FirebaseMessaging
        //
        // FirebaseApp.configure()
        // Messaging.messaging().delegate = self
        
        print("🔥 Firebase configured")
    }
    
    /// Запит дозволу на push-повідомлення
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isPermissionGranted = granted
                
                if granted {
                    print("✅ Push notifications permission granted")
                    // Реєструємо для remote notifications
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("❌ Push notifications permission denied")
                }
                
                if let error = error {
                    print("❌ Permission error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Перевірка чи є дозвіл
    private func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    /// Відкрити налаштування додатку
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Firebase Messaging Delegate
// РОЗКОМЕНТУЙ КОЛИ ДОДАСИ FIREBASE SDK:
/*
import FirebaseMessaging

extension FirebaseNotificationManager: MessagingDelegate {
    /// Отримуємо FCM токен
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase token: \(fcmToken ?? "nil")")
        
        DispatchQueue.main.async { [weak self] in
            self?.fcmToken = fcmToken
            
            // Зберігаємо токен локально
            if let token = fcmToken {
                UserDefaults.standard.set(token, forKey: "fcm_token")
            }
        }
        
        // Можеш надіслати токен на свій сервер (якщо є)
        // sendTokenToServer(fcmToken)
    }
}

extension FirebaseNotificationManager: UNUserNotificationCenterDelegate {
    /// Обробка повідомлення коли додаток відкритий
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("📬 Received notification: \(userInfo)")
        
        // Показуємо повідомлення навіть коли додаток відкритий
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Обробка натискання на повідомлення
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("👆 User tapped notification: \(userInfo)")
        
        // Тут можна обробити різні дії:
        // - Відкрити конкретний екран
        // - Показати оновлення
        // - Тощо
        
        completionHandler()
    }
}
*/

// MARK: - Локальні повідомлення (працюють без Firebase)
extension FirebaseNotificationManager {
    /// Тестове локальне повідомлення
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎉 " + "Нова версія!".localized
        content.body = "Оновіть додаток до версії 2.0".localized
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error)")
            } else {
                print("✅ Test notification scheduled")
            }
        }
    }
}
