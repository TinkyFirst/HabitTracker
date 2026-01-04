import Foundation

// Motivational messages for notifications only
struct MotivationalMessages {
    // English messages for notifications
    static let notificationMessages = [
        "Time to build your habit! 💪",
        "You've got this! Keep going! 🌟",
        "Small steps lead to big changes! 🚀",
        "Your future self will thank you! ⭐",
        "Consistency is key! Let's do this! 🔥",
        "Make today count! 🎯",
        "You're stronger than you think! 💎",
        "Every day is a fresh start! 🌅",
        "Progress over perfection! 📈",
        "Stay committed to your goals! 🏆",
        "Believe in yourself! ✨",
        "One step closer to success! 🌈",
        "Keep the momentum going! ⚡",
        "You're doing amazing! 🎊",
        "Stay focused, stay strong! 🧠",
        "Make it happen today! 🎪",
        "Your habits shape your future! 🌱",
        "Embrace the journey! 🦄",
        "Success is built daily! 🏗️",
        "You're on the right path! 🛤️"
    ]
    
    static var randomNotificationMessage: String {
        notificationMessages.randomElement() ?? notificationMessages[0]
    }
}
