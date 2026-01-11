# 🇺🇦 Onboarding Localization - Checklist

## ✅ Completed:
- Skip button
- Back button  
- Next / See Pricing buttons
- Welcome slide (title, subtitle, features)

## 🔄 Потрібно замінити:

### GuideSlide1:
```swift
"Step 1 of 3" → "\("onboarding.step".localized) 1 \("onboarding.of".localized) 3"
"Create Your Habits" → "onboarding.guide1.title".localized
"Tap + to add new habits" → "onboarding.guide1.subtitle".localized
```

### GuideSlide2:
```swift
"Step 2 of 3" → "\("onboarding.step".localized) 2 \("onboarding.of".localized) 3"
"Track Daily" → "onboarding.guide2.title".localized
"Check off completed habits" → "onboarding.guide2.subtitle".localized
```

### GuideSlide3:
```swift
"Step 3 of 3" → "\("onboarding.step".localized) 3 \("onboarding.of".localized) 3"
"Track Progress" → "onboarding.guide3.title".localized
"View insights and analytics" → "onboarding.guide3.subtitle".localized
"Day Streak" → "onboarding.guide3.dayStreak".localized
"Completed" → "onboarding.guide3.completed".localized
"This Week" → "onboarding.guide3.thisWeek".localized
```

### FeaturesSlide:
```swift
"Powerful Features" → "onboarding.features.title".localized
"Everything you need..." → "onboarding.features.subtitle".localized
// Всі 6 features з titles та descriptions
```

### PricingSlide:
```swift
"Go Pro" → "onboarding.pricing.title".localized
"Unlock unlimited..." → "onboarding.pricing.subtitle".localized
"Unlimited habits" → "onboarding.pricing.unlimitedHabits".localized
// І всі інші елементи
"Continue with Free" → "onboarding.continueWithFree".localized
"Terms & Privacy Policy" → "onboarding.pricing.terms".localized
```

## Команди для масової заміни:

Через обмеження розміру, рекомендую зробити це вручну або частинами.
