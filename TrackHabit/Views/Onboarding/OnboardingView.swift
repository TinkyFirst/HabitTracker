import SwiftUI
import SwiftData
import StoreKit

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @Namespace private var animationNamespace
    @StateObject private var storeManager = StoreManager.shared
    
    // Анімаційні стани
    @State private var backgroundOffset: CGFloat = 0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Animated Background - повністю покриває екран
            AnimatedBackground(offset: backgroundOffset)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        backgroundOffset = 360
                    }
                }
            
            VStack(spacing: 0) {
                // Custom Top Bar
                topBar
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(onboardingPages.indices, id: \.self) { index in
                        onboardingPages[index]
                            .tag(index)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                
                // Bottom Section
                VStack(spacing: 16) {
                    // Page Indicator
                    PageIndicator(currentPage: currentPage, totalPages: onboardingPages.count)
                        .padding(.top, 8)
                    
                    // Navigation Buttons
                    bottomButtons
                        .padding(.bottom, 20)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Top Bar
    
    private var topBar: some View {
        HStack {
            Spacer()
            
            // Skip Button (не на останній сторінці)
            if currentPage < onboardingPages.count - 1 {
                Button {
                    withAnimation(.spring()) {
                        currentPage = onboardingPages.count - 1
                    }
                } label: {
                    Text("onboarding.skip".localized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.15))
                        )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Onboarding Pages Array
    
    private var onboardingPages: [AnyView] {
        [
            AnyView(WelcomeSlide(namespace: animationNamespace)),
            AnyView(GuideSlide1(namespace: animationNamespace)),
            AnyView(GuideSlide2(namespace: animationNamespace)),
            AnyView(GuideSlide3(namespace: animationNamespace)),
            AnyView(FeaturesSlide(namespace: animationNamespace)),
            AnyView(PricingSlide(namespace: animationNamespace, storeManager: storeManager, completeAction: completeOnboarding))
        ]
    }
    
    // MARK: - Bottom Navigation Buttons
    
    @ViewBuilder
    private var bottomButtons: some View {
        HStack(spacing: 16) {
            // Back Button
            if currentPage > 0 {
                Button {
                    withAnimation(.spring()) {
                        currentPage = max(currentPage - 1, 0)
                        hapticFeedback()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("onboarding.back".localized)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(height: 52)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .fill(.white.opacity(0.15))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    )
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
            
            Spacer()
            
            // Next Button
            if currentPage < onboardingPages.count - 1 {
                Button {
                    withAnimation(.spring()) {
                        currentPage = min(currentPage + 1, onboardingPages.count - 1)
                        hapticFeedback()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(currentPage == onboardingPages.count - 2 ? "onboarding.seePricing".localized : "onboarding.next".localized)
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(height: 52)
                    .padding(.horizontal, 32)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            RoundedRectangle(cornerRadius: 26)
                                .fill(.white.opacity(0.2))
                                .blur(radius: 10)
                                .offset(y: -2)
                        }
                        .shadow(color: .purple.opacity(0.5), radius: 15, x: 0, y: 8)
                    )
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Complete Onboarding
    
    private func completeOnboarding() {
        hapticFeedback(style: .success)
        
        // Beautiful exit animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.9)) {
            showContent = false
        }
        
        // Fade out background
        withAnimation(.easeOut(duration: 0.6)) {
            backgroundOffset = 0
        }
        
        // Complete after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                hasCompletedOnboarding = true
            }
        }
    }
    
    private func hapticFeedback(style: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
}

// MARK: - Animated Background

struct AnimatedBackground: View {
    let offset: CGFloat
    
    var body: some View {
        ZStack {
            // Base gradient - ЯСКРАВИЙ зверху, темний внизу
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.20, blue: 0.40), // ЯСКРАВИЙ фіолетовий верх
                    Color(red: 0.22, green: 0.18, blue: 0.36),
                    Color(red: 0.20, green: 0.16, blue: 0.34),
                    Color(red: 0.18, green: 0.14, blue: 0.30),
                    Color(red: 0.15, green: 0.12, blue: 0.26),
                    Color(red: 0.12, green: 0.10, blue: 0.22)  // Темний низ
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Animated circles - яскравіші
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.6),
                                Color.purple.opacity(0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 350
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(
                        x: cos(Angle(degrees: offset + Double(index * 60)).radians) * 250,
                        y: sin(Angle(degrees: offset + Double(index * 60)).radians) * 250
                    )
                    .blur(radius: 70)
            }
        }
    }
}

// MARK: - Welcome Slide

private struct WelcomeSlide: View {
    var namespace: Namespace.ID
    
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var animateSubtitle = false
    @State private var showCheckmarks = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 30)
            
            // Animated Logo - чистий
            AppLogo(size: 100, shouldAnimate: true)
                .scaleEffect(animateLogo ? 1 : 0.3)
                .opacity(animateLogo ? 1 : 0)
                .padding(.bottom, 30)
            
            // Title (БЕЗ ГРАДІЄНТА)
            VStack(spacing: 8) {
                Text("onboarding.welcome.title".localized)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                Text("onboarding.welcome.subtitle".localized)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .opacity(animateSubtitle ? 1 : 0)
                    .offset(y: animateSubtitle ? 0 : 20)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            
            // Features preview - компактні
            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { index in
                    HStack(spacing: 10) {
                        Image(systemName: ["checkmark.circle.fill", "chart.line.uptrend.xyaxis", "star.fill"][index])
                            .font(.system(size: 18))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                        
                        Text(["onboarding.welcome.feature1".localized, "onboarding.welcome.feature2".localized, "onboarding.welcome.feature3".localized][index])
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.1))
                    )
                    .scaleEffect(showCheckmarks ? 1 : 0.9)
                    .opacity(showCheckmarks ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: showCheckmarks)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
                .frame(minHeight: 30)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateLogo = true
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                animateText = true
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5)) {
                animateSubtitle = true
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7)) {
                showCheckmarks = true
            }
        }
    }
}

