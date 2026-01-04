//
//  TrackHabitApp.swift
//  TrackHabit
//
//  Created with Claude Code
//

import SwiftUI
import SwiftData

@main
struct TrackHabitApp: App {
    @State private var selectedHabitId: UUID?
    @AppStorage("preferredColorScheme") private var preferredColorScheme = "system"
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView(selectedHabitId: $selectedHabitId)
                    .preferredColorScheme(colorScheme)
                    .environmentObject(languageManager)
            } else {
                OnboardingView()
                    .environmentObject(languageManager)
            }
        }
        .modelContainer(SharedModelContainer.shared.container)
        .handlesExternalEvents(matching: ["trackhabit"])
    }
    
    private var colorScheme: ColorScheme? {
        switch preferredColorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
