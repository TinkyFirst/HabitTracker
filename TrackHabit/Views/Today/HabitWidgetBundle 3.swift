//
//  HabitWidgetBundle.swift
//  HabitWidget
//
//  Created with Claude Code
//

import SwiftUI
import WidgetKit

@main
struct HabitWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Main widgets
        HabitWidget()
        TodayProgressWidget()
        HabitListWidget()
        SingleHabitWidget()
        
        // Interactive widgets
        InteractiveHabitListWidget()
        
        // Lock screen widgets
        LockScreenProgressWidget()
        
        // StandBy widgets
        StandByHabitWidget()
    }
}