// MARK: - Guide Slide 1: Create Habit

private struct GuideSlide1: View {
    var namespace: Namespace.ID
    
    @State private var showPhone = false
    @State private var showPlusButton = false
    @State private var currentHabitIndex = -1 // -1 = не показано, 0-2 = індекс звички
    
    let habits = [
        "onboarding.guide1.habit1".localized,
        "onboarding.guide1.habit2".localized,
        "onboarding.guide1.habit3".localized
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Step number
            Text("onboarding.step".localized + " 1 " + "onboarding.of".localized + " 3")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 16)
            
            // Title
            VStack(spacing: 6) {
                Text("onboarding.guide1.title".localized)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("onboarding.guide1.subtitle".localized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            
            // Animated Phone Mockup
            ZStack {
                // Phone frame
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 280, height: 420)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 20)
                    .scaleEffect(showPhone ? 1 : 0.8)
                    .opacity(showPhone ? 1 : 0)
                
                // Habit cards
                VStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        if index <= currentHabitIndex {
                            HStack(spacing: 12) {
                                ZStack {
                                    // Background circle (сірий)
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 28, height: 28)
                                    
                                    // Border circle - завжди сірий
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 28, height: 28)
                                }
                                
                                Text(habits[index])
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.white.opacity(0.1))
                            )
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                        }
                    }
                }
                .padding(24)
                .padding(.top, 30)
                
                // Plus button
                VStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 8)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(showPlusButton ? 1 : 0)
                    .rotationEffect(.degrees(showPlusButton ? 0 : 180))
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showPlusButton)
                }
                .padding(.bottom, 24)
            }
            .frame(height: 470)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            // Phone appears
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showPhone = true
            }
            
            // Plus button appears
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                showPlusButton = true
            }
            
            // Add habits one by one
            addHabitSequence()
        }
    }
    
    private func addHabitSequence() {
        // Звички з'являються по одній без виконання
        for index in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 + Double(index) * 0.6) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    currentHabitIndex = index
                }
            }
        }
    }
}

// MARK: - Guide Slide 2: Track Daily

private struct GuideSlide2: View {
    var namespace: Namespace.ID
    
