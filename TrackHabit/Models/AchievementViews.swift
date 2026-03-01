import SwiftUI

// MARK: - Achievement Shimmer Effect Modifier
struct AchievementShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -1
    let duration: Double
    let opacity: Double

    init(duration: Double = 2.5, opacity: Double = 0.25) {
        self.duration = duration
        self.opacity = opacity
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(opacity),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * (geo.size.width * 1.6))
                    .onAppear {
                        withAnimation(
                            .linear(duration: duration)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = 1
                        }
                    }
                }
                .mask(content)
            )
    }
}

// MARK: - Pulsing Glow Modifier
struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var isGlowing = false

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isGlowing ? 0.6 : 0.15), radius: isGlowing ? radius : radius * 0.4, y: 0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.8)
                    .repeatForever(autoreverses: true)
                ) {
                    isGlowing = true
                }
            }
    }
}

// MARK: - Floating Particles
struct FloatingParticle: View {
    let color: Color
    let size: CGFloat
    @State private var offsetY: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    @State private var opacity: Double = 0

    let delay: Double

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: size * 0.3)
            .offset(x: offsetX, y: offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2.5...4.0))
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    offsetY = CGFloat.random(in: -15...15)
                    offsetX = CGFloat.random(in: -8...8)
                    opacity = Double.random(in: 0.3...0.7)
                }
            }
    }
}

