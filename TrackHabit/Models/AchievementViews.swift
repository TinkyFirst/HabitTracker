import SwiftUI

// MARK: - Achievement Card View
struct AchievementCardView: View {
    let definition: AchievementDefinition
    let achievement: Achievement?
    let compact: Bool
    
    init(definition: AchievementDefinition, achievement: Achievement?, compact: Bool = false) {
        self.definition = definition
        self.achievement = achievement
        self.compact = compact
    }
    
    private var isUnlocked: Bool {
        achievement?.unlockedAt != nil
    }
    
    private var progress: Double {
        guard let achievement = achievement else { return 0 }
        return min(Double(achievement.progress) / Double(definition.requirement), 1.0)
    }
    
    private var progressText: String {
        guard let achievement = achievement else { return "0/\(definition.requirement)" }
        return "\(achievement.progress)/\(definition.requirement)"
    }
    
    var body: some View {
        if compact {
            compactView
        } else {
            fullView
        }
    }
    
    private var compactView: some View {
        HStack(spacing: 12) {
            // Icon with progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(hex: definition.color),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
                
                Image(systemName: definition.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(isUnlocked ? Color(hex: definition.color) : .gray)
                    .opacity(isUnlocked ? 1 : 0.5)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(definition.titleKey))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                
                Text(LocalizedStringKey(definition.descriptionKey))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Status
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color(hex: definition.color))
                    .font(.title3)
            } else {
                Text(progressText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isUnlocked ? Color(hex: definition.color).opacity(0.1) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnlocked ? Color(hex: definition.color).opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    private var fullView: some View {
        VStack(spacing: 16) {
            // Icon with animated progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(hex: definition.color),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                
                Image(systemName: definition.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(isUnlocked ? Color(hex: definition.color) : .gray)
                    .opacity(isUnlocked ? 1 : 0.5)
                    .scaleEffect(isUnlocked ? 1 : 0.8)
            }
            
            // Title
            Text(LocalizedStringKey(definition.titleKey))
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(isUnlocked ? .primary : .secondary)
            
            // Description
            Text(LocalizedStringKey(definition.descriptionKey))
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Progress or unlock date
            if isUnlocked, let unlockedAt = achievement?.unlockedAt {
                Text(formatDate(unlockedAt))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            } else {
                Text(progressText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(hex: definition.color))
            }
            
            // Rarity badge
            rarityBadge
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isUnlocked ? Color(hex: definition.color).opacity(0.15) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isUnlocked ? Color(hex: definition.color).opacity(0.4) : Color.clear, lineWidth: 2)
        )
    }
    
    private var rarityBadge: some View {
        HStack(spacing: 4) {
            ForEach(0..<definition.rarity.rawValue, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption2)
            }
        }
        .foregroundStyle(rarityColor)
    }
    
    private var rarityColor: Color {
        switch definition.rarity {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Achievement Unlock Animation
struct AchievementUnlockView: View {
    let definition: AchievementDefinition
    @Binding var isShowing: Bool
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    @State private var confettiOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 24) {
                // Confetti effect
                ZStack {
                    ForEach(0..<20, id: \.self) { index in
                        ConfettiPiece(color: randomColor(), delay: Double(index) * 0.05)
                            .opacity(confettiOpacity)
                    }
                }
                .frame(height: 200)
                
                // Achievement card
                VStack(spacing: 20) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color(hex: definition.color).opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: definition.icon)
                            .font(.system(size: 60))
                            .foregroundStyle(Color(hex: definition.color))
                    }
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    
                    // Text
                    VStack(spacing: 8) {
                        Text("achievement.unlocked")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        
                        Text(LocalizedStringKey(definition.titleKey))
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(LocalizedStringKey(definition.descriptionKey))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // Rarity stars
                        HStack(spacing: 4) {
                            ForEach(0..<definition.rarity.rawValue, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption)
                            }
                        }
                        .foregroundStyle(rarityColor)
                        .padding(.top, 4)
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.background)
                        .shadow(color: Color(hex: definition.color).opacity(0.3), radius: 20, y: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(hex: definition.color).opacity(0.5), lineWidth: 2)
                )
                .padding(.horizontal, 32)
                .opacity(opacity)
            }
        }
        .onAppear {
            animateIn()
        }
    }
    
    private var rarityColor: Color {
        switch definition.rarity {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            scale = 1
            opacity = 1
            rotation = 0
        }
        
        withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
            confettiOpacity = 1
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            opacity = 0
            scale = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isShowing = false
        }
    }
    
    private func randomColor() -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        return colors.randomElement() ?? .blue
    }
}

// MARK: - Confetti Piece
struct ConfettiPiece: View {
    let color: Color
    let delay: Double
    
    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                let randomX = CGFloat.random(in: -100...100)
                let randomRotation = Double.random(in: 0...360)
                
                withAnimation(.easeOut(duration: 1.5).delay(delay)) {
                    yOffset = 200
                    xOffset = randomX
                    rotation = randomRotation
                    opacity = 0
                }
            }
    }
}

// MARK: - Color from Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview("Unlocked Achievement") {
    let definition = AchievementDefinition.allAchievements[0]
    let achievement = Achievement(id: definition.id)
    achievement.unlockedAt = Date()
    
    return AchievementCardView(definition: definition, achievement: achievement)
        .padding()
}

#Preview("Locked Achievement") {
    let definition = AchievementDefinition.allAchievements[5]
    let achievement = Achievement(id: definition.id, progress: 5)
    
    return AchievementCardView(definition: definition, achievement: achievement)
        .padding()
}

#Preview("Unlock Animation") {
    @Previewable @State var isShowing = true
    let definition = AchievementDefinition.allAchievements[0]
    
    return AchievementUnlockView(definition: definition, isShowing: $isShowing)
}
