import Foundation
import SwiftUI

struct HabitTemplate: Identifiable {
    let id = UUID()
    let titleKey: String  // Localization key
    let icon: String
    let colorHex: String
    let category: TemplateCategory
    let exampleKey: String  // Localization key
    
    var title: String {
        LocalizedStrings.get(titleKey)
    }
    
    var example: String {
        return "" // Examples not shown in UI
    }

    enum TemplateCategory: String, CaseIterable {
        case health = "Health"
        case mindfulness = "Mindfulness"
        case productivity = "Productivity"
        case learning = "Learning"
        case social = "Social"
        case creative = "Creative"
        
        var displayName: String {
            LocalizedStrings.get(rawValue)
        }
    }
}

// MARK: - Predefined Templates
extension HabitTemplate {
    static let templates: [HabitTemplate] = [
        // Health
        HabitTemplate(titleKey: "template.drinkWater", icon: "💧", colorHex: "#4A90E2", category: .health, exampleKey: "template.drinkWaterExample"),
        HabitTemplate(titleKey: "template.stretch", icon: "🧘", colorHex: "#50C878", category: .health, exampleKey: "template.stretchExample"),
        HabitTemplate(titleKey: "template.walk", icon: "🚶", colorHex: "#FF6B6B", category: .health, exampleKey: "template.walkExample"),
        HabitTemplate(titleKey: "template.deepBreathing", icon: "🫁", colorHex: "#95E1D3", category: .health, exampleKey: "template.deepBreathingExample"),
        HabitTemplate(titleKey: "template.vitamins", icon: "💊", colorHex: "#F38181", category: .health, exampleKey: "template.vitaminsExample"),
        HabitTemplate(titleKey: "template.exercise", icon: "💪", colorHex: "#AA96DA", category: .health, exampleKey: "template.exerciseExample"),

        // Mindfulness
        HabitTemplate(titleKey: "template.meditate", icon: "🧘‍♀️", colorHex: "#9B59B6", category: .mindfulness, exampleKey: "template.meditateExample"),
        HabitTemplate(titleKey: "template.gratitude", icon: "🙏", colorHex: "#F39C12", category: .mindfulness, exampleKey: "template.gratitudeExample"),
        HabitTemplate(titleKey: "template.journal", icon: "📝", colorHex: "#E67E22", category: .mindfulness, exampleKey: "template.journalExample"),
        HabitTemplate(titleKey: "template.smile", icon: "😊", colorHex: "#FFD93D", category: .mindfulness, exampleKey: "template.smileExample"),
        HabitTemplate(titleKey: "template.affirmation", icon: "💭", colorHex: "#6BCF7F", category: .mindfulness, exampleKey: "template.affirmationExample"),

        // Productivity
        HabitTemplate(titleKey: "template.makeBed", icon: "🛏️", colorHex: "#5DADE2", category: .productivity, exampleKey: "template.makeBedExample"),
        HabitTemplate(titleKey: "template.planDay", icon: "📅", colorHex: "#48C9B0", category: .productivity, exampleKey: "template.planDayExample"),
        HabitTemplate(titleKey: "template.cleanDesk", icon: "🗂️", colorHex: "#85C1E2", category: .productivity, exampleKey: "template.cleanDeskExample"),
        HabitTemplate(titleKey: "template.reviewGoals", icon: "🎯", colorHex: "#F8B500", category: .productivity, exampleKey: "template.reviewGoalsExample"),
        HabitTemplate(titleKey: "template.noPhone", icon: "📵", colorHex: "#E74C3C", category: .productivity, exampleKey: "template.noPhoneExample"),

        // Learning
        HabitTemplate(titleKey: "template.read", icon: "📚", colorHex: "#3498DB", category: .learning, exampleKey: "template.readExample"),
        HabitTemplate(titleKey: "template.learnLanguage", icon: "🗣️", colorHex: "#1ABC9C", category: .learning, exampleKey: "template.learnLanguageExample"),
        HabitTemplate(titleKey: "template.podcast", icon: "🎧", colorHex: "#9B59B6", category: .learning, exampleKey: "template.podcastExample"),
        HabitTemplate(titleKey: "template.practiceSkill", icon: "🎸", colorHex: "#E67E22", category: .learning, exampleKey: "template.practiceSkillExample"),
        HabitTemplate(titleKey: "template.watchTutorial", icon: "🎥", colorHex: "#C0392B", category: .learning, exampleKey: "template.watchTutorialExample"),

        // Social
        HabitTemplate(titleKey: "template.textFriend", icon: "💬", colorHex: "#3498DB", category: .social, exampleKey: "template.textFriendExample"),
        HabitTemplate(titleKey: "template.callFamily", icon: "📞", colorHex: "#E74C3C", category: .social, exampleKey: "template.callFamilyExample"),
        HabitTemplate(titleKey: "template.compliment", icon: "💝", colorHex: "#EC407A", category: .social, exampleKey: "template.complimentExample"),
        HabitTemplate(titleKey: "template.socialMediaBreak", icon: "🚫", colorHex: "#95A5A6", category: .social, exampleKey: "template.socialMediaBreakExample"),

        // Creative
        HabitTemplate(titleKey: "template.draw", icon: "🎨", colorHex: "#9B59B6", category: .creative, exampleKey: "template.drawExample"),
        HabitTemplate(titleKey: "template.write", icon: "✍️", colorHex: "#34495E", category: .creative, exampleKey: "template.writeExample"),
        HabitTemplate(titleKey: "template.takePhoto", icon: "📸", colorHex: "#16A085", category: .creative, exampleKey: "template.takePhotoExample"),
        HabitTemplate(titleKey: "template.music", icon: "🎵", colorHex: "#8E44AD", category: .creative, exampleKey: "template.musicExample"),
        HabitTemplate(titleKey: "template.dance", icon: "💃", colorHex: "#E91E63", category: .creative, exampleKey: "template.danceExample"),
    ]

    static func templates(for category: TemplateCategory) -> [HabitTemplate] {
        templates.filter { $0.category == category }
    }
}
