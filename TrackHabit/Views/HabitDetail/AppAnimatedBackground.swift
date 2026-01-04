import SwiftUI

/// Animated background for main app (subtle version)
struct AppAnimatedBackground: View {
    @State private var offset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: colorScheme == .dark ? [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.08, green: 0.08, blue: 0.18),
                    Color(red: 0.10, green: 0.10, blue: 0.22),
                    Color(red: 0.08, green: 0.12, blue: 0.20)
                ] : [
                    Color(white: 0.96),
                    Color(white: 0.94),
                    Color(white: 0.92),
                    Color(white: 0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Animated circles (subtle for app)
            if colorScheme == .dark {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.blue.opacity(0.15),
                                    Color.purple.opacity(0.10),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 300
                            )
                        )
                        .frame(width: 600, height: 600)
                        .offset(
                            x: cos(Angle(degrees: offset + Double(index * 90)).radians) * 200,
                            y: sin(Angle(degrees: offset + Double(index * 90)).radians) * 200
                        )
                        .blur(radius: 60)
                }
            } else {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.blue.opacity(0.05),
                                    Color.purple.opacity(0.03),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 250
                            )
                        )
                        .frame(width: 500, height: 500)
                        .offset(
                            x: cos(Angle(degrees: offset + Double(index * 120)).radians) * 150,
                            y: sin(Angle(degrees: offset + Double(index * 120)).radians) * 150
                        )
                        .blur(radius: 50)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                offset = 360
            }
        }
    }
}

#Preview("Dark Mode") {
    ZStack {
        AppAnimatedBackground()
        
        VStack {
            Text("Track Habit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Animated Background")
                .foregroundColor(.white.opacity(0.7))
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    ZStack {
        AppAnimatedBackground()
        
        VStack {
            Text("Track Habit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Animated Background")
                .foregroundColor(.gray)
        }
    }
    .preferredColorScheme(.light)
}
