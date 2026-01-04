// GOALS FEATURE - QUICK REFERENCE
// ================================

// USER JOURNEY
// ============

// 1️⃣ CREATE HABIT
//    User creates new habit → Taps Save
//    ↓
//    Dialog appears: "Set a goal for this habit?"
//    ↓
//    Options:
//    - Weekly (7 days)      → weeklyGoal = 7
//    - Monthly (30 days)    → monthlyGoal = 30
//    - Forever (Yearly)     → all three goals
//    - No Goal             → skip
//
// Implementation: AddHabitView.swift
//    - showGoalDialog: Bool
//    - newlyCreatedHabit: Habit?
//    - confirmationDialog modifier


// 2️⃣ EDIT EXISTING HABIT (Context Menu)
//    User long-presses habit card in TodayView
//    ↓
//    Context menu appears
//    ↓
//    Options:
//    - Set Weekly Goal (7 days)
//    - Set Monthly Goal (30 days)
//    - Set Yearly Goal (Forever)
//    - Clear All Goals (if exists)
//
// Implementation: TodayView.swift
//    - .contextMenu modifier on habit cards
//    - setQuickGoal(for:type:)
//    - clearAllGoals(for:)


// 3️⃣ VIEW PROGRESS
//    Open Today tab
//    ↓
//    If any habits have goals → GoalsProgressView appears at top
//    ↓
//    Shows:
//    - Habit icon & title
//    - Progress bars (color-coded)
//    - Current/Target (e.g., "15/30")
//    - Checkmark when completed
//
// Implementation: TodayView.swift
//    - GoalsProgressView component
//    - GoalProgressBar component
//    - Color scheme:
//        🔵 Blue = Weekly
//        🟣 Purple = Monthly
//        🟢 Green = Yearly


// 4️⃣ FINE-TUNE (Power Users)
//    Navigate to HabitDetailView
//    ↓
//    Scroll to "Goals" section
//    ↓
//    Can:
//    - Edit exact numbers
//    - Add/remove individual goals
//    - See progress
//
// Implementation: HabitDetailView.swift
//    - goalsSection view
//    - TextField for each goal
//    - Add/Remove buttons


// DATA MODEL
// ==========
// Habit.swift additions:
//
// Properties:
//    var weeklyGoal: Int?
//    var monthlyGoal: Int?
//    var yearlyGoal: Int?
//
// Computed Properties:
//    var weeklyProgress: Int           // Count check-ins this week
//    var monthlyProgress: Int          // Count check-ins this month
//    var yearlyProgress: Int           // Count check-ins this year
//    var weeklyProgressPercentage: Double
//    var monthlyProgressPercentage: Double
//    var yearlyProgressPercentage: Double
//    var hasAnyGoal: Bool


// GOAL TYPES
// ==========
// enum GoalType {
//     case week    → Sets weeklyGoal = 7
//     case month   → Sets monthlyGoal = 30
//     case forever → Sets all three (7, 30, 365)
// }


// HAPTIC FEEDBACK
// ===============
// - Medium impact: Setting a goal
// - Light impact: Clearing goals
// - Warning: Deleting habit


// UI COMPONENTS
// =============
// 1. GoalsProgressView
//    - Shows all habits with goals
//    - Appears at top of TodayView list
//    - GlassCard style
//
// 2. GoalProgressBar
//    - Individual progress bar for each goal
//    - Animated gradient fill
//    - Icon + label + progress + checkmark
//
// 3. Context Menu
//    - .contextMenu modifier
//    - Long press interaction
//    - Quick actions
//
// 4. Confirmation Dialog
//    - .confirmationDialog modifier
//    - Post-creation flow
//    - 4 clear options


// COLOR SCHEME
// ============
// Weekly:  🔵 .blue
// Monthly: 🟣 .purple
// Yearly:  🟢 .green


// PRESET VALUES
// =============
// Weekly:  7 completions (once per day)
// Monthly: 30 completions (once per day)
// Yearly:  365 completions (once per day)


// FILES MODIFIED
// ==============
// 1. Habit.swift
//    - Added goal properties
//    - Added progress computed properties
//
// 2. TodayView.swift
//    - Added GoalsProgressView
//    - Added GoalProgressBar
//    - Added context menu
//    - Added quick goal functions
//
// 3. HabitDetailView.swift
//    - Added goalsSection
//    - TextField inputs
//    - Add/Remove buttons
//
// 4. AddHabitView.swift
//    - Added confirmationDialog
//    - Removed complex toggle forms
//    - Simple post-creation flow


// UX PRINCIPLES
// =============
// ✅ Simple first (preset values)
// ✅ Quick edits (context menu)
// ✅ Power user options (detail view)
// ✅ Progressive disclosure
// ✅ Non-intrusive (can skip)
// ✅ Discoverable (automatic dialog)
// ✅ Forgiving (easy to change/remove)


// TECHNICAL NOTES
// ===============
// - Goals are optional (Int?)
// - Progress calculated from CheckIn relationship
// - Week starts Monday (calendar.dateComponents)
// - Month starts 1st of current month
// - Year starts January 1st
// - Animations use spring(response: 0.5, dampingFraction: 0.7)
// - Widget refresh after goal changes


// TESTING CHECKLIST
// =================
// ✅ Create habit → Dialog appears
// ✅ Select "Weekly" → Goal set correctly
// ✅ Select "Monthly" → Goal set correctly
// ✅ Select "Forever" → All three goals set
// ✅ Select "No Goal" → No goals set, habit created
// ✅ Long press habit → Context menu appears
// ✅ Set goal from context menu → Goal applied
// ✅ Complete habit → Progress updates
// ✅ Progress bars animate smoothly
// ✅ Checkmark appears when goal reached
// ✅ Edit in detail view → Changes save
// ✅ Remove goal → Clears correctly
// ✅ Multiple habits with goals → All show in GoalsProgressView
// ✅ No goals → GoalsProgressView hidden
// ✅ Widget updates after goal changes
