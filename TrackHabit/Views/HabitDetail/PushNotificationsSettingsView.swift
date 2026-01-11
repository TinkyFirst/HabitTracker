import SwiftUI

/// Екран налаштування Firebase Push Notifications
struct PushNotificationsSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var notificationManager = FirebaseNotificationManager.shared
    @State private var showingTokenAlert = false
    
    var body: some View {
        List {
            // Status Section
            Section {
                HStack {
                    Image(systemName: notificationManager.isPermissionGranted ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(notificationManager.isPermissionGranted ? .green : .red)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notificationManager.isPermissionGranted ? "Увімкнено ✅" : "Вимкнено ❌")
                            .font(.headline)
                        Text(notificationManager.isPermissionGranted ? "Ви отримуватимете важливі новини" : "Натисніть \"Увімкнути\" для підписки")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                if !notificationManager.isPermissionGranted {
                    Button(action: {
                        notificationManager.requestPermission()
                    }) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                            Text("Увімкнути повідомлення")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                } else {
                    Button(action: {
                        notificationManager.openSettings()
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Відкрити налаштування iOS")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                        }
                    }
                }
            } header: {
                Text("Статус")
            }
            
            // What you'll receive
            Section {
                NotificationTypeRow(
                    icon: "sparkles",
                    color: .orange,
                    title: "Нові версії",
                    description: "Дізнавайтесь першими про оновлення"
                )
                
                NotificationTypeRow(
                    icon: "star.fill",
                    color: .yellow,
                    title: "Нові фічі",
                    description: "Крутий функціонал у вашому додатку"
                )
                
                NotificationTypeRow(
                    icon: "gift.fill",
                    color: .pink,
                    title: "Спеціальні пропозиції",
                    description: "Ексклюзивні знижки та бонуси"
                )
                
                NotificationTypeRow(
                    icon: "party.popper.fill",
                    color: .purple,
                    title: "Важливі події",
                    description: "Святкування та мілстоуни"
                )
            } header: {
                Text("Що ви отримаєте")
            } footer: {
                Text("Ми надсилаємо тільки важливі та корисні повідомлення. Без спаму!")
                    .font(.caption)
            }
            
            // Privacy
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.blue)
                        Text("Ваша приватність захищена")
                            .font(.headline)
                    }
                    
                    Text("Ми не збираємо персональні дані. Firebase токен використовується тільки для доставки повідомлень.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            // Developer Section (Debug)
            #if DEBUG
            Section {
                Button("🧪 Тестове повідомлення (3 сек)") {
                    notificationManager.sendTestNotification()
                }
                
                if let token = notificationManager.fcmToken {
                    Button("📋 Скопіювати FCM токен") {
                        UIPasteboard.general.string = token
                        showingTokenAlert = true
                    }
                    
                    Text("Token: \(token.prefix(20))...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("FCM токен: очікування...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Developer Tools")
            }
            #endif
        }
        .navigationTitle("🔔 Push-повідомлення")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Токен скопійовано", isPresented: $showingTokenAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Firebase токен скопійовано в буфер обміну")
        }
    }
}

/// Рядок з типом повідомлення
struct NotificationTypeRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        PushNotificationsSettingsView()
    }
}
