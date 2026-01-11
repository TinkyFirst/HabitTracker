//
//  AppDelegate.swift
//  TrackHabit
//
//  Created for Firebase Push Notifications
//

import UIKit
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Ініціалізуємо Firebase
        FirebaseNotificationManager.shared.configure()
        
        // Налаштовуємо delegates для обробки повідомлень
        UNUserNotificationCenter.current().delegate = FirebaseNotificationManager.shared
        
        print("✅ AppDelegate initialized")
        
        return true
    }
    
    // MARK: - Remote Notifications
    
    /// Викликається коли APNs успішно зареєстрував пристрій
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("📱 Received APNs token")
        
        // Передаємо APNs токен в Firebase Messaging
        // Firebase автоматично згенерує FCM токен на основі цього
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// Викликається якщо реєстрація APNs не вдалась
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
}
