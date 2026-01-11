import Foundation
import SwiftUI

/// Helper для відстеження статусу iCloud синхронізації (спрощена версія)
class CloudSyncMonitor: ObservableObject {
    static let shared = CloudSyncMonitor()
    
    @Published var isAvailable: Bool = false
    @Published var lastSyncDate: Date?
    
    private init() {
        checkStatus()
        
        // Підписатися на зміни статусу iCloud
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(identityChanged),
            name: NSUbiquityIdentityDidChange,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Перевірка статусу iCloud через FileManager
    func checkCloudKitStatus() {
        checkStatus()
    }
    
    private func checkStatus() {
        DispatchQueue.main.async { [weak self] in
            let available = FileManager.default.ubiquityIdentityToken != nil
            self?.isAvailable = available
            print(available ? "✅ iCloud доступний" : "❌ iCloud недоступний - увійдіть в Settings")
        }
    }
    
    @objc private func identityChanged() {
        print("📱 Статус iCloud змінився")
        checkStatus()
    }
    
    var statusDescription: String {
        isAvailable ? "icloud.available".localized : "icloud.noAccount".localized
    }
    
    var statusIcon: String {
        isAvailable ? "icloud.fill" : "icloud.slash"
    }
    
    var statusColor: Color {
        isAvailable ? .green : .red
    }
    
    var detailedHelp: String {
        isAvailable ? "icloud.helpAvailable".localized : "icloud.helpNoAccount".localized
    }
}

// MARK: - SwiftUI Views

struct CloudSyncStatusView: View {
    @ObservedObject private var monitor = CloudSyncMonitor.shared
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: monitor.statusIcon)
                        .foregroundStyle(monitor.statusColor)
                    
                    Text("iCloud")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    if monitor.isAvailable {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                    }
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    Text(monitor.statusDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(monitor.detailedHelp)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 2)
                    
                    if let lastSync = monitor.lastSyncDate {
                        Text(formattedLastSync(lastSync))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 2)
                    }
                    
                    Button("icloud.checkAgain".localized) {
                        monitor.checkCloudKitStatus()
                    }
                    .font(.caption)
                    .padding(.top, 4)
                }
                .padding(.leading, 24)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .onAppear {
            monitor.checkCloudKitStatus()
        }
    }
    
    private func formattedLastSync(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let relativeTime = formatter.localizedString(for: date, relativeTo: Date())
        return "\("icloud.lastSync".localized): \(relativeTime)"
    }
}

struct CloudSyncIndicator: View {
    @ObservedObject private var monitor = CloudSyncMonitor.shared
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: monitor.statusIcon)
                .foregroundStyle(monitor.statusColor)
            
            if monitor.isAvailable {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            monitor.checkCloudKitStatus()
        }
    }
}