// MARK: - Achievement Card View
struct AchievementCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let definition: AchievementDefinition
    let achievement: Achievement?
    let compact: Bool

    @State private var appeared = false
    @State private var iconScale: CGFloat = 0.6
    @State private var ringProgress: Double = 0

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

    private var accentColor: Color {
        Color(hex: definition.color)
    }

    private var rarityGradient: [Color] {
        switch definition.rarity {
        case .common:
            return [accentColor, accentColor.opacity(0.7)]
        case .uncommon:
            return [accentColor, accentColor.opacity(0.8)]
        case .rare:
            return [accentColor, Color(hex: "6C63FF")]
        case .epic:
            return [Color(hex: "8B5CF6"), Color(hex: "EC4899")]
        case .legendary:
            return [Color(hex: "F59E0B"), Color(hex: "EF4444"), Color(hex: "F59E0B")]
        }
    }

    private var cardBackground: some ShapeStyle {
        if isUnlocked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        accentColor.opacity(colorScheme == .dark ? 0.18 : 0.10),
                        accentColor.opacity(colorScheme == .dark ? 0.06 : 0.03),
                        colorScheme == .dark
                            ? Color(red: 0.10, green: 0.12, blue: 0.16)
                            : Color.white.opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [
                    colorScheme == .dark
                        ? Color(red: 0.12, green: 0.14, blue: 0.18)
                        : Color(red: 0.97, green: 0.98, blue: 0.99),
                    colorScheme == .dark
                        ? Color(red: 0.09, green: 0.10, blue: 0.14)
                        : Color(red: 0.94, green: 0.95, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var cardBorderGradient: LinearGradient {
        if isUnlocked {
            return LinearGradient(
                colors: [
                    accentColor.opacity(colorScheme == .dark ? 0.50 : 0.35),
                    accentColor.opacity(colorScheme == .dark ? 0.15 : 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [
                colorScheme == .dark ? Color.white.opacity(0.10) : Color(red: 0.88, green: 0.90, blue: 0.92),
                colorScheme == .dark ? Color.white.opacity(0.04) : Color(red: 0.92, green: 0.93, blue: 0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        if compact {
            compactView
        } else {
            fullView
        }
    }

    // MARK: - Compact View
    private var compactView: some View {
        HStack(spacing: 14) {
            // Icon with progress ring
            iconView(size: 52, iconSize: 22, ringWidth: 3)

            VStack(alignment: .leading, spacing: 3) {
                Text(definition.titleKey.localized)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)

                Text(definition.descriptionKey.localized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(
                        LinearGradient(colors: rarityGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .font(.title3)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(progressText)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(red: 0.40, green: 0.48, blue: 0.54))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                    )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(cardBorderGradient, lineWidth: 1)
        )
        .shadow(color: accentColor.opacity(isUnlocked ? 0.12 : 0.03), radius: 12, y: 4)
    }

    // MARK: - Full View
    private var fullView: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 2)

            // Icon with animated progress ring
            iconView(size: 76, iconSize: 28, ringWidth: 3.5)
                .padding(.top, 4)

            // Title
            Text(definition.titleKey.localized)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(isUnlocked ? .primary : .secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity)

            // Description
            Text(definition.descriptionKey.localized)
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundStyle(.tertiary)
                .lineLimit(2)
                .frame(maxWidth: .infinity)

            Spacer()

            // Progress or unlock date
            if isUnlocked, let unlockedAt = achievement?.unlockedAt {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.green)
                    Text(formatDate(unlockedAt))
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
            } else {
                // Progress bar
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(accentColor.opacity(0.12))

                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: rarityGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(0, geo.size.width * ringProgress))
                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: ringProgress)
                        }
                    }
                    .frame(height: 5)
                    .clipShape(Capsule())

                    Text(progressText)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(accentColor.opacity(0.8))
                }
            }

            // Rarity badge
            rarityBadge
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(minHeight: 205, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(cardBackground)

                // Subtle top highlight for depth
                if isUnlocked {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(colorScheme == .dark ? 0.04 : 0.5),
                                    .clear, .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(cardBorderGradient, lineWidth: isUnlocked ? 1.5 : 1)
        )
        .shadow(color: accentColor.opacity(isUnlocked ? 0.15 : 0.03), radius: isUnlocked ? 16 : 8, y: isUnlocked ? 6 : 3)
        .scaleEffect(appeared ? 1 : 0.92)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appeared = true
                iconScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                ringProgress = progress
            }
        }
    }

    // MARK: - Icon View
    @ViewBuilder
    private func iconView(size: CGFloat, iconSize: CGFloat, ringWidth: CGFloat) -> some View {
        ZStack {
            // Outer glow for unlocked
            if isUnlocked && definition.rarity.rawValue >= 3 {
                Circle()
                    .fill(accentColor.opacity(0.08))
                    .frame(width: size + 14, height: size + 14)
                    .blur(radius: 8)
            }

            // Background circle with gradient
            Circle()
                .fill(
                    isUnlocked
                    ? AnyShapeStyle(
                        RadialGradient(
                            colors: [
                                accentColor.opacity(colorScheme == .dark ? 0.25 : 0.15),
                                accentColor.opacity(colorScheme == .dark ? 0.08 : 0.04)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.5
                        )
                    )
                    : AnyShapeStyle(
                        colorScheme == .dark
                        ? Color(red: 0.14, green: 0.16, blue: 0.20)
                        : Color(red: 0.95, green: 0.96, blue: 0.97)
                    )
                )
                .frame(width: size, height: size)

            // Progress ring track
            Circle()
                .stroke(accentColor.opacity(0.10), lineWidth: ringWidth)
                .frame(width: size - 10, height: size - 10)

            // Progress ring
            Circle()
                .trim(from: 0, to: ringProgress)
                .stroke(
                    AngularGradient(
                        colors: rarityGradient + [rarityGradient.first ?? accentColor],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                )
                .frame(width: size - 10, height: size - 10)
                .rotationEffect(.degrees(-90))

            // Icon
            Image(systemName: definition.icon)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(
                    isUnlocked
                    ? AnyShapeStyle(
                        LinearGradient(colors: rarityGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    : AnyShapeStyle(Color(red: 0.52, green: 0.56, blue: 0.60))
                )
                .scaleEffect(iconScale)
                .opacity(isUnlocked ? 1 : 0.4)
        }
    }

    // MARK: - Rarity Badge
    private var rarityBadge: some View {
        HStack(spacing: 3) {
            ForEach(0..<definition.rarity.rawValue, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        LinearGradient(colors: rarityGradient, startPoint: .top, endPoint: .bottom)
                    )
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(rarityColor.opacity(colorScheme == .dark ? 0.15 : 0.08))
                .overlay(
                    Capsule()
                        .stroke(rarityColor.opacity(0.15), lineWidth: 0.5)
                )
        )
    }

    private var rarityColor: Color {
        switch definition.rarity {
        case .common: return Color(red: 0.43, green: 0.49, blue: 0.54)
        case .uncommon: return Color(red: 0.26, green: 0.61, blue: 0.49)
        case .rare: return Color(red: 0.16, green: 0.50, blue: 0.83)
        case .epic: return Color(red: 0.54, green: 0.36, blue: 0.96)
        case .legendary: return Color(red: 0.96, green: 0.62, blue: 0.04)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = LanguageManager.shared.selectedLanguage == "uk"
            ? Locale(identifier: "uk_UA")
            : Locale(identifier: "en_US")
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Achievement Unlock Animation
struct AchievementUnlockView: View {
    let definition: AchievementDefinition
    @Binding var isShowing: Bool

    @State private var backgroundOpacity: Double = 0
    @State private var cardScale: CGFloat = 0.3
    @State private var cardOpacity: Double = 0
    @State private var iconScale: CGFloat = 0
    @State private var iconRotation: Double = -30
    @State private var glowScale: CGFloat = 0.5
    @State private var glowOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var badgeOpacity: Double = 0
    @State private var ringProgress: Double = 0
    @State private var particlesActive = false
    @State private var sparklesActive = false

    private var accentColor: Color { Color(hex: definition.color) }

    private var rarityGradient: [Color] {
        switch definition.rarity {
        case .common: return [accentColor, accentColor.opacity(0.7)]
        case .uncommon: return [accentColor, accentColor.opacity(0.8)]
        case .rare: return [accentColor, Color(hex: "6C63FF")]
        case .epic: return [Color(hex: "8B5CF6"), Color(hex: "EC4899")]
        case .legendary: return [Color(hex: "F59E0B"), Color(hex: "EF4444"), Color(hex: "F59E0B")]
        }
    }

    var body: some View {
        ZStack {
            // Dimmed background - tappable
            Color.black.opacity(backgroundOpacity)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { dismiss() }

            // Radial glow behind card - decorative, no hit testing
            RadialGradient(
                colors: [
                    accentColor.opacity(0.35),
                    accentColor.opacity(0.08),
                    .clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 250
            )
            .scaleEffect(glowScale)
            .opacity(glowOpacity)
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Sparkle particles - decorative, no hit testing
            if sparklesActive {
                ZStack {
                    ForEach(0..<24, id: \.self) { i in
                        AchievementSparkleParticle(
                            color: rarityGradient[i % rarityGradient.count],
                            index: i,
                            total: 24
                        )
                    }
                }
                .allowsHitTesting(false)
            }

            // Main card - tappable to dismiss
            VStack(spacing: 0) {
                // Confetti burst - decorative
                if particlesActive {
                    ZStack {
                        ForEach(0..<30, id: \.self) { index in
                            EnhancedConfettiPiece(
                                color: confettiColor(for: index),
                                delay: Double(index) * 0.03
                            )
                        }
                    }
                    .frame(height: 120)
                    .allowsHitTesting(false)
                }

                // Card content
                VStack(spacing: 20) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.secondary)
                                .frame(width: 30, height: 30)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                        }
                    }

                    // Animated icon
                    ZStack {
                        // Pulsing ring
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: rarityGradient + [rarityGradient.first ?? accentColor],
                                    center: .center
                                ),
                                lineWidth: 3.5
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(ringProgress * 360))
                            .opacity(glowOpacity)

                        // Glow circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        accentColor.opacity(0.3),
                                        accentColor.opacity(0.05),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 130, height: 130)
                            .scaleEffect(glowScale)

                        // Icon background
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        accentColor.opacity(0.22),
                                        accentColor.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        // Icon
                        Image(systemName: definition.icon)
                            .font(.system(size: 46, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: rarityGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(iconScale)
                            .rotationEffect(.degrees(iconRotation))
                    }

                    // Text content
                    VStack(spacing: 8) {
                        Text("achievement.unlocked".localized)
                            .font(.system(size: 11, weight: .bold))
                            .tracking(2.5)
                            .foregroundStyle(
                                LinearGradient(colors: rarityGradient, startPoint: .leading, endPoint: .trailing)
                            )
                            .textCase(.uppercase)
                            .opacity(titleOpacity)
                            .offset(y: titleOffset)

                        Text(definition.titleKey.localized)
                            .font(.system(size: 22, weight: .bold))
                            .multilineTextAlignment(.center)
                            .opacity(titleOpacity)
                            .offset(y: titleOffset)

                        Text(definition.descriptionKey.localized)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                            .opacity(titleOpacity)
                            .offset(y: titleOffset)

                        // Rarity stars
                        HStack(spacing: 5) {
                            ForEach(0..<definition.rarity.rawValue, id: \.self) { i in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 13))
                                    .foregroundStyle(
                                        LinearGradient(colors: rarityGradient, startPoint: .top, endPoint: .bottom)
                                    )
                                    .scaleEffect(badgeOpacity > 0 ? 1 : 0)
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.5)
                                        .delay(0.6 + Double(i) * 0.1),
                                        value: badgeOpacity
                                    )
                            }
                        }
                        .padding(.top, 4)
                        .opacity(badgeOpacity)
                    }

                    // Tap to dismiss hint
                    Text("achievements.tap_to_close".localized)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                        .opacity(titleOpacity * 0.7)
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                .padding(.bottom, 20)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                        .shadow(color: accentColor.opacity(0.35), radius: 30, y: 10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.5),
                                    accentColor.opacity(0.1),
                                    accentColor.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .contentShape(RoundedRectangle(cornerRadius: 28))
                .onTapGesture { dismiss() }
                .scaleEffect(cardScale)
                .opacity(cardOpacity)
            }
            .padding(.horizontal, 32)
        }
        .onAppear { animateIn() }
    }

    private func animateIn() {
        // Phase 1: Background
        withAnimation(.easeOut(duration: 0.3)) {
            backgroundOpacity = 0.5
        }

        // Phase 2: Glow appears
        withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
            glowScale = 1.2
            glowOpacity = 1
        }

        // Phase 3: Card scales in
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
            cardScale = 1
            cardOpacity = 1
        }

        // Phase 4: Icon bounces in
        withAnimation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.3)) {
            iconScale = 1
            iconRotation = 0
        }

        // Phase 5: Ring rotation
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false).delay(0.3)) {
            ringProgress = 1
        }

        // Phase 6: Text slides up
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.45)) {
            titleOpacity = 1
            titleOffset = 0
        }

        // Phase 7: Badge + particles
        withAnimation(.easeOut(duration: 0.3).delay(0.55)) {
            badgeOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            particlesActive = true
            sparklesActive = true
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.25)) {
            cardOpacity = 0
            cardScale = 0.85
            backgroundOpacity = 0
            glowOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isShowing = false
        }
    }

    private func confettiColor(for index: Int) -> Color {
        let colors: [Color] = [
            accentColor,
            Color(hex: "6C63FF"),
            Color(hex: "EC4899"),
            Color(hex: "F59E0B"),
            Color(hex: "10B981"),
            Color(hex: "3B82F6"),
            .orange, .pink
        ]
        return colors[index % colors.count]
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
}

