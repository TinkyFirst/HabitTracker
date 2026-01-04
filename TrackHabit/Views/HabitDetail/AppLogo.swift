import SwiftUI

/// Animated App Logo - Crisp 3D Glass Design
struct AppLogo: View {
    @State private var rotationDegrees: Double = 0
    @State private var innerRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.7
    
    let size: CGFloat
    let shouldAnimate: Bool
    
    init(size: CGFloat = 150, shouldAnimate: Bool = true) {
        self.size = size
        self.shouldAnimate = shouldAnimate
    }
    
    var body: some View {
        ZStack {
            // Outer glow - адаптивний blur
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.blue.opacity(glowIntensity * 0.5), location: 0.0),
                            .init(color: Color.purple.opacity(glowIntensity * 0.7), location: 0.4),
                            .init(color: Color.blue.opacity(glowIntensity * 0.4), location: 0.7),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 1.0
                    )
                )
                .frame(width: size * 1.5, height: size * 1.5)
                .blur(radius: max(10, size * 0.15)) // Адаптивний blur
                .scaleEffect(pulseScale)
            
            // Mid-level crisp glow ring
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.clear, location: 0.3),
                            .init(color: Color.blue.opacity(0.5), location: 0.5),
                            .init(color: Color.cyan.opacity(0.4), location: 0.7),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.9
                    )
                )
                .frame(width: size * 1.6, height: size * 1.6)
                .blur(radius: max(8, size * 0.12)) // Адаптивний blur
                .rotationEffect(.degrees(rotationDegrees * 0.2))
            
            // Outer rotating ring with angular gradient
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.blue.opacity(0.5), location: 0.0),
                            .init(color: Color.cyan.opacity(0.6), location: 0.25),
                            .init(color: Color.purple.opacity(0.4), location: 0.5),
                            .init(color: Color.blue.opacity(0.5), location: 0.75),
                            .init(color: Color.blue.opacity(0.5), location: 1.0)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: size * 0.25, lineCap: .round)
                )
                .frame(width: size * 0.85, height: size * 0.85)
                .blur(radius: max(2, size * 0.025)) // Адаптивний blur
                .rotationEffect(.degrees(rotationDegrees * 0.5))
            
            // Main glass ring - CRISP
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.2), location: 0.0),
                            .init(color: Color.cyan.opacity(0.3), location: 0.3),
                            .init(color: Color.blue.opacity(0.25), location: 0.6),
                            .init(color: Color.purple.opacity(0.2), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.22, lineCap: .round)
                )
                .frame(width: size * 0.8, height: size * 0.8)
                .blur(radius: max(0.5, size * 0.008)) // Адаптивний blur
            
            // Decorative rotating dots - CRISP
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.cyan.opacity(0.8),
                                Color.blue.opacity(0.4),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.025
                        )
                    )
                    .frame(width: size * 0.05, height: size * 0.05)
                    .offset(y: -size * 0.4)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .opacity(0.8)
            }
            .rotationEffect(.degrees(rotationDegrees * 0.3))
            
            // Bright white segment - MAIN FEATURE, CRISP
            Circle()
                .trim(from: 0, to: 0.35)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white, location: 0.0),
                            .init(color: Color.white.opacity(0.9), location: 0.3),
                            .init(color: Color.cyan.opacity(0.7), location: 0.7),
                            .init(color: Color.cyan.opacity(0.3), location: 0.95),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: size * 0.28, lineCap: .round)
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .blur(radius: max(0.5, size * 0.01)) // Адаптивний blur
                .rotationEffect(.degrees(innerRotation))
                .shadow(color: .white.opacity(0.9), radius: max(8, size * 0.08), x: 0, y: 0)
                .shadow(color: .cyan.opacity(0.7), radius: max(6, size * 0.06), x: 0, y: 0)
            
            // Inner shadow ring
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.4)
                        ],
                        center: .center,
                        startRadius: size * 0.2,
                        endRadius: size * 0.35
                    ),
                    lineWidth: size * 0.12
                )
                .frame(width: size * 0.55, height: size * 0.55)
                .blur(radius: max(3, size * 0.04)) // Адаптивний blur
            
            // Dark center hole
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.8), location: 0.0),
                            .init(color: Color.black.opacity(0.6), location: 0.4),
                            .init(color: Color.purple.opacity(0.4), location: 0.8),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Inner rim highlight - CRISP
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.cyan.opacity(0.5),
                            Color.blue.opacity(0.3),
                            Color.purple.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .frame(width: size * 0.52, height: size * 0.52)
        }
        .frame(width: size * 1.2, height: size * 1.2) // МІНІМАЛЬНИЙ - було 1.5
        .onAppear {
            guard shouldAnimate else { return }
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Continuous rotation
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            rotationDegrees = 360
        }
        
        // Counter-rotation for inner segment
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            innerRotation = -360
        }
        
        // Gentle pulse
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            pulseScale = 1.05
            glowIntensity = 0.9
        }
    }
}

