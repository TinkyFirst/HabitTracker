# Goals Feature - UX Guide

## 🎯 Design Philosophy
**Make it incredibly simple to set goals, but powerful enough for those who want control.**

## User Interactions

### 1. 📱 Post-Creation Dialog (Primary Method)
**When**: Automatically after creating any habit  
**What**: A simple dialog with 4 options  
**Why**: Catches users at the perfect moment - right after committing to a habit

```
┌─────────────────────────────────────┐
│  Set a goal for this habit?         │
│                                     │
│  Choose how long you want to        │
│  track this habit                   │
│                                     │
│  [ Weekly (7 days) ]                │
│  [ Monthly (30 days) ]              │
│  [ Forever (Yearly) ]               │
│  [ No Goal ]                        │
└─────────────────────────────────────┘
```

**User Mental Model**:
- "Do I want to commit for a week, a month, or make this permanent?"
- Simple time-based framing instead of numbers
- Clear opt-out option

---

### 2. 👆 Long Press Context Menu (Quick Edit)
**When**: User long-presses any habit card in Today view  
**What**: Context menu with goal options  
**Why**: Fast access without navigating to detail view

```
Habit Card
    |
    [Long Press]
    |
    v
┌─────────────────────────────────┐
│ 📅 Set Weekly Goal (7 days)     │
│ 📆 Set Monthly Goal (30 days)   │
│ 📊 Set Yearly Goal (Forever)    │
│ ────────────────────────────    │
│ ❌ Clear All Goals              │
└─────────────────────────────────┘
```

**Behavior**:
- Replaces any existing goals with the selected one
- "Forever" option sets all three goals at once
- Haptic feedback confirms the action
- No confirmation needed - quick action

---

### 3. ⚙️ Detail View (Power Users)
**When**: In HabitDetailView  
**What**: Full control over individual goals  
**Why**: For users who want exact numbers or mixed goals

Located between Calendar and Settings sections.

**Features**:
- Set exact numbers for each goal independently
- Add/remove individual goals without affecting others
- See current progress vs target
- Fine-tune after quick-setting from context menu

---

## Why This UX Works

### ✅ Progressive Disclosure
1. **Simple first**: Post-creation dialog with 3 preset options
2. **Quick edits**: Context menu for fast changes
3. **Power users**: Detail view for fine control

### ✅ Default Values That Work
- **7 days (week)**: Perfect for trying new habits
- **30 days (month)**: Classic "build a habit" timeframe
- **365 days (year)**: Commitment to lifestyle change

90% of users never need to change these numbers.

### ✅ Non-Intrusive
- "No Goal" option always available
- Dialog can be dismissed
- Goals are completely optional
- No pressure to set goals

### ✅ Discoverable
- Dialog appears automatically (can't miss it)
- Long press is becoming standard iOS pattern
- Context menu clearly labeled
- Goals section in detail view for exploration

---

## Edge Cases Handled

### Multiple Goals
- User can have weekly + yearly (but not monthly)
- Each goal tracks independently
- "Forever" option sets all three for simplicity

### Changing Goals
- Long press replaces existing goals cleanly
- Detail view allows adding to existing goals
- "Clear All Goals" removes everything

### Progress Calculation
- Weekly: Monday to Sunday of current week
- Monthly: First to last day of current month
- Yearly: January 1 to December 31 of current year

---

## Visual Feedback

### Haptic Feedback
- **Medium impact**: When setting a goal
- **Light impact**: When clearing goals
- **Success notification**: When completing a goal

### Visual Indicators
- 🔵 Blue: Weekly goals
- 🟣 Purple: Monthly goals
- 🟢 Green: Yearly goals
- ✅ Checkmark: Goal completed

### Animations
- Progress bars animate smoothly when updated
- Spring animation on percentage changes
- Fade in/out when goals are added/removed

---

## Copy & Messaging

### Dialog Title
**"Set a goal for this habit?"**
- Question format invites participation
- Not commanding ("Set a goal")
- Acknowledges this specific habit

### Dialog Message
**"Choose how long you want to track this habit"**
- Time-based framing (not numbers)
- "You" centers on user choice
- "This habit" personalizes the message

### Button Labels
- **"Weekly (7 days)"** - Time period + clarification
- **"Monthly (30 days)"** - Same pattern
- **"Forever (Yearly)"** - Aspirational + practical
- **"No Goal"** - Clear opt-out (not "Cancel")

### Context Menu
- Uses verbs: "Set" not "Add"
- Includes time periods for clarity
- Icons match the color coding

---

## Success Metrics

### Adoption
- % of new habits with goals set
- Time to first goal set
- Goal type distribution

### Engagement
- % using context menu vs detail view
- Number of goal changes
- Goals completed vs abandoned

### Simplicity
- User testing: Can complete flow in <5 seconds
- No support questions about "how to set goals"
- High completion rate on post-creation dialog

---

## Future Considerations

### Smart Suggestions
Based on habit type and user history:
- "Most people track 'Exercise' for 30 days"
- "You completed 'Meditation' 25/30 last month. Try again?"

### Achievements
- 🏆 "Week Warrior" - Completed weekly goal
- 🎯 "Month Master" - Completed monthly goal
- 💎 "Year Champion" - Completed yearly goal

### Notifications
- Opt-in reminders when close to goal
- Celebration when goal reached
- Encouragement if falling behind

---

## A/B Testing Ideas

### Dialog Timing
- A: Show immediately after creation
- B: Show on first app open after creation
- Hypothesis: Immediate is better (hot moment)

### Button Order
- A: Week → Month → Year → No Goal
- B: Forever → Month → Week → No Goal
- Hypothesis: Starting with commitment works better

### Context Menu vs Swipe
- A: Long press context menu
- B: Swipe left reveals goal options
- Hypothesis: Context menu is more discoverable

