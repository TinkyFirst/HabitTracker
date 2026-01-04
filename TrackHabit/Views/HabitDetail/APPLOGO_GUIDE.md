# App Logo Usage Guide

## 🎨 Про дизайн

Новий логотип додатку **Track Habit** виконаний у стилі glass morphism з 3D ефектами. Він символізує:
- **Progress Ring** (кільце прогресу) - основна концепція відстеження звичок
- **Continuous Motion** (безперервний рух) - ідея щоденного прогресу
- **Glass Effect** (скляний ефект) - сучасний, преміальний дизайн

## 📦 Компоненти

### 1. `AppLogo` - Анімована версія
Використовується для onboarding та splash screens.

```swift
AppLogo(size: 180, shouldAnimate: true)
```

**Анімації:**
- Безперервне обертання outer ring (8 секунд)
- Контр-обертання inner segment (6 секунд)
- Пульсація glow ефекту (2 секунди)
- Прогрес заповнення кільця (3 секунди)

**Параметри:**
- `size: CGFloat` - розмір лого (за замовчуванням 150)
- `shouldAnimate: Bool` - увімкнути анімацію (за замовчуванням true)

### 2. `AppLogoStatic` - Статична версія
Використовується для невеликих іконок, navigation bar, settings.

```swift
AppLogoStatic(size: 32)
```

**Параметри:**
- `size: CGFloat` - розмір лого (за замовчуванням 100)

## 🎬 Анімаційні ефекти

### Rotation Animation
```swift
// Main ring - повільне обертання за годинниковою
withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
    rotationDegrees = 360
}

// Inner segment - швидке контр-обертання
withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
    innerRotation = -360
}
```

### Progress Fill
```swift
// Симуляція заповнення прогресу
withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
    progressAnimation = 0.85 // 85% заповнення
}
```

### Glow Pulse
```swift
// М'яка пульсація світіння
withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
    pulseScale = 1.15
    glowIntensity = 0.5
}
```

## 🎯 Використання в проекті

### Onboarding Welcome Screen
```swift
// OnboardingView.swift - WelcomeSlide
AppLogo(size: 180, shouldAnimate: animateLogo)
    .scaleEffect(animateLogo ? 1 : 0.3)
    .opacity(animateLogo ? 1 : 0)
```

### Navigation Bar
```swift
// OnboardingView.swift - topBar
AppLogoStatic(size: 32)
    .rotationEffect(.degrees(backgroundOffset / 10))
```

### Settings/About Page
```swift
// Можна додати в AboutView
VStack {
    AppLogo(size: 120, shouldAnimate: false)
    Text("Track Habit")
        .font(.title)
}
```

### Launch Screen
```swift
// Для LaunchScreen можна використати статичну версію
ZStack {
    Color.black.ignoresSafeArea()
    AppLogoStatic(size: 150)
}
```

## 🎨 Колірна схема

### Градієнти
```swift
// Main Progress Ring - Angular Gradient
Color.white → Color.cyan → Color.blue → Color.purple → Color.white

// Bright Accent Segment
Color.white (0.9 opacity) → Color.cyan (0.3 opacity)

// Background Glow
Color.blue (0.3-0.5 opacity) → Color.purple (0.15-0.25 opacity)
```

### Товщина ліній
- Outer ring: `size * 0.08` (8% від розміру)
- Inner segment: `size * 0.12` (12% від розміру, товстіша для акценту)

## 💡 Поради з дизайну

### Розміри для різних контекстів
- **Onboarding/Hero**: 150-200pt
- **Settings/About**: 80-120pt
- **Navigation Bar**: 28-36pt
- **Tab Bar Icon**: 24-30pt (використати static версію)
- **Widget Icon**: 40-60pt

### Background
Лого виглядає найкраще на:
- Темних градієнтах (blue → purple)
- Напівпрозорих background з blur
- Темних solid кольорах (не на білому!)

### Доступність
- Статична версія автоматично підтримує reduced motion
- Анімована версія можна вимкнути через `shouldAnimate: false`
- Контрастність відповідає WCAG AA стандартам

## 🔧 Оптимізація

### Performance
- Анімації використовують `.linear` та `.easeInOut` для smooth performance
- Glow effects оптимізовані через `RadialGradient` замість shadow
- Blur radius обмежений до 30pt максимум

### Адаптивність
```swift
// Автоматичне масштабування під різні розміри екранів
let logoSize = min(UIScreen.main.bounds.width * 0.5, 200)
AppLogo(size: logoSize)
```

## 📱 App Icon Integration

Для створення app icon можна експортувати статичну версію:
1. Відкрити `AppLogo.swift` preview
2. Використати `AppLogoStatic(size: 1024)` для найбільшого розміру
3. Експортувати як PNG з темним background

## 🚀 Майбутні покращення

- [ ] Інтерактивна версія (реагує на gesture)
- [ ] Різні кольорові теми (blue, green, orange варіанти)
- [ ] Версія для dark/light mode
- [ ] Particle effects для celebration анімацій
- [ ] Integration з haptic feedback

---

Made with ❤️ for Track Habit
