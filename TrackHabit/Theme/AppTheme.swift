import SwiftUI

struct AppTheme {
    // MARK: - Colors
    static let presetColors: [PresetColor] = [
        PresetColor(name: "Blue", hex: "#4A90E2"),
        PresetColor(name: "Green", hex: "#50C878"),
        PresetColor(name: "Red", hex: "#FF6B6B"),
        PresetColor(name: "Purple", hex: "#9B59B6"),
        PresetColor(name: "Orange", hex: "#F39C12"),
        PresetColor(name: "Pink", hex: "#EC407A"),
        PresetColor(name: "Teal", hex: "#1ABC9C"),
        PresetColor(name: "Yellow", hex: "#F8B500"),
        PresetColor(name: "Indigo", hex: "#5C6BC0"),
        PresetColor(name: "Mint", hex: "#95E1D3"),
    ]

    // MARK: - Glass Effect
    static func glassBackground(colorScheme: ColorScheme) -> some View {
        colorScheme == .dark
            ? Color.white.opacity(0.1)
            : Color.white.opacity(0.7)
    }

    static func glassBorder(colorScheme: ColorScheme) -> some View {
        colorScheme == .dark
            ? Color.white.opacity(0.2)
            : Color.white.opacity(0.3)
    }

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32

    // MARK: - Corner Radius
    static let cornerRadiusS: CGFloat = 8
    static let cornerRadiusM: CGFloat = 12
    static let cornerRadiusL: CGFloat = 16
    static let cornerRadiusXL: CGFloat = 24

    // MARK: - Shadow
    static let shadowRadius: CGFloat = 10
    static let shadowOpacity: Double = 0.1
}

struct PresetColor: Identifiable {
    let id = UUID()
    let name: String
    let hex: String

    var color: Color {
        Color(hex: hex)
    }
}

// MARK: - Color Extension for Hex
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
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
