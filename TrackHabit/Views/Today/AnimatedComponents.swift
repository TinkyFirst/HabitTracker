import SwiftUI

import SwiftUI
import SwiftData

// MARK: - Animated Habit Row
struct AnimatedHabitRow: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    @State private var isPressed = false
    @State private var showConfetti = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button {
            toggleHabit()
        } label: {
            HStack(spacing: 16) {
                // Animated Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(habit.isCompletedToday ? Color(hex: habit.colorHex) : Color.secondary.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .shadow(color: habit.isCompletedToday ? Color(hex: habit.colorHex).opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                    
                    if habit.isCompletedToday {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: habit.isCompletedToday)
                
                // Habit Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(habit.icon)
                            .font(.title2)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Text(habit.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 12) {
                        // Streak
                        if habit.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                                Text("\(habit.currentStreak) day streak")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Total completions
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            Text("\(habit.checkIns?.count ?? 0) total")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Completion Badge
                if habit.isCompletedToday {
                    ZStack {
                        Circle()
                            .fill(Color(hex: habit.colorHex).opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: habit.colorHex))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(scale)
            .overlay(
                confettiOverlay
            )
        }
        .buttonStyle(SpringButtonStyle())
    }
    
    private var confettiOverlay: some View {
        ZStack {
            if showConfetti {
                ForEach(0..<15) { index in
                    ConfettiParticle(color: randomColor(), delay: Double(index) * 0.02)
                }
            }
        }
    }
    
    private func toggleHabit() {
        let wasCompleted = habit.isCompletedToday
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            scale = 0.95
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
        
        if wasCompleted {
            // Remove today's check-in
            if let checkIns = habit.checkIns {
                if let todayCheckIn = checkIns.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                    modelContext.delete(todayCheckIn)
                }
            }
        } else {
            // Add new check-in
            let checkIn = CheckIn(date: today, timestamp: Date(), source: "manual")
            checkIn.habit = habit
            modelContext.insert(checkIn)
            
            // Show confetti animation
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showConfetti = false
            }
            
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        try? modelContext.save()
    }
    
    private func randomColor() -> Color {
        [Color.blue, .purple, .pink, .orange, .yellow, .green].randomElement() ?? .blue
    }
}

// MARK: - Spring Button Style
struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Confetti Particle
struct ConfettiParticle: View {
    let color: Color
    let delay: Double
    
    @State private var isAnimating = false
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 6, height: 12)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0).delay(delay)) {
                    xOffset = CGFloat.random(in: -100...100)
                    yOffset = CGFloat.random(in: -150...(-50))
                    rotation = Double.random(in: 0...360)
                    opacity = 0
                }
            }
    }
}

// MARK: - Animated Progress Ring
struct AnimatedProgressRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.blue, .purple, .pink, .blue]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.8), value: animatedProgress)
            
            // Center content
            VStack(spacing: 4) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Complete")
                    .font(.system(size: size * 0.1))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Stat Card with Animation
struct AnimatedStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let delay: Double
    
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                scale = 1
                opacity = 1
            }
        }
    }
}

// MARK: - Motivational Quote Card
struct MotivationalQuoteCard: View {
    @State private var currentQuoteIndex = 0
    @State private var opacity: Double = 0
    
    let quotes = [
        "Small habits, big changes! 💪",
        "Consistency is key 🗝️",
        "You're doing amazing! 🌟",
        "One day at a time ⏰",
        "Build your future today 🚀",
        "Progress, not perfection ✨",
        "Make today count! 📅"
    ]
    
    var currentQuote: String {
        quotes[currentQuoteIndex]
    }
    
    var body: some View {
        GlassCard {
            HStack(spacing: 12) {
                Text("💭")
                    .font(.system(size: 32))
                
                Text(currentQuote)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .opacity(opacity)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startQuoteRotation()
        }
    }
    
    private func startQuoteRotation() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
                
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1
                }
            }
        }
    }
}

// MARK: - Streak Milestone Badge
struct StreakMilestoneBadge: View {
    let streak: Int
    @State private var isAnimating = false
    
    var milestone: (emoji: String, title: String)? {
        switch streak {
        case 7: return ("🎯", "Week Warrior")
        case 14: return ("💪", "Two Weeks Strong")
        case 30: return ("🔥", "Month Master")
        case 50: return ("⭐", "Halfway Hero")
        case 100: return ("👑", "Century Champion")
        case 365: return ("🏆", "Year Legend")
        default: return nil
        }
    }
    
    var body: some View {
        if let milestone = milestone {
            GlassCard {
                HStack(spacing: 16) {
                    Text(milestone.emoji)
                        .font(.system(size: 48))
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true), value: isAnimating)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Milestone Unlocked! 🎉")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(milestone.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("\(streak) day streak!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            AnimatedProgressRing(progress: 0.75, size: 120, lineWidth: 12)
            
            HStack(spacing: 16) {
                AnimatedStatCard(icon: "flame.fill", title: "Streak", value: "12", color: .orange, delay: 0)
                AnimatedStatCard(icon: "checkmark.circle.fill", title: "Done", value: "45", color: .green, delay: 0.1)
                AnimatedStatCard(icon: "chart.line.uptrend.xyaxis", title: "Rate", value: "92%", color: .blue, delay: 0.2)
            }
            .padding(.horizontal)
            
            MotivationalQuoteCard()
                .padding(.horizontal)
            
            StreakMilestoneBadge(streak: 30)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
    .modelContainer(for: [Habit.self, CheckIn.self])
}
