import Foundation

enum AchievementLocalizedStrings {
    static func value(for key: String, language: String) -> String? {
        if language == "uk" {
            return ukrainian[key] ?? english[key]
        }

        return english[key]
    }

    private static let english = parse(
        #"""
"achievement.category.streaks" = "Streaks";
"achievement.category.completions" = "Completions";
"achievement.category.habits" = "Habits";
"achievement.category.consistency" = "Consistency";
"achievement.category.milestones" = "Milestones";
"achievement.category.special" = "Special";
"achievement.category.all" = "All";
"achievement.unlocked" = "ACHIEVEMENT UNLOCKED!";
"achievements.title" = "Achievements";
"achievements.viewAll" = "View All";
"achievements.keepGoing" = "Keep going to unlock your first achievement";
"achievements.of" = "of";
"achievements.common" = "Common";
"achievements.rare" = "Rare";
"achievements.legendary" = "Legendary";
"achievements.unlocked_on" = "Unlocked on";
"achievements.progress" = "Progress";
"achievements.category" = "Category";
"achievements.rarity" = "Rarity";
"achievements.requirement" = "Requirement";
"achievements.done" = "Done";
"achievements.tap_to_close" = "Tap anywhere to close";
"achievements.rarity.common" = "Common";
"achievements.rarity.uncommon" = "Uncommon";
"achievements.rarity.rare" = "Rare";
"achievements.rarity.epic" = "Epic";
"achievements.rarity.legendary" = "Legendary";
"achievement.first_habit.title" = "Baby Steps";
"achievement.first_habit.description" = "Created your first habit! Every journey starts with a single step! 🥞";
"achievement.first_checkin.title" = "Getting Started!";
"achievement.first_checkin.description" = "First check-in complete! You're officially on the path! ✨";
"achievement.three_habits.title" = "Three's Company";
"achievement.three_habits.description" = "Three habits strong! Like a three-legged stool — stable and reliable! 🪑";
"achievement.five_habits.title" = "High Five!";
"achievement.five_habits.description" = "5 habits! You're juggling them like a pro! ✋";
"achievement.ten_habits.title" = "Perfect Ten";
"achievement.ten_habits.description" = "10 habits! You're a habit-forming machine! 🎯";
"achievement.streak_3.title" = "On Fire!";
"achievement.streak_3.description" = "3 days in a row! The flame is lit 🔥";
"achievement.streak_7.title" = "Week Warrior!";
"achievement.streak_7.description" = "7 days strong! A full week of excellence! 💪";
"achievement.streak_14.title" = "Two-Week Wonder";
"achievement.streak_14.description" = "14 days! Two weeks of pure dedication! ☀️";
"achievement.streak_21.title" = "Habit Formed";
"achievement.streak_21.description" = "21 days! They say this is when habits stick. You did it! 📜";
"achievement.streak_30.title" = "Monthly Master";
"achievement.streak_30.description" = "A whole month! Consistency is your middle name! 💰";
"achievement.streak_50.title" = "Half Century!";
"achievement.streak_50.description" = "50 days! That's a golden anniversary of habits! 🎊";
"achievement.streak_100.title" = "Century Mark!";
"achievement.streak_100.description" = "100 days straight! You're unstoppable! 💯";
"achievement.streak_200.title" = "Double Century";
"achievement.streak_200.description" = "200 days! This isn't just a streak, it's a lifestyle! 🚀";
"achievement.streak_365.title" = "Year-Long Legend!";
"achievement.streak_365.description" = "365 days without missing! You're a calendar year champion! 🎆";
"achievement.streak_500.title" = "Half Millennium";
"achievement.streak_500.description" = "500 days! You're now a legend in the making! 👑";
"achievement.checkins_10.title" = "Perfect Ten";
"achievement.checkins_10.description" = "10 check-ins! Like getting your first gold star! ✏️";
"achievement.checkins_25.title" = "Quarter Century";
"achievement.checkins_25.description" = "25 times! The coins are adding up! 🪙";
"achievement.checkins_50.title" = "Half Hundred";
"achievement.checkins_50.description" = "50 check-ins! Time to celebrate! 🎉";
"achievement.checkins_100.title" = "Century Club!";
"achievement.checkins_100.description" = "100 completions! This is professional level! 💼";
"achievement.checkins_250.title" = "Quarter Thousand";
"achievement.checkins_250.description" = "250 times! That's dedication! 🎬";
"achievement.checkins_500.title" = "Five Hundred!";
"achievement.checkins_500.description" = "500 check-ins! You're counting victories! 💵";
"achievement.checkins_1000.title" = "One Thousand!";
"achievement.checkins_1000.description" = "1000 completions! Like \"One Thousand and One Nights\"! 🌙✨";
"achievement.checkins_2000.title" = "Two Thousand!";
"achievement.checkins_2000.description" = "2000 times! That sounds epic! 🗓️";
"achievement.checkins_5000.title" = "Five Thousand!";
"achievement.checkins_5000.description" = "5000 check-ins! You're a superstar! 🎤⭐";
"achievement.checkins_10000.title" = "Ten Thousand!";
"achievement.checkins_10000.description" = "10,000 times! You're a master! ⚔️";
"achievement.perfect_week.title" = "Perfect Week";
"achievement.perfect_week.description" = "All habits for 7 days! Like a perfect Sunday roast! 🥓";
"achievement.perfect_month.title" = "Flawless Month";
"achievement.perfect_month.description" = "30 days without missing! Payday never felt so good! 💰";
"achievement.early_bird.title" = "Early Bird";
"achievement.early_bird.description" = "7 check-ins before 8 AM! The early bird gets the worm! 🌅🐦";
"achievement.night_owl.title" = "Night Owl";
"achievement.night_owl.description" = "7 check-ins after 10 PM! Burning the midnight oil! 🌙🦉";
"achievement.weekend_warrior.title" = "Weekend Warrior";
"achievement.weekend_warrior.description" = "10 perfect weekends! You don't take days off! 🏕️";
"achievement.all_habits_day.title" = "Victory Day";
"achievement.all_habits_day.description" = "All habits in one day! Like hosting a perfect party! 🎄";
"achievement.comeback_kid.title" = "Comeback Kid!";
"achievement.comeback_kid.description" = "Rebuilt your streak after a break! Stronger than ever! ⚽💪";
"achievement.no_skip_month.title" = "No Days Off";
"achievement.no_skip_month.description" = "30 days every single day! You're a machine! 🚜";
"achievement.goal_crusher.title" = "Goal Crusher";
"achievement.goal_crusher.description" = "10 goals achieved! Following the recipe to success! 🥣";
"achievement.overachiever.title" = "Overachiever";
"achievement.overachiever.description" = "Exceeded goals 50 times! You're an A+ student! 📚🅰️";
"achievement.one_week.title" = "First Week";
"achievement.one_week.description" = "7 days with the app! Welcome aboard! 📅";
"achievement.one_month.title" = "One Month Strong";
"achievement.one_month.description" = "30 days! You passed the trial period! ✅";
"achievement.three_months.title" = "Quarterly Champion";
"achievement.three_months.description" = "3 months! That's a whole season! 🍂";
"achievement.six_months.title" = "Half Year Hero!";
"achievement.six_months.description" = "Half a year together! Halfway to greatness! 🎄";
"achievement.one_year.title" = "Year Anniversary!";
"achievement.one_year.description" = "A whole year! Time to celebrate big! 💒🎊";
"achievement.two_years.title" = "Two Years!";
"achievement.two_years.description" = "Two years! You're a toddler in habit years! 👶💬";
"achievement.habit_master.title" = "Habit Master";
"achievement.habit_master.description" = "100 days in a row! You're a craftsman! 🏺";
"achievement.dedication.title" = "True Dedication";
"achievement.dedication.description" = "3+ habits for 90 days! That's commitment! 🎖️";
"achievement.resilient.title" = "Unbreakable";
"achievement.resilient.description" = "Rebuilt streaks 5 times! You never give up! ⚔️🛡️";
"achievement.legendary_status.title" = "Legendary Status";
"achievement.legendary_status.description" = "40 achievements! You're a legend! 👑📖";
"achievement.new_year_new_me.title" = "New Year, New Me!";
"achievement.new_year_new_me.description" = "Started on January 1st! Resolution champion! 🎆🥂";
"achievement.birthday_celebration.title" = "Happy Anniversary!";
"achievement.birthday_celebration.description" = "Completed a habit on your app's anniversary! 🎂🕯️";
"achievement.leap_day.title" = "Leap Day Legend";
"achievement.leap_day.description" = "Completed on Feb 29! Rarer than a unicorn! 🦄";
"achievement.midnight_warrior.title" = "Midnight Warrior";
"achievement.midnight_warrior.description" = "Completed at 00:00! Like Cinderella but better! 🕐👸";
"achievement.multitasker.title" = "Multitasker";
"achievement.multitasker.description" = "5+ habits in one day! You're juggling like a pro! 👩‍🍳";
"achievement.speed_demon.title" = "Speed Demon";
"achievement.speed_demon.description" = "10 check-ins in an hour! Faster than lightning! 🚐💨";
"achievement.social_butterfly.title" = "Social Butterfly";
"achievement.social_butterfly.description" = "7+ habits at once! You're a habit butterfly! 🦋✨";
"achievement.collector.title" = "Collector";
"achievement.collector.description" = "25 achievements! Building a beautiful collection! 📬🎖️";
"achievement.perfectionist.title" = "Perfectionist";
"achievement.perfectionist.description" = "30 days at 100%! Everything in its place! ✨🧹";
"achievement.unlock_all.title" = "Collection Complete!";
"achievement.unlock_all.description" = "All 49 achievements! You're the champion! 🏆🥇";
"""#
    )

    private static let ukrainian = parse(
        #"""
"achievements.title" = "Досягнення";
"achievements.viewAll" = "Дивитись всі";
"achievements.keepGoing" = "Продовжуйте, щоб відкрити перше досягнення";
"achievements.unlocked" = "Розблоковано!";
"achievements.of" = "з";
"achievements.done" = "Готово";
"achievements.tap_to_close" = "Натисніть щоб закрити";
"achievements.progress" = "Прогрес";
"achievements.unlocked_on" = "Розблоковано";
"achievements.category" = "Категорія";
"achievements.rarity" = "Рідкість";
"achievements.requirement" = "Вимога";
"achievement.unlocked" = "Досягнення Розблоковано";
"achievement.category.all" = "Всі";
"achievement.category.streaks" = "Серії";
"achievement.category.completions" = "Виконання";
"achievement.category.habits" = "Звички";
"achievement.category.consistency" = "Постійність";
"achievement.category.milestones" = "Віхи";
"achievement.category.special" = "Спеціальні";
"achievements.common" = "Звичайні";
"achievements.rare" = "Рідкісні";
"achievements.legendary" = "Легендарні";
"achievements.rarity.common" = "Звичайне";
"achievements.rarity.uncommon" = "Незвичайне";
"achievements.rarity.rare" = "Рідкісне";
"achievements.rarity.epic" = "Епічне";
"achievements.rarity.legendary" = "Легендарне";
"achievement.first_habit.title" = "Перша Звичка";
"achievement.first_habit.description" = "Створіть свою першу звичку";
"achievement.first_checkin.title" = "Перший Крок";
"achievement.first_checkin.description" = "Виконайте звичку вперше";
"achievement.three_habits.title" = "Три Звички";
"achievement.three_habits.description" = "Створіть 3 звички";
"achievement.five_habits.title" = "П'ять Звичок";
"achievement.five_habits.description" = "Створіть 5 звичок";
"achievement.ten_habits.title" = "Десять Звичок";
"achievement.ten_habits.description" = "Створіть 10 звичок";
"achievement.streak_3.title" = "🔥 3 Дні Підряд";
"achievement.streak_3.description" = "Підтримуйте серію 3 дні";
"achievement.streak_7.title" = "🔥 Тиждень Вогню";
"achievement.streak_7.description" = "Підтримуйте серію 7 днів";
"achievement.streak_14.title" = "🔥 Два Тижні";
"achievement.streak_14.description" = "Підтримуйте серію 14 днів";
"achievement.streak_21.title" = "🔥 Три Тижні";
"achievement.streak_21.description" = "Підтримуйте серію 21 день";
"achievement.streak_30.title" = "🔥 Місяць Сили";
"achievement.streak_30.description" = "Підтримуйте серію 30 днів";
"achievement.streak_50.title" = "🔥 П'ятдесят Днів";
"achievement.streak_50.description" = "Підтримуйте серію 50 днів";
"achievement.streak_100.title" = "🔥 Сотня";
"achievement.streak_100.description" = "Підтримуйте серію 100 днів";
"achievement.streak_200.title" = "✨ Двісті Днів";
"achievement.streak_200.description" = "Підтримуйте серію 200 днів";
"achievement.streak_365.title" = "👑 Рік Досконалості";
"achievement.streak_365.description" = "Підтримуйте серію цілий рік";
"achievement.streak_500.title" = "👑 П'ятсот Днів";
"achievement.streak_500.description" = "Підтримуйте серію 500 днів";
"achievement.checkins_10.title" = "Десять Разів";
"achievement.checkins_10.description" = "Виконайте 10 відміток";
"achievement.checkins_25.title" = "Двадцять П'ять";
"achievement.checkins_25.description" = "Виконайте 25 відміток";
"achievement.checkins_50.title" = "П'ятдесят";
"achievement.checkins_50.description" = "Виконайте 50 відміток";
"achievement.checkins_100.title" = "Сотня Виконань";
"achievement.checkins_100.description" = "Виконайте 100 відміток";
"achievement.checkins_250.title" = "Двісті П'ятдесят";
"achievement.checkins_250.description" = "Виконайте 250 відміток";
"achievement.checkins_500.title" = "П'ятсот Виконань";
"achievement.checkins_500.description" = "Виконайте 500 відміток";
"achievement.checkins_1000.title" = "Тисяча";
"achievement.checkins_1000.description" = "Виконайте 1000 відміток";
"achievement.checkins_2000.title" = "Дві Тисячі";
"achievement.checkins_2000.description" = "Виконайте 2000 відміток";
"achievement.checkins_5000.title" = "П'ять Тисяч";
"achievement.checkins_5000.description" = "Виконайте 5000 відміток";
"achievement.checkins_10000.title" = "Десять Тисяч";
"achievement.checkins_10000.description" = "Виконайте 10000 відміток";
"achievement.perfect_week.title" = "Ідеальний Тиждень";
"achievement.perfect_week.description" = "Виконайте всі звички 7 днів підряд";
"achievement.perfect_month.title" = "Ідеальний Місяць";
"achievement.perfect_month.description" = "Виконайте всі звички 30 днів підряд";
"achievement.early_bird.title" = "Рання Пташка";
"achievement.early_bird.description" = "7 відміток до 8 ранку";
"achievement.night_owl.title" = "Нічна Сова";
"achievement.night_owl.description" = "7 відміток після 10 вечора";
"achievement.weekend_warrior.title" = "Воїн Вихідних";
"achievement.weekend_warrior.description" = "10 ідеальних вихідних";
"achievement.all_habits_day.title" = "Всі Звички За День";
"achievement.all_habits_day.description" = "Виконайте всі звички в один день";
"achievement.comeback_kid.title" = "Повернення";
"achievement.comeback_kid.description" = "Відновіть серію після перерви";
"achievement.no_skip_month.title" = "Без Пропусків";
"achievement.no_skip_month.description" = "Щонайменше одна відмітка кожен день протягом місяця";
"achievement.goal_crusher.title" = "Руйнівник Цілей";
"achievement.goal_crusher.description" = "Досягніть 10 цілей";
"achievement.overachiever.title" = "Надвиконавець";
"achievement.overachiever.description" = "Перевищте цілі на 150% - 50 разів";
"achievement.one_week.title" = "Перший Тиждень";
"achievement.one_week.description" = "Використовуйте додаток 7 днів";
"achievement.one_month.title" = "Перший Місяць";
"achievement.one_month.description" = "Використовуйте додаток 30 днів";
"achievement.three_months.title" = "Три Місяці";
"achievement.three_months.description" = "Використовуйте додаток 90 днів";
"achievement.six_months.title" = "Півроку";
"achievement.six_months.description" = "Використовуйте додаток 180 днів";
"achievement.one_year.title" = "Один Рік";
"achievement.one_year.description" = "Використовуйте додаток цілий рік";
"achievement.two_years.title" = "Два Роки";
"achievement.two_years.description" = "Використовуйте додаток 2 роки";
"achievement.habit_master.title" = "Майстер Звичок";
"achievement.habit_master.description" = "Серія 100 днів для однієї звички";
"achievement.dedication.title" = "Відданість";
"achievement.dedication.description" = "Підтримуйте 3+ звички протягом 90 днів";
"achievement.resilient.title" = "Стійкість";
"achievement.resilient.description" = "Відновіть серію 5 разів";
"achievement.legendary_status.title" = "Легендарний Статус";
"achievement.legendary_status.description" = "Розблокуйте 40 інших досягнень";
"achievement.new_year_new_me.title" = "Новий Рік, Нове Я";
"achievement.new_year_new_me.description" = "Створіть звичку 1 січня";
"achievement.birthday_celebration.title" = "З Річницею!";
"achievement.birthday_celebration.description" = "Виконайте звичку в річницю додатку";
"achievement.leap_day.title" = "Високосний День";
"achievement.leap_day.description" = "Виконайте звичку 29 лютого";
"achievement.midnight_warrior.title" = "Опівнічний Воїн";
"achievement.midnight_warrior.description" = "Виконайте звичку о півночі";
"achievement.multitasker.title" = "Багатозадачність";
"achievement.multitasker.description" = "5+ звичок за один день";
"achievement.speed_demon.title" = "Швидкісний Демон";
"achievement.speed_demon.description" = "10 відміток за годину";
"achievement.social_butterfly.title" = "Соціальний Метелик";
"achievement.social_butterfly.description" = "7+ звичок одночасно";
"achievement.collector.title" = "Колекціонер";
"achievement.collector.description" = "Розблокуйте 25 досягнень";
"achievement.perfectionist.title" = "Перфекціоніст";
"achievement.perfectionist.description" = "100% виконання протягом 30 днів";
"achievement.unlock_all.title" = "Абсолютна Перемога";
"achievement.unlock_all.description" = "Розблокуйте всі інші досягнення";
"""#
    )

    private static func parse(_ raw: String) -> [String: String] {
        var result: [String: String] = [:]

        for line in raw.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.hasPrefix("\""),
                  trimmed.hasSuffix("\";"),
                  let separator = trimmed.range(of: "\" = \"") else {
                continue
            }

            let keyStart = trimmed.index(after: trimmed.startIndex)
            let key = String(trimmed[keyStart..<separator.lowerBound])
            let valueEnd = trimmed.index(trimmed.endIndex, offsetBy: -2)
            let value = String(trimmed[separator.upperBound..<valueEnd])
                .replacingOccurrences(of: "\\\"", with: "\"")

            result[key] = value
        }

        return result
    }
}
