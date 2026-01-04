import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) var colorScheme

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusL)
                    .fill(glassBackground)
                    .shadow(color: .black.opacity(AppTheme.shadowOpacity), radius: AppTheme.shadowRadius, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusL)
                    .stroke(glassBorder, lineWidth: 1)
            )
    }

    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .regularMaterial
    }

    private var glassBorder: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.5)
    }
}

struct GlassButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    @Environment(\.colorScheme) var colorScheme

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            content
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                        .fill(glassBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                        .stroke(glassBorder, lineWidth: 1)
                )
        }
        .buttonStyle(GlassButtonStyle())
    }

    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .regularMaterial
    }

    private var glassBorder: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.5)
    }
}

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct StreakChip: View {
    let streak: Int
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 4) {
            Text("🔥")
                .font(.caption)
            Text("\(streak)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.8))
        )
        .overlay(
            Capsule()
                .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}

struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let color: Color
    let lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.2),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}
