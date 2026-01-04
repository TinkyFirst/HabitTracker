# ✅ Onboarding Testing Checklist

## 🎯 Pre-Launch Testing

### Basic Flow
- [ ] Онбординг показується при першому запуску
- [ ] Всі 6 слайдів відображаються правильно
- [ ] Свайп працює ліворуч/праворуч
- [ ] Back/Next кнопки працюють
- [ ] Skip button веде на pricing
- [ ] Page indicator оновлюється

### Animations
- [ ] Background крутиться плавно
- [ ] Welcome slide: logo анімується
- [ ] Welcome slide: particles з'являються
- [ ] Guide 1: phone з'являється
- [ ] Guide 1: plus button обертається
- [ ] Guide 1: typing simulation працює
- [ ] Guide 2: habits автоматично checkmark'ються
- [ ] Guide 2: confetti з'являється
- [ ] Guide 3: stats cards з'являються
- [ ] Guide 3: chart bars анімуються
- [ ] Features: carousel auto-rotates
- [ ] Pricing: cards анімуються

### Pricing Page
- [ ] Products завантажуються
- [ ] Pricing cards відображаються
- [ ] Selection працює (gradient border)
- [ ] "Subscribe Now" button з'являється
- [ ] Purchase flow працює
- [ ] "Continue with Free" закриває онбординг
- [ ] Haptic feedback працює

### Edge Cases
- [ ] Працює на iPhone SE (малий екран)
- [ ] Працює на iPhone 15 Pro Max (великий екран)
- [ ] Швидкий свайп не ламає анімації
- [ ] Rotation handling (якщо підтримується)
- [ ] Низька memory не крашить
- [ ] Без інтернету показує placeholder

### Performance
- [ ] 60 FPS на всіх слайдах
- [ ] Немає memory leaks
- [ ] Немає затримок при navigation
- [ ] Smooth transitions
- [ ] Background animation не лагає

## 🐛 Known Issues & Fixes

### Issue: Онбординг не показується
**Fix:**
```swift
// Reset в Settings або Debug menu
UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
```

### Issue: Products не завантажуються
**Fix:**
- Перевірити StoreKit configuration
- Перевірити internet connection
- Перевірити sandbox account

### Issue: Анімації laggy
**Fix:**
- Зменшити blur radius у background
- Оптимізувати кількість particles
- Використовувати `.drawingGroup()` для complex views

### Issue: Typing simulation не працює
**Fix:**
- Перевірити delays в `DispatchQueue.main.asyncAfter`
- Переконатися що view не dismissed раніше

## 🎨 Visual QA

### Colors
- [ ] Background gradient виглядає добре
- [ ] Text readable на всіх backgrounds
- [ ] Gradient buttons виділяються
- [ ] Selected card має чіткий gradient border
- [ ] Shadows не занадто сильні

### Typography
- [ ] Titles чіткі і readable
- [ ] Descriptions readable
- [ ] Prices виділяються
- [ ] Consistent font weights

### Spacing
- [ ] Padding між елементами однаковий
- [ ] Cards не торкаються країв екрана
- [ ] Text не обрізається
- [ ] Buttons не перекриваються

## 📱 Device Testing

### iPhone Models
- [ ] iPhone SE (2022) - малий екран
- [ ] iPhone 14 - стандарт
- [ ] iPhone 14 Pro - Dynamic Island
- [ ] iPhone 15 Pro Max - великий екран

### iOS Versions
- [ ] iOS 17.0
- [ ] iOS 17.5
- [ ] iOS 18.0 (latest)

## ♿ Accessibility

### VoiceOver
- [ ] Всі buttons accessible
- [ ] Slides мають accessible labels
- [ ] Navigation логічна
- [ ] Ціни читаються правильно

### Dynamic Type
- [ ] Text scales правильно
- [ ] Layout не ламається при largest text
- [ ] Buttons залишаються tapable

### Reduced Motion
- [ ] Можна додати `@Environment(\.accessibilityReduceMotion)`
- [ ] Fallback на simpler animations

## 🚀 Launch Checklist

### Before Release
- [ ] Всі тести пройдено
- [ ] StoreKit products налаштовані
- [ ] Privacy policy посилання працює
- [ ] Terms посилання працює
- [ ] Analytics tracking додано
- [ ] A/B testing setup (optional)

### After Release
- [ ] Monitor completion rate
- [ ] Monitor skip rate
- [ ] Monitor purchase rate
- [ ] Collect user feedback
- [ ] Track crashes/errors

## 💡 Optimization Ideas

### Metrics to Track
1. **Completion Rate** - % users who finish onboarding
2. **Skip Rate** - % users who skip to pricing
3. **Time per Slide** - Average time spent
4. **Purchase Rate** - % who buy on pricing page
5. **Drop-off Points** - Where users exit

### Improvements Based on Data
- Якщо низька completion rate → зменшити кількість slides
- Якщо висока skip rate → покращити content
- Якщо низька purchase rate → переробити pricing
- Якщо довго на якомусь slide → simplify

## 🎯 Success Metrics

### Good Numbers
- ✅ Completion rate > 80%
- ✅ Average time 2-3 minutes
- ✅ Purchase rate > 5%
- ✅ Skip rate < 20%

### Red Flags
- ❌ Completion rate < 50%
- ❌ Average time > 5 minutes
- ❌ High crash rate
- ❌ Skip rate > 50%

## 📝 Notes

Додаткові зауваження під час тестування:

---

**Last Updated:** 3 Jan 2026  
**Version:** 1.0