    @State private var showPhone = false
    @State private var checkedItems: Set<Int> = []
    @State private var showConfetti = false
    @State private var hasAnimated = false // Додаємо флаг для однократної анімації
    
    let habits = [
        "onboarding.guide2.habit1".localized,
        "onboarding.guide2.habit2".localized,
        "onboarding.guide2.habit3".localized
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Step number
            Text("onboarding.step".localized + " 2 " + "onboarding.of".localized + " 3")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 16)
            
            // Title
            VStack(spacing: 6) {
                Text("onboarding.guide2.title".localized)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("onboarding.guide2.subtitle".localized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            
            // Animated Phone Mockup
            ZStack {
                // Phone frame
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 280, height: 420)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 20)
                    .scaleEffect(showPhone ? 1 : 0.8)
                    .opacity(showPhone ? 1 : 0)
                
                // Habit cards - ВСІ ОДРАЗУ ПОКАЗАНІ
                VStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: 12) {
                            ZStack {
                                // Background circle (сірий)
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 28, height: 28)
                                
                                // Border circle
                                Circle()
                                    .stroke(
                                        checkedItems.contains(index) ? Color.blue : Color.white.opacity(0.3),
                                        lineWidth: 2
                                    )
                                    .frame(width: 28, height: 28)
                                
                                // Checkmark (тільки коли виконано)
                                if checkedItems.contains(index) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.blue)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: checkedItems)
                            
                            Text(habits[index])
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .strikethrough(checkedItems.contains(index))
                                .opacity(checkedItems.contains(index) ? 0.6 : 1)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(checkedItems.contains(index) ? .blue.opacity(0.1) : .white.opacity(0.1))
                        )
                    }
                }
                .padding(24)
                .padding(.top, 30)
                
                // Confetti
                if showConfetti {
                    ForEach(0..<15, id: \.self) { index in
                        Circle()
                            .fill([Color.blue, Color.purple, Color.pink, Color.green, Color.orange].randomElement()!)
                            .frame(width: 8, height: 8)
                            .offset(
                                x: CGFloat.random(in: -100...100),
                                y: CGFloat.random(in: -200...50)
                            )
                            .opacity(0)
                            .animation(.easeOut(duration: 1).delay(Double(index) * 0.05), value: showConfetti)
                    }
                }
            }
            .frame(height: 470)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            // Запобігаємо повторній анімації
            guard !hasAnimated else { return }
            hasAnimated = true
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showPhone = true
            }
            
            // Виконуємо звички одну за одною
            checkHabitsSequence()
        }
    }
    
    private func checkHabitsSequence() {
        // Починаємо виконувати після появи телефону
        let startDelay = 1.0
        
        for index in 0..<habits.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + startDelay + Double(index) * 0.7) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    checkedItems.insert(index)
                }
                
                if index == habits.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            showConfetti = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Guide Slide 3: View Insights

private struct GuideSlide3: View {
    var namespace: Namespace.ID
    
    @State private var showPhone = false
    @State private var animateChart = false
    @State private var showStats = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Step number
            Text("onboarding.step".localized + " 3 " + "onboarding.of".localized + " 3")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 16)
            
            // Title
            VStack(spacing: 6) {
                Text("onboarding.guide3.title".localized)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("onboarding.guide3.subtitle".localized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            
            // Animated Phone Mockup
            ZStack {
                // Phone frame
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 280, height: 500)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 20)
                    .scaleEffect(showPhone ? 1 : 0.8)
                    .opacity(showPhone ? 1 : 0)
                
                VStack(spacing: 24) {
                    // Stats cards
                    HStack(spacing: 12) {
                        OnboardingStatCard(icon: "flame.fill", value: "7", label: "onboarding.guide3.dayStreak".localized, color: .orange, show: showStats)
                        OnboardingStatCard(icon: "star.fill", value: "45", label: "onboarding.guide3.completed".localized, color: .yellow, show: showStats)
                    }
                    .padding(.top, 40)
                    
                    // Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("onboarding.guide3.thisWeek".localized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(0..<7, id: \.self) { index in
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .bottom, // Змінено з .top на .bottom
                                                endPoint: .top // Змінено з .bottom на .top
                                            )
                                        )
                                        .frame(width: 24, height: animateChart ? CGFloat([40, 65, 45, 80, 55, 90, 70][index]) : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1), value: animateChart)
                                    
                                    Text(["M", "T", "W", "T", "F", "S", "S"][index])
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                        .frame(height: 100)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.1))
                    )
                }
                .padding(24)
            }
            .frame(height: 550)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showPhone = true
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                showStats = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                animateChart = true
            }
        }
    }
}

