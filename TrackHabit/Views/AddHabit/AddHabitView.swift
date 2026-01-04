import SwiftUI
import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    @Binding var newlyCreatedHabitId: UUID?
    
    @State private var showTemplates = true
    @State private var selectedCategory: HabitTemplate.TemplateCategory = .health
    @State private var title = ""
    @State private var selectedIcon = "⭐"
    @State private var selectedColor = AppTheme.presetColors[0]
    @State private var customEmoji = ""
    @State private var showingCustomEmojiInput = false

    @Query(filter: #Predicate<Habit> { !$0.isArchived }, sort: \Habit.sortOrder)
    private var existingHabits: [Habit]
    
    @AppStorage("isTestPremiumEnabled") private var isTestPremiumEnabled = false

    // Check if free limit is reached
    var isFreeUser: Bool {
        // Check both test premium and actual subscription
        !isTestPremiumEnabled && !StoreManager.shared.isProUser
    }

    var hasReachedFreeLimit: Bool {
        isFreeUser && existingHabits.count >= 3
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: AppTheme.spacingL) {
                        if showTemplates {
                            templatesSection
                        } else {
                            customHabitSection
                        }
                    }
                    .padding(AppTheme.spacingL)
                }
            }
            .navigationTitle(showTemplates ? "addHabit.chooseTemplate".localized : "addHabit.createHabit".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("addHabit.cancel".localized) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showTemplates {
                        Button("addHabit.save".localized) {
                            saveCustomHabit()
                        }
                        .disabled(title.isEmpty)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showTemplates.toggle() }) {
                        Text(showTemplates ? "addHabit.createCustom".localized : "addHabit.useTemplate".localized)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color.black : Color(white: 0.95),
                colorScheme == .dark ? Color.purple.opacity(0.2) : Color.purple.opacity(0.1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var templatesSection: some View {
        VStack(spacing: AppTheme.spacingM) {
            // Category selector - back to horizontal scroll
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(HabitTemplate.TemplateCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = category
                                }
                            }
                            .id(category)
                        }
                    }
                    .padding(.horizontal, AppTheme.spacingL)
                }
                .scrollIndicators(.hidden)
                .onChange(of: selectedCategory) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }

            // Templates with swipe to change categories
            ScrollView {
                VStack(spacing: AppTheme.spacingS) {
                    ForEach(HabitTemplate.templates(for: selectedCategory)) { template in
                        TemplateCard(template: template) {
                            if hasReachedFreeLimit {
                                // Show paywall
                            } else {
                                createHabitFromTemplate(template)
                            }
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        // Only trigger if horizontal swipe is dominant
                        let horizontalAmount = abs(value.translation.width)
                        let verticalAmount = abs(value.translation.height)
                        
                        // Require horizontal swipe to be more significant than vertical
                        guard horizontalAmount > verticalAmount * 1.5 else { return }
                        
                        let categories = HabitTemplate.TemplateCategory.allCases
                        guard let currentIndex = categories.firstIndex(of: selectedCategory) else { return }
                        
                        // Swipe right = previous category
                        if value.translation.width > 0 {
                            let previousIndex = currentIndex > 0 ? currentIndex - 1 : categories.count - 1
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = categories[previousIndex]
                            }
                        }
                        // Swipe left = next category
                        else if value.translation.width < 0 {
                            let nextIndex = (currentIndex + 1) % categories.count
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = categories[nextIndex]
                            }
                        }
                    }
            )

            if hasReachedFreeLimit {
                freeLimitWarning
            }
            
        }
    }

    private var freeLimitWarning: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacingS) {
                Text("addHabit.freeLimitReached".localized)
                    .font(.headline)

                Text("addHabit.upgradeUnlimited".localized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Button(action: {
                    // Show paywall
                }) {
                    Text("settings.upgradeToPro".localized)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(AppTheme.cornerRadiusS)
                }
            }
            .padding()
        }
    }

    private var customHabitSection: some View {
        VStack(spacing: AppTheme.spacingL) {
            titleInputSection
            iconSelectorSection
            colorSelectorSection
            oneMinuteTipSection
            
            if hasReachedFreeLimit {
                freeLimitWarning
            }
        }
    }
    
    private var titleInputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingS) {
                Text("addHabit.habitName".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("addHabit.habitNamePlaceholder".localized, text: $title)
                    .textFieldStyle(.plain)
                    .font(.headline)
            }
            .padding()
        }
    }
    
    private var iconSelectorSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                Text("addHabit.icon".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)

                iconScrollView
                
                if showingCustomEmojiInput {
                    customEmojiInputView
                }
            }
            .padding()
        }
    }
    
    private var iconScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.spacingS) {
                ForEach(commonIcons, id: \.self) { icon in
                    IconButton(
                        icon: icon,
                        isSelected: selectedIcon == icon && !showingCustomEmojiInput
                    ) {
                        selectedIcon = icon
                        showingCustomEmojiInput = false
                        customEmoji = ""
                    }
                }
                
                customEmojiButton
            }
        }
    }
    
    private var customEmojiButton: some View {
        Button(action: {
            showingCustomEmojiInput = true
            customEmoji = selectedIcon
        }) {
            VStack(spacing: 4) {
                Text(showingCustomEmojiInput && !customEmoji.isEmpty ? customEmoji : "+")
                    .font(showingCustomEmojiInput && !customEmoji.isEmpty ? .title2 : .title)
                    .frame(width: 50, height: 50)
                    .background(customEmojiButtonBackground)
                    .overlay(customEmojiButtonStroke)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
        .padding(.leading, 2)
    }
    
    private var customEmojiButtonBackground: some View {
        Circle()
            .fill(showingCustomEmojiInput ? 
                (colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.9)) : 
                (colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.7))
            )
    }
    
    private var customEmojiButtonStroke: some View {
        Circle()
            .stroke(
                showingCustomEmojiInput ? Color.blue : (colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.3)), 
                lineWidth: showingCustomEmojiInput ? 2 : 1
            )
    }
    
    private var customEmojiInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("addHabit.customEmoji".localized)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            TextField("addHabit.emojiPlaceholder".localized, text: $customEmoji)
                .textFieldStyle(.plain)
                .font(.title2)
                .frame(height: 44)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.05) : Color.gray.opacity(0.1))
                )
                .onChange(of: customEmoji) { _, newValue in
                    // Limit to single emoji
                    if !newValue.isEmpty {
                        let emoji = String(newValue.prefix(2)) // Allow for emoji with modifiers
                        customEmoji = emoji
                        selectedIcon = emoji
                    }
                }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private var colorSelectorSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacingM) {
                Text("addHabit.color".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.spacingS) {
                        ForEach(AppTheme.presetColors) { preset in
                            ColorButton(
                                color: preset,
                                isSelected: selectedColor.id == preset.id
                            ) {
                                selectedColor = preset
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var oneMinuteTipSection: some View {
        GlassCard {
            HStack(spacing: AppTheme.spacingM) {
                Text("💡")
                    .font(.title)

                VStack(alignment: .leading, spacing: 4) {
                    Text("1-Minute Rule")
                        .font(.headline)

                    Text("Make it so small you can't say no. Example: \"10 push-ups\" instead of \"workout\"")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }

    private let commonIcons = ["⭐", "💧", "🧘", "🚶", "💪", "📚", "🎯", "😊", "🌱", "☀️", "🌙", "⚡", "🔥", "💎", "🎨", "🎵", "📝", "✅", "🏃", "🧠"]

    private func createHabitFromTemplate(_ template: HabitTemplate) {
        let habit = Habit(
            title: template.title,
            icon: template.icon,
            colorHex: template.colorHex,
            reminderEnabled: false,
            sortOrder: existingHabits.count
        )
        modelContext.insert(habit)
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()
        
        // Set the newly created habit ID to open edit view
        newlyCreatedHabitId = habit.id
        
        // Dismiss the sheet
        dismiss()
    }

    private func saveCustomHabit() {
        guard !title.isEmpty else { return }

        if hasReachedFreeLimit {
            // Show paywall
            return
        }

        let habit = Habit(
            title: title,
            icon: selectedIcon,
            colorHex: selectedColor.hex,
            reminderEnabled: false,
            sortOrder: existingHabits.count
        )

        modelContext.insert(habit)
        try? modelContext.save()
        WidgetRefreshManager.reloadHabitWidgets()

        // Set the newly created habit ID to open edit view
        newlyCreatedHabitId = habit.id
        
        // Dismiss the sheet
        dismiss()
    }

    private func scheduleNotification(for habit: Habit) {
        NotificationManager.shared.scheduleNotification(for: habit)
    }
}

struct CategoryChip: View {
    let category: HabitTemplate.TemplateCategory
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var textColor: Color {
        if isSelected {
            return .white
        }
        return colorScheme == .dark ? .white : .black
    }
    
    private var backgroundGradient: LinearGradient {
        if isSelected {
            return LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            let baseColor = colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.7)
            return LinearGradient(
                gradient: Gradient(colors: [baseColor, baseColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            return .clear
        }
        return colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.3)
    }

    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(backgroundGradient)
                )
                .overlay(
                    Capsule()
                        .stroke(strokeColor, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TemplateCard: View {
    let template: HabitTemplate
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.spacingM) {
                // Icon - centered
                Text(template.icon)
                    .font(.system(size: 36))
                    .frame(width: 55, height: 55)
                    .background(
                        Circle()
                            .fill(Color(hex: template.colorHex).opacity(0.2))
                    )

                // Text - centered vertically
                VStack(alignment: .leading, spacing: 6) {
                    Text(template.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)

                    if !template.example.isEmpty {
                        Text(template.example)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Plus icon - always blue
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .padding(AppTheme.spacingM)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.9))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    private var fillColor: Color {
        if isSelected {
            return colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.9)
        } else {
            return colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.7)
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            return .blue
        }
        return colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.3)
    }
    
    private var strokeWidth: CGFloat {
        isSelected ? 2 : 1
    }

    var body: some View {
        Button(action: action) {
            Text(icon)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(fillColor)
                )
                .overlay(
                    Circle()
                        .stroke(strokeColor, lineWidth: strokeWidth)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4) // Додаємо паддінг зверху та знизу щоб не обрізалось
        .padding(.leading, 2) // Додаємо невеликий паддінг зліва
    }
}

struct ColorButton: View {
    let color: PresetColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                )
                .shadow(radius: isSelected ? 5 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4) // Додаємо паддінг зверху та знизу щоб не обрізалось
        .padding(.leading, 2) // Додаємо невеликий паддінг зліва
    }
}

#Preview {
    AddHabitView(newlyCreatedHabitId: .constant(nil))
        .modelContainer(for: [Habit.self, CheckIn.self], inMemory: true)
}