// MARK: - Enhanced Confetti Piece
struct EnhancedConfettiPiece: View {
    let color: Color
    let delay: Double

    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var rotationX: Double = 0
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1

    private let shapes = ["circle", "rectangle", "capsule"]

    var body: some View {
        Group {
            let shapeType = shapes.randomElement() ?? "rectangle"
            if shapeType == "circle" {
                Circle().fill(color)
                    .frame(width: CGFloat.random(in: 5...9), height: CGFloat.random(in: 5...9))
            } else if shapeType == "capsule" {
                Capsule().fill(color)
                    .frame(width: CGFloat.random(in: 4...7), height: CGFloat.random(in: 8...14))
            } else {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(color)
                    .frame(width: CGFloat.random(in: 5...8), height: CGFloat.random(in: 8...12))
            }
        }
        .rotation3DEffect(.degrees(rotationX), axis: (x: 1, y: 0, z: 0))
        .rotationEffect(.degrees(rotation))
        .offset(x: xOffset, y: yOffset)
        .opacity(opacity)
        .scaleEffect(scale)
        .onAppear {
            let randomX = CGFloat.random(in: -140...140)
            let randomRotation = Double.random(in: -360...360)
            let randomDuration = Double.random(in: 1.2...2.0)

            withAnimation(.easeOut(duration: randomDuration).delay(delay)) {
                yOffset = CGFloat.random(in: 150...280)
                xOffset = randomX
                rotation = randomRotation
                rotationX = Double.random(in: 0...720)
                opacity = 0
                scale = CGFloat.random(in: 0.3...0.8)
            }
        }
    }
}

// MARK: - Achievement Sparkle Particle
struct AchievementSparkleParticle: View {
    let color: Color
    let index: Int
    let total: Int

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 0

    private var angle: Double {
        Double(index) / Double(total) * 360
    }

    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: CGFloat.random(in: 6...12)))
            .foregroundStyle(color)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: cos(angle * .pi / 180) * offset,
                y: sin(angle * .pi / 180) * offset
            )
            .onAppear {
                let delay = Double(index) * 0.04
                withAnimation(.easeOut(duration: 0.8).delay(delay)) {
                    scale = CGFloat.random(in: 0.8...1.5)
                    opacity = 1
                    offset = CGFloat.random(in: 120...200)
                }
                withAnimation(.easeIn(duration: 0.5).delay(delay + 0.6)) {
                    opacity = 0
                    scale = 0.2
                }
            }
    }
}

// MARK: - Confetti Piece (legacy compatibility)
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