private struct OnboardingStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let show: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.1))
        )
        .scaleEffect(show ? 1 : 0.8)
        .opacity(show ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: show)
    }
}

// MARK: - Features Slide

private struct FeaturesSlide: View {
    var namespace: Namespace.ID
    
    @State private var showTitle = false
    @State private var selectedFeature = 0
    
    let features: [(emoji: String, title: String, description: String, color: Color)] = [
        ("📊", "onboarding.features.insights".localized, "onboarding.features.insightsDesc".localized, .blue),
        ("🔔", "onboarding.features.reminders".localized, "onboarding.features.remindersDesc".localized, .purple),
        ("🎯", "onboarding.features.goals".localized, "onboarding.features.goalsDesc".localized, .pink),
        ("☁️", "onboarding.features.icloud".localized, "onboarding.features.icloudDesc".localized, .cyan),
        ("🎨", "onboarding.features.customization".localized, "onboarding.features.customizationDesc".localized, .orange),
        ("🏆", "onboarding.features.achievements".localized, "onboarding.features.achievementsDesc".localized, .yellow)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Title
            VStack(spacing: 10) {
                Text("onboarding.features.title".localized)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .scaleEffect(showTitle ? 1 : 0.8)
                    .opacity(showTitle ? 1 : 0)
                
                Text("onboarding.features.subtitle".localized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .scaleEffect(showTitle ? 1 : 0.8)
                    .opacity(showTitle ? 1 : 0)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 36)
            
            // Feature Cards Carousel
            TabView(selection: $selectedFeature) {
                ForEach(features.indices, id: \.self) { index in
                    FeatureCardView(
                        emoji: features[index].emoji,
                        title: features[index].title,
                        description: features[index].description,
                        color: features[index].color
                    )
                    .tag(index)
                    .padding(.horizontal, 40)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Custom Page Indicator
            HStack(spacing: 8) {
                ForEach(features.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedFeature == index ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(selectedFeature == index ? 1.2 : 1)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedFeature)
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showTitle = true
            }
            
            // Auto-rotate features
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    selectedFeature = (selectedFeature + 1) % features.count
                }
            }
        }
    }
}

private struct FeatureCardView: View {
    let emoji: String
    let title: String
    let description: String
    let color: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Emoji with animated background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Text(emoji)
                    .font(.system(size: 50))
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white.opacity(0.1))
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Pricing Slide (Last)

private struct PricingSlide: View {
    var namespace: Namespace.ID
    @ObservedObject var storeManager: StoreManager
    let completeAction: () -> Void
    
    @State private var showTitle = false
    @State private var showPlans = false
    @State private var selectedPlan: String? = "yearly"
    @State private var purchasing = false
    @State private var restoring = false
    @State private var showRestoreAlert = false
    @State private var restoreAlertMessage = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Title Section
                VStack(spacing: 12) {
                    Text("✨")
                        .font(.system(size: 50))
                        .scaleEffect(showTitle ? 1 : 0)
                        .rotationEffect(.degrees(showTitle ? 0 : 180))
                    
                    Text("onboarding.pricing.title".localized)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .multilineTextAlignment(.center)
                        .scaleEffect(showTitle ? 1 : 0.8)
                        .opacity(showTitle ? 1 : 0)
                    
                    Text("onboarding.pricing.subtitle".localized)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .scaleEffect(showTitle ? 1 : 0.8)
                        .opacity(showTitle ? 1 : 0)
                }
                .padding(.top, 30)
                .padding(.bottom, 24)
                .padding(.horizontal, 32)
                