/// Animated version for navigation bar (always animates!)
struct AppLogoStatic: View {
    let size: CGFloat
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.7
    
    init(size: CGFloat = 100) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Outer glow - адаптивний blur
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.blue.opacity(glowIntensity * 0.5), location: 0.0),
                            .init(color: Color.purple.opacity(glowIntensity * 0.7), location: 0.4),
                            .init(color: Color.blue.opacity(glowIntensity * 0.4), location: 0.7),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 1.0
                    )
                )
                .frame(width: size * 1.5, height: size * 1.5)
                .blur(radius: max(10, size * 0.15))
                .scaleEffect(pulseScale)
            
            // Mid-level crisp glow ring
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.clear, location: 0.3),
                            .init(color: Color.blue.opacity(0.5), location: 0.5),
                            .init(color: Color.cyan.opacity(0.4), location: 0.7),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.9
                    )
                )
                .frame(width: size * 1.6, height: size * 1.6)
                .blur(radius: max(8, size * 0.12))
                .rotationEffect(.degrees(rotation * 0.2))
            
            // Main glass ring - CRISP
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.2), location: 0.0),
                            .init(color: Color.cyan.opacity(0.3), location: 0.3),
                            .init(color: Color.blue.opacity(0.25), location: 0.6),
                            .init(color: Color.purple.opacity(0.2), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.22, lineCap: .round)
                )
                .frame(width: size * 0.8, height: size * 0.8)
                .blur(radius: max(0.5, size * 0.008))
            
            // Decorative rotating dots - CRISP
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.cyan.opacity(0.8),
                                Color.blue.opacity(0.4),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.025
                        )
                    )
                    .frame(width: size * 0.05, height: size * 0.05)
                    .offset(y: -size * 0.4)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .opacity(0.8)
            }
            .rotationEffect(.degrees(rotation * 0.3))
            
            // Bright white segment - ANIMATED
            Circle()
                .trim(from: 0, to: 0.35)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white, location: 0.0),
                            .init(color: Color.white.opacity(0.9), location: 0.3),
                            .init(color: Color.cyan.opacity(0.7), location: 0.7),
                            .init(color: Color.cyan.opacity(0.3), location: 0.95),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: size * 0.28, lineCap: .round)
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .blur(radius: max(0.5, size * 0.01))
                .rotationEffect(.degrees(rotation))
                .shadow(color: .white.opacity(0.9), radius: max(8, size * 0.08), x: 0, y: 0)
                .shadow(color: .cyan.opacity(0.7), radius: max(6, size * 0.06), x: 0, y: 0)
            
            // Inner shadow ring
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.4)
                        ],
                        center: .center,
                        startRadius: size * 0.2,
                        endRadius: size * 0.35
                    ),
                    lineWidth: size * 0.12
                )
                .frame(width: size * 0.55, height: size * 0.55)
                .blur(radius: max(3, size * 0.04))
            
            // Dark center hole
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.8), location: 0.0),
                            .init(color: Color.black.opacity(0.6), location: 0.4),
                            .init(color: Color.purple.opacity(0.4), location: 0.8),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Inner rim highlight - CRISP
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.cyan.opacity(0.5),
                            Color.blue.opacity(0.3),
                            Color.purple.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .frame(width: size * 0.52, height: size * 0.52)
        }
        .frame(width: size * 1.2, height: size * 1.2) // Мінімальний frame
        .onAppear {
            // Always animate!
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = -360
            }
            
            // Gentle pulse
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
                glowIntensity = 0.9
            }
        }
    }
}

// MARK: - Preview
#Preview("Animated Logo") {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.3, green: 0.2, blue: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        AppLogo(size: 200)
    }
}

#Preview("Static Logo") {
    ZStack {
        Color.black.ignoresSafeArea()
        AppLogoStatic(size: 150)
    }
}
#Preview("Logo Sizes") {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.3, green: 0.2, blue: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 40) {
            HStack(spacing: 40) {
                VStack {
                    AppLogoStatic(size: 32)
                    Text("32pt")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    AppLogoStatic(size: 60)
                    Text("60pt")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    AppLogoStatic(size: 100)
                    Text("100pt")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            VStack {
                AppLogo(size: 180, shouldAnimate: true)
                Text("180pt - Animated")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
    }
}

#Preview("Logo on Different Backgrounds") {
    ScrollView {
        VStack(spacing: 30) {
            // Dark gradient
            ZStack {
                LinearGradient(
                    colors: [.black, .blue.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 250)
                
                VStack {
                    AppLogoStatic(size: 100)
                    Text("Dark Gradient")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Purple gradient
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.6), .pink.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 250)
                
                VStack {
                    AppLogoStatic(size: 100)
                    Text("Purple Gradient")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Blue gradient
            ZStack {
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 250)
                
                VStack {
                    AppLogoStatic(size: 100)
                    Text("Blue Gradient")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
    .ignoresSafeArea()
}

