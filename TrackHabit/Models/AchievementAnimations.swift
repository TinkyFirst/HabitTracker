import SwiftUI

// MARK: - Achievement Progress Ring
struct AchievementProgressRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    
    init(progress: Double, color: Color = .blue, lineWidth: CGFloat = 4) {
        self.progress = progress
        self.color = color
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
        }
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.3),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width)
                    .offset(x: phase * geometry.size.width * 2 - geometry.size.width)
                    .mask(content)
                }
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Particle System for Unlock
struct ParticleSystem: View {
    let particleCount: Int
    let colors: [Color]
    
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var offset: CGSize = .zero
        var opacity: Double = 1
        var rotation: Double = 0
        var scale: CGFloat = 1
        let color: Color
    }
    
    init(particleCount: Int = 30, colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]) {
        self.particleCount = particleCount
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
                    .offset(particle.offset)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(color: colors.randomElement() ?? .blue)
        }
    }
    
    private func animateParticles() {
        for i in 0..<particles.count {
            let angle = Double.random(in: 0...360) * .pi / 180
            let distance = CGFloat.random(in: 100...200)
            let duration = Double.random(in: 0.8...1.5)
            
            withAnimation(.easeOut(duration: duration).delay(Double(i) * 0.02)) {
                particles[i].offset = CGSize(
                    width: cos(angle) * distance,
                    height: sin(angle) * distance
                )
                particles[i].opacity = 0
                particles[i].rotation = Double.random(in: 0...720)
                particles[i].scale = CGFloat.random(in: 0.2...1.5)
            }
        }
    }
}

// MARK: - Glow Effect
struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.4), radius: radius * 1.5, x: 0, y: 0)
            .shadow(color: color.opacity(0.2), radius: radius * 2, x: 0, y: 0)
    }
}

extension View {
    func glow(color: Color, radius: CGFloat = 10) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}

// MARK: - Pulsing Animation
struct PulsingEffect: ViewModifier {
    @State private var isPulsing = false
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulsing(minScale: CGFloat = 0.95, maxScale: CGFloat = 1.05, duration: Double = 1.0) -> some View {
        modifier(PulsingEffect(minScale: minScale, maxScale: maxScale, duration: duration))
    }
}

// MARK: - Floating Animation
struct FloatingEffect: ViewModifier {
    @State private var isFloating = false
    let amplitude: CGFloat
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -amplitude : amplitude)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                ) {
                    isFloating = true
                }
            }
    }
}

extension View {
    func floating(amplitude: CGFloat = 10, duration: Double = 2.0) -> some View {
        modifier(FloatingEffect(amplitude: amplitude, duration: duration))
    }
}

// MARK: - Star Burst Effect
struct StarBurst: View {
    let color: Color
    let rayCount: Int
    
    @State private var isAnimating = false
    
    init(color: Color = .yellow, rayCount: Int = 8) {
        self.color = color
        self.rayCount = rayCount
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<rayCount, id: \.self) { index in
                Rectangle()
                    .fill(color)
                    .frame(width: 2, height: isAnimating ? 60 : 0)
                    .offset(y: isAnimating ? -30 : 0)
                    .rotationEffect(.degrees(Double(index) * 360 / Double(rayCount)))
                    .opacity(isAnimating ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Achievement Rarity Badge
struct RarityBadge: View {
    let rarity: AchievementDefinition.AchievementRarity
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<rarity.rawValue, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption2)
            }
        }
        .foregroundStyle(rarityColor)
    }
    
    private var rarityColor: Color {
        switch rarity {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

// MARK: - Achievement Category Icon
struct CategoryIcon: View {
    let category: AchievementDefinition.AchievementCategory
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundStyle(categoryColor)
    }
    
    private var iconName: String {
        switch category {
        case .streaks: return "flame.fill"
        case .completions: return "checkmark.seal.fill"
        case .habits: return "star.fill"
        case .consistency: return "calendar.badge.checkmark"
        case .milestones: return "flag.fill"
        case .special: return "sparkles"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .streaks: return .orange
        case .completions: return .green
        case .habits: return .blue
        case .consistency: return .purple
        case .milestones: return .yellow
        case .special: return .pink
        }
    }
}

#Preview("Progress Ring") {
    VStack(spacing: 20) {
        AchievementProgressRing(progress: 0.3, color: .blue, lineWidth: 6)
            .frame(width: 100, height: 100)
        
        AchievementProgressRing(progress: 0.7, color: .orange, lineWidth: 8)
            .frame(width: 120, height: 120)
        
        AchievementProgressRing(progress: 1.0, color: .green, lineWidth: 10)
            .frame(width: 80, height: 80)
    }
    .padding()
}

#Preview("Shimmer Effect") {
    Text("Achievement Unlocked!")
        .font(.title)
        .fontWeight(.bold)
        .shimmer()
        .padding()
}

#Preview("Particle System") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ParticleSystem()
    }
}

#Preview("Glow Effect") {
    VStack(spacing: 30) {
        Image(systemName: "trophy.fill")
            .font(.system(size: 60))
            .foregroundStyle(.orange)
            .glow(color: .orange, radius: 20)
        
        Image(systemName: "star.fill")
            .font(.system(size: 60))
            .foregroundStyle(.yellow)
            .glow(color: .yellow, radius: 15)
    }
    .padding()
    .background(Color.black)
}

#Preview("Star Burst") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        StarBurst(color: .yellow, rayCount: 12)
    }
}
