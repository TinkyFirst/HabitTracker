import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @Binding var selectedHabitId: UUID?
    @ObservedObject private var languageManager = LanguageManager.shared

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(selectedHabitId: $selectedHabitId)
                .tabItem {
                    Label("tab.today".localized, systemImage: "checkmark.circle.fill")
                }
                .tag(0)

            InsightsView()
                .tabItem {
                    Label("tab.insights".localized, systemImage: "chart.bar.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("tab.settings".localized, systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.blue)
        .onOpenURL { url in
            handleDeepLink(url)
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "trackhabit" else { return }
        
        switch url.host {
        case "today":
            selectedTab = 0
        case "insights":
            selectedTab = 1
        case "settings":
            selectedTab = 2
        case "addhabit":
            selectedTab = 0
            // TodayView має власну логіку для відкриття AddHabitView
        case "habit":
            if let habitIdString = url.pathComponents.last,
               let habitId = UUID(uuidString: habitIdString) {
                selectedTab = 0
                selectedHabitId = habitId
            }
        default:
            break
        }
    }
}

#Preview {
    MainTabView(selectedHabitId: .constant(nil))
        .modelContainer(for: [Habit.self, CheckIn.self], inMemory: true)
}
