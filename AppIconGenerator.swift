import SwiftUI
import UIKit

/// Тимчасовий генератор іконки додатку БЕЗ прозорості
/// 
/// ЯК ВИКОРИСТОВУВАТИ:
/// 1. Запустіть додаток
/// 2. Викличте AppIconGenerator.generateAndSaveIcons()
/// 3. Іконки збережуться в Documents і будуть виведені в консолі
/// 4. Скопіюйте іконки з консолі (File → Show in Finder)
/// 5. Додайте їх у Assets.xcassets → AppIcon

struct AppIconGenerator {
    
    /// Генерує іконку додатку на НЕПРОЗОРОМУ фоні
    static func generateIcon(size: CGSize) -> UIImage {
        let renderer = UIImageRenderer(size: size)
        
        return renderer.image { context in
            // ✅ ВАЖЛИВО: Непрозорий фон (градієнт)
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [
                    UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0).cgColor,
                    UIColor(red: 0.5, green: 0.2, blue: 0.7, alpha: 1.0).cgColor
                ] as CFArray,
                locations: [0.0, 1.0]
            )!
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            // Малюємо кільце прогресу (як у логотипі)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.35
            let lineWidth = radius * 0.25
            
            // Зовнішнє кільце (біле)
            context.cgContext.setStrokeColor(UIColor.white.cgColor)
            context.cgContext.setLineWidth(lineWidth)
            context.cgContext.setLineCap(.round)
            
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: -CGFloat.pi / 2,
                endAngle: CGFloat.pi * 1.5,
                clockwise: true
            )
            path.stroke()
            
            // Яскравий акцент (cyan)
            context.cgContext.setStrokeColor(UIColor.cyan.cgColor)
            context.cgContext.setLineWidth(lineWidth * 1.2)
            
            let accentPath = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: -CGFloat.pi / 2,
                endAngle: 0,
                clockwise: true
            )
            accentPath.stroke()
            
            // Центральна галочка або символ
            context.cgContext.setFillColor(UIColor.white.cgColor)
            let checkmarkSize = radius * 0.8
            let checkmarkRect = CGRect(
                x: center.x - checkmarkSize / 2,
                y: center.y - checkmarkSize / 2,
                width: checkmarkSize,
                height: checkmarkSize
            )
            
            // Проста галочка (як checkmark)
            context.cgContext.setStrokeColor(UIColor.white.cgColor)
            context.cgContext.setLineWidth(lineWidth * 0.4)
            context.cgContext.setLineCap(.round)
            context.cgContext.setLineJoin(.round)
            
            let checkPath = UIBezierPath()
            checkPath.move(to: CGPoint(
                x: checkmarkRect.minX + checkmarkRect.width * 0.25,
                y: checkmarkRect.midY
            ))
            checkPath.addLine(to: CGPoint(
                x: checkmarkRect.midX - checkmarkRect.width * 0.1,
                y: checkmarkRect.maxY - checkmarkRect.height * 0.3
            ))
            checkPath.addLine(to: CGPoint(
                x: checkmarkRect.maxX - checkmarkRect.width * 0.2,
                y: checkmarkRect.minY + checkmarkRect.height * 0.25
            ))
            checkPath.stroke()
        }
    }
    
    /// Генерує всі розміри іконок та зберігає їх
    static func generateAndSaveIcons() {
        // Розміри іконок для iOS
        let sizes: [(size: CGFloat, scale: CGFloat, name: String)] = [
            (20, 2, "Icon-20@2x"),
            (20, 3, "Icon-20@3x"),
            (29, 2, "Icon-29@2x"),
            (29, 3, "Icon-29@3x"),
            (40, 2, "Icon-40@2x"),
            (40, 3, "Icon-40@3x"),
            (60, 2, "Icon-60@2x"),
            (60, 3, "Icon-60@3x"),
            (1024, 1, "Icon-1024") // App Store
        ]
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let iconsFolder = documentsPath.appendingPathComponent("AppIcons")
        
        try? FileManager.default.createDirectory(at: iconsFolder, withIntermediateDirectories: true)
        
        print("\n" + String(repeating: "=", count: 60))
        print("📱 ГЕНЕРАЦІЯ ІКОНОК ДОДАТКУ (БЕЗ ПРОЗОРОСТІ)")
        print(String(repeating: "=", count: 60))
        print("📍 Папка: \(iconsFolder.path)\n")
        
        for item in sizes {
            let pixelSize = CGSize(
                width: item.size * item.scale,
                height: item.size * item.scale
            )
            
            let image = generateIcon(size: pixelSize)
            
            // Перевіряємо, що немає прозорості
            guard let imageData = image.pngData() else {
                print("❌ Не вдалося створити PNG для \(item.name)")
                continue
            }
            
            let fileURL = iconsFolder.appendingPathComponent("\(item.name).png")
            
            do {
                try imageData.write(to: fileURL)
                print("✅ \(item.name).png (\(Int(pixelSize.width))x\(Int(pixelSize.height)))")
            } catch {
                print("❌ Помилка збереження \(item.name): \(error)")
            }
        }
        
        print("\n" + String(repeating: "=", count: 60))
        print("✅ ГОТОВО! Відкрийте папку:")
        print("📂 \(iconsFolder.path)")
        print(String(repeating: "=", count: 60))
        print("\n📋 ЯК ДОДАТИ ІКОНКИ:")
        print("1. У Finder: Відкрийте папку AppIcons")
        print("2. У Xcode: Assets.xcassets → AppIcon")
        print("3. Перетягніть відповідні іконки у правильні слоти")
        print("4. Icon-1024.png → App Store iOS 1024pt слот")
        print(String(repeating: "=", count: 60) + "\n")
    }
}

// MARK: - Preview для тестування

struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("App Icon Preview")
                .font(.title.bold())
            
            // Preview іконки
            Image(uiImage: AppIconGenerator.generateIcon(size: CGSize(width: 512, height: 512)))
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(40)
                .shadow(radius: 20)
            
            Button("Згенерувати всі іконки") {
                AppIconGenerator.generateAndSaveIcons()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Перевірте консоль після натискання")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    AppIconPreview()
}