                // Pro Features Grid
                VStack(spacing: 12) {
                    ProFeatureRow(icon: "infinity", text: "onboarding.pricing.unlimitedHabits".localized, show: showPlans)
                    ProFeatureRow(icon: "chart.bar.fill", text: "onboarding.pricing.advancedAnalytics".localized, show: showPlans, delay: 0.1)
                    ProFeatureRow(icon: "paintbrush.fill", text: "onboarding.pricing.customThemes".localized, show: showPlans, delay: 0.2)
                    ProFeatureRow(icon: "app.badge.fill", text: "onboarding.pricing.widgetCustomization".localized, show: showPlans, delay: 0.3)
                    ProFeatureRow(icon: "bell.badge.fill", text: "onboarding.pricing.smartNotifications".localized, show: showPlans, delay: 0.4)
                    ProFeatureRow(icon: "icloud.fill", text: "onboarding.pricing.icloudSync".localized, show: showPlans, delay: 0.5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
                
                // Pricing Plans
                VStack(spacing: 16) {
                    if storeManager.products.isEmpty {
                        // Mock pricing cards для демо
                        PricingPlanCardMock(
                            planName: "onboarding.pricing.yearly".localized,
                            price: "$19.99",
                            description: "onboarding.pricing.bestValue".localized,
                            isPopular: true,
                            isSelected: selectedPlan == "yearly",
                            show: showPlans,
                            onTap: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedPlan = "yearly"
                                }
                                hapticFeedback()
                            },
                            onPurchase: {
                                // Show message that products are loading
                                completeAction()
                            }
                        )
                        
                        PricingPlanCardMock(
                            planName: "onboarding.pricing.monthly".localized,
                            price: "$2.99",
                            description: "onboarding.pricing.billedMonthly".localized,
                            isPopular: false,
                            isSelected: selectedPlan == "monthly",
                            show: showPlans,
                            onTap: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedPlan = "monthly"
                                }
                                hapticFeedback()
                            },
                            onPurchase: {
                                completeAction()
                            }
                        )
                    } else {
                        // Real products from StoreKit
                        ForEach(storeManager.products, id: \.id) { product in
                            PricingPlanCard(
                                product: product,
                                isSelected: selectedPlan == getPlanId(for: product),
                                show: showPlans,
                                onTap: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selectedPlan = getPlanId(for: product)
                                    }
                                    hapticFeedback()
                                },
                                onPurchase: {
                                    Task {
                                        await purchase(product: product)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                // Continue Button
                Button {
                    completeAction()
                } label: {
                    Text("onboarding.continueWithFree".localized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(.white.opacity(0.1))
                        )
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 40)
                .disabled(purchasing)
                
                // Terms
                Text("onboarding.pricing.terms".localized)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showTitle = true
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                showPlans = true
            }
        }
    }
    
    private func getPlanId(for product: StoreKit.Product) -> String {
        if product.displayName.lowercased().contains("year") {
            return "yearly"
        } else if product.displayName.lowercased().contains("month") {
            return "monthly"
        } else {
            return "lifetime"
        }
    }
    
    private func purchase(product: StoreKit.Product) async {
        guard !purchasing else { return }
        purchasing = true
        
        do {
            _ = try await storeManager.purchase(product)
            hapticFeedback(style: .success)
            completeAction()
        } catch {
            print("Purchase failed: \(error)")
            hapticFeedback(style: .error)
        }
        
        purchasing = false
    }
    
    private func hapticFeedback(style: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
}

private struct ProFeatureRow: View {
    let icon: String
    let text: String
    let show: Bool
    var delay: Double = 0
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(.green)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
        )
        .scaleEffect(show ? 1 : 0.8)
        .opacity(show ? 1 : 0)
        .offset(x: show ? 0 : -30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: show)
    }
}

private struct PricingPlanCard: View {
    let product: StoreKit.Product
    let isSelected: Bool
    let show: Bool
    let onTap: () -> Void
    let onPurchase: () -> Void
    
    @State private var isPressed = false
    
    private var isPopular: Bool {
        product.displayName.lowercased().contains("year")
    }
    
    private var planName: String {
        if product.displayName.lowercased().contains("year") {
            return "onboarding.pricing.yearly".localized
        } else if product.displayName.lowercased().contains("month") {
            return "onboarding.pricing.monthly".localized
        } else {
            return "Lifetime"
        }
    }
    
