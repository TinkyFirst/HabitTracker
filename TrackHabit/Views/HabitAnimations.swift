import SwiftUI

// MARK: - Completion Animation View
struct CompletionAnimationView: View {
    let emoji: String
    let message: String
    @Binding var isShowing: Bool
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -45
    @State private var offset: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .opacity(opacity)
            
            // Celebration content
            VStack(spacing: 20) {
                Text(emoji)
                    .font(.system(size: 80))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                
                Text(message)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .offset(y: offset)
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.2
                opacity = 1
                rotation = 0
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                scale = 1.0
                offset = 0
            }
            
            // Auto dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 0
                    scale = 0.8
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isShowing = false
                }
            }
        }
    }
}

// MARK: - Confetti Particle
struct ConfettiPiece: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        return path
    }
}

struct ConfettiView: View {
    @State private var animate = false
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece()
                    .fill(colors.randomElement() ?? .blue)
                    .frame(width: 10, height: 10)
                    .offset(x: animate ? CGFloat.random(in: -200...200) : 0,
                           y: animate ? CGFloat.random(in: -400...400) : 0)
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 1...2))
                        .delay(Double(index) * 0.02),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// MARK: - Pulse Animation
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulseEffect() -> some View {
        modifier(PulseEffect())
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase)
                    .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmerEffect() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Bounce Animation
struct BounceAnimation: ViewModifier {
    @State private var bounce = false
    let isCompleted: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounce)
            .onChange(of: isCompleted) { oldValue, newValue in
                if newValue {
                    bounce = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        bounce = false
                    }
                }
            }
    }
}

// MARK: - Checkmark Animation
struct AnimatedCheckmark: View {
    @State private var trimEnd: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green)
                .scaleEffect(scale)
            
            Path { path in
                path.move(to: CGPoint(x: 20, y: 30))
                path.addLine(to: CGPoint(x: 28, y: 38))
                path.addLine(to: CGPoint(x: 42, y: 22))
            }
            .trim(from: 0, to: trimEnd)
            .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 60, height: 60)
        }
        .frame(width: 60, height: 60)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.4).delay(0.2)) {
                trimEnd = 1.0
            }
        }
    }
}

// MARK: - Sparkle Effect
struct SparkleView: View {
    @State private var animate = false
    let count: Int = 12
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                SparkleParticle()
                    .rotationEffect(.degrees(Double(index) * (360.0 / Double(count))))
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 2 : 0.5)
                    .animation(
                        .easeOut(duration: 0.8)
                        .delay(Double(index) * 0.05),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct SparkleParticle: View {
    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 12))
            .foregroundColor(.yellow)
            .offset(x: 40)
    }
}

// MARK: - Card Flip Effect
struct CardFlip: ViewModifier {
    var isFlipped: Bool
    var duration: Double = 0.6
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
            .animation(.spring(response: duration, dampingFraction: 0.8), value: isFlipped)
    }
}

extension View {
    func cardFlip(isFlipped: Bool) -> some View {
        modifier(CardFlip(isFlipped: isFlipped))
    }
}

// MARK: - Wobble Effect
struct WobbleEffect: ViewModifier {
    @State private var wobble = false
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(wobble ? 5 : 0))
            .animation(
                wobble 
                ? .spring(response: 0.2, dampingFraction: 0.3)
                : .default,
                value: wobble
            )
            .onChange(of: trigger) { oldValue, newValue in
                if newValue {
                    performWobble()
                }
            }
    }
    
    private func performWobble() {
        let sequence = [5.0, -5.0, 4.0, -4.0, 2.0, -2.0, 0.0]
        for (index, _) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    // Trigger wobble
                }
            }
        }
    }
}