    private var savings: String? {
        if isPopular {
            return "onboarding.pricing.bestValue".localized
        }
        return nil
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 0) {
                // Popular badge
                if let savings = savings {
                    HStack {
                        Spacer()
                        Text(savings)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .green.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(planName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text(product.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.6))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(product.displayPrice)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        if planName == "onboarding.pricing.yearly".localized {
                            Text("$0.19" + "onboarding.pricing.perDay".localized)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .padding(20)
                
                // Purchase button
                if isSelected {
                    Button {
                        onPurchase()
                    } label: {
                        HStack {
                            Text("onboarding.pricing.subscribeNow".localized)
                                .font(.system(size: 17, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.white.opacity(0.08), .white.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        isSelected ?
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.white.opacity(0.2), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ? Color.purple.opacity(0.4) : Color.black.opacity(0.1),
                radius: isSelected ? 20 : 10,
                x: 0,
                y: isSelected ? 10 : 5
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .scaleEffect(show ? 1 : 0.9)
        .opacity(show ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(isPopular ? 0.1 : 0.2), value: show)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Mock Pricing Card (for demo when products not loaded)

private struct PricingPlanCardMock: View {
    let planName: String
    let price: String
    let description: String
    let isPopular: Bool
    let isSelected: Bool
    let show: Bool
    let onTap: () -> Void
    let onPurchase: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 0) {
                // Popular badge
                if isPopular {
                    HStack {
                        Spacer()
                        Text(description)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .green.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(planName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                        
                        if !isPopular {
                            Text(description)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.6))
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(price)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        if planName == "onboarding.pricing.yearly".localized {
                            Text("$0.19" + "onboarding.pricing.perDay".localized)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .padding(20)
                
                // Purchase button
                if isSelected {
                    Button {
                        onPurchase()
                    } label: {
                        HStack {
                            Text("onboarding.pricing.subscribeNow".localized)
                                .font(.system(size: 17, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [.white.opacity(0.15), .white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.white.opacity(0.08), .white.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        isSelected ?
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.white.opacity(0.2), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ? Color.purple.opacity(0.4) : Color.black.opacity(0.1),
                radius: isSelected ? 20 : 10,
                x: 0,
                y: isSelected ? 10 : 5
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .scaleEffect(show ? 1 : 0.9)
        .opacity(show ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(isPopular ? 0.1 : 0.2), value: show)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Page Indicator

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview("Onboarding") {
    OnboardingView()
        .preferredColorScheme(.dark)
        .modelContainer(for: [Habit.self, CheckIn.self], inMemory: true)
}

#Preview("Welcome Slide") {
    PreviewWrapper { namespace in
        ZStack {
            AnimatedBackground(offset: 0)
                .ignoresSafeArea()
            
            WelcomeSlide(namespace: namespace)
        }
    }
}

#Preview("Guide 1") {
    PreviewWrapper { namespace in
        ZStack {
            AnimatedBackground(offset: 0)
                .ignoresSafeArea()
            
            GuideSlide1(namespace: namespace)
        }
    }
}

#Preview("Guide 2") {
    PreviewWrapper { namespace in
        ZStack {
            AnimatedBackground(offset: 0)
                .ignoresSafeArea()
            
            GuideSlide2(namespace: namespace)
        }
    }
}

#Preview("Guide 3") {
    PreviewWrapper { namespace in
        ZStack {
            AnimatedBackground(offset: 0)
                .ignoresSafeArea()
            
            GuideSlide3(namespace: namespace)
        }
    }
}

#Preview("Features") {
    PreviewWrapper { namespace in
        ZStack {
            AnimatedBackground(offset: 0)
                .ignoresSafeArea()
            
            FeaturesSlide(namespace: namespace)
        }
    }
}

// Helper для previews з namespace
private struct PreviewWrapper<Content: View>: View {
    @Namespace private var namespace
    let content: (Namespace.ID) -> Content
    
    var body: some View {
        content(namespace)
            .preferredColorScheme(.dark)
    }
}


