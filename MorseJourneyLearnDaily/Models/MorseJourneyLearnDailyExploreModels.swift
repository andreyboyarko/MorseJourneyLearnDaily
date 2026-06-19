import Foundation

enum MorseJourneyLearnDailyExploreCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case history = "History"
    case signals = "Signals"
    case myths = "Myths"
    case learning = "Learning"

    var id: String { rawValue }

    var MorseJourneyLearnDailyIcon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .history: return "clock.fill"
        case .signals: return "dot.radiowaves.left.and.right"
        case .myths: return "questionmark.bubble.fill"
        case .learning: return "brain.head.profile"
        }
    }
}

struct MorseJourneyLearnDailyExploreQuestion: Identifiable, Equatable {
    let id: UUID
    let statement: String
    let isTrue: Bool
    let explanation: String
    let category: MorseJourneyLearnDailyExploreCategory

    init(
        id: UUID = UUID(),
        statement: String,
        isTrue: Bool,
        explanation: String,
        category: MorseJourneyLearnDailyExploreCategory
    ) {
        self.id = id
        self.statement = statement
        self.isTrue = isTrue
        self.explanation = explanation
        self.category = category
    }
}

enum MorseJourneyLearnDailyExploreQuestionStore {
    static let MorseJourneyLearnDailyQuestions: [MorseJourneyLearnDailyExploreQuestion] = [
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can be sent with sound, light, or electrical pulses.",
            isTrue: true,
            explanation: "It is based on short and long signals, not on one specific device.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A dot is shorter than a dash.",
            isTrue: true,
            explanation: "A dash lasts about three times longer than a dot.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "SOS in Morse code is … — …",
            isTrue: true,
            explanation: "It is easy to recognize because of its simple rhythm.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "SOS does not officially mean “Save Our Ship”.",
            isTrue: true,
            explanation: "That phrase appeared later as a popular interpretation.",
            category: .myths
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code was used in telegraphy before voice radio became common.",
            isTrue: true,
            explanation: "It was one of the key systems for early long-distance communication.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Samuel Morse and Alfred Vail are both connected with the creation of Morse code.",
            isTrue: true,
            explanation: "Morse led the telegraph project, and Vail helped develop the practical code.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "International Morse Code is not exactly the same as the original American Morse code.",
            isTrue: true,
            explanation: "International Morse became simpler and more standardized.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The letter E is a single dot.",
            isTrue: true,
            explanation: "E is one of the shortest symbols in Morse.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The letter T is a single dash.",
            isTrue: true,
            explanation: "T is also one of the shortest symbols.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Numbers also have Morse code symbols.",
            isTrue: true,
            explanation: "0–9 are included in International Morse Code.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A space between words in Morse is longer than a space between letters.",
            isTrue: true,
            explanation: "Timing matters as much as dots and dashes.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can be transmitted with a flashlight.",
            isTrue: true,
            explanation: "Light can replace sound or electrical pulses.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Pilots can use Morse identifiers for some radio navigation aids.",
            isTrue: true,
            explanation: "Some navigation stations transmit identifying letters in Morse.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code is still popular among amateur radio operators.",
            isTrue: true,
            explanation: "Many radio enthusiasts still use CW/Morse communication.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The Titanic used wireless distress messages in Morse code.",
            isTrue: true,
            explanation: "Titanic operators sent distress calls by wireless telegraphy.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "CQD was used as an early distress signal before SOS became standard.",
            isTrue: true,
            explanation: "CQD existed before SOS was widely adopted.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Learning Morse by sound can be more effective than memorizing dots and dashes visually.",
            isTrue: true,
            explanation: "Many learners recognize rhythm faster than written symbols.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can be written using dots and dashes.",
            isTrue: true,
            explanation: "That is the common visual representation.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A dash is often called “dah”.",
            isTrue: true,
            explanation: "Operators use “dit” and “dah” to imitate the sound.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A dot is often called “dit”.",
            isTrue: true,
            explanation: "“Dit” reflects the short sound of a dot.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can work without the internet.",
            isTrue: true,
            explanation: "It only needs a way to send short and long signals.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse messages can be sent by tapping.",
            isTrue: true,
            explanation: "Short taps and long taps can represent dots and dashes.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The first famous telegraph message sent by Morse was “What hath God wrought”.",
            isTrue: true,
            explanation: "It was sent in 1844.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code was once important for maritime distress communication.",
            isTrue: true,
            explanation: "Ships used it for emergency communication for many years.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Modern maritime distress systems replaced Morse for official ship distress use.",
            isTrue: true,
            explanation: "GMDSS replaced Morse-based distress watch in 1999.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can be used even when speech is impossible.",
            isTrue: true,
            explanation: "A person can signal with light, tapping, or sound.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The same Morse message can be transmitted in different ways.",
            isTrue: true,
            explanation: "Sound, light, radio, or vibration can carry the same pattern.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code uses timing, not just symbols.",
            isTrue: true,
            explanation: "Pauses between elements, letters, and words are part of the code.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A single Morse character can contain several dots and dashes.",
            isTrue: true,
            explanation: "For example, Q is --.-",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code is useful for learning patterns and rhythm.",
            isTrue: true,
            explanation: "It trains recognition of short and long signal sequences.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "SOS means “Save Our Ship”.",
            isTrue: false,
            explanation: "It is a myth; SOS was chosen for its simple Morse pattern.",
            category: .myths
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A dot and a dash have the same duration.",
            isTrue: false,
            explanation: "A dash is longer than a dot.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can only be sent by radio.",
            isTrue: false,
            explanation: "It can be sent by sound, light, tapping, or electrical signals.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code has no numbers.",
            isTrue: false,
            explanation: "Numbers 0–9 have Morse symbols.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The letter E is a dash.",
            isTrue: false,
            explanation: "E is a single dot.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The letter T is a dot.",
            isTrue: false,
            explanation: "T is a single dash.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "International Morse Code and original American Morse Code are exactly the same.",
            isTrue: false,
            explanation: "They are different systems.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code was invented for smartphones.",
            isTrue: false,
            explanation: "It was created for telegraph communication in the 19th century.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "You need the internet to use Morse code.",
            isTrue: false,
            explanation: "Morse works offline.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A flashlight cannot transmit Morse code.",
            isTrue: false,
            explanation: "Light signals can represent dots and dashes.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "SOS was created because it looks like a real word.",
            isTrue: false,
            explanation: "It was chosen because the signal pattern is simple and recognizable.",
            category: .myths
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code is only for emergencies.",
            isTrue: false,
            explanation: "It has been used for telegraphy, radio, training, hobbies, and navigation IDs.",
            category: .myths
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code does not use pauses.",
            isTrue: false,
            explanation: "Pauses separate signal parts, letters, and words.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Every Morse letter has exactly three symbols.",
            isTrue: false,
            explanation: "Some have one symbol, others have several.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code cannot be learned by listening.",
            isTrue: false,
            explanation: "Audio learning is actually very common.",
            category: .learning
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "The Titanic sent only voice radio calls.",
            isTrue: false,
            explanation: "It used wireless telegraphy/Morse distress messages.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "CQD became the final universal distress signal after SOS.",
            isTrue: false,
            explanation: "SOS became the more recognized international distress signal.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code disappeared completely after 1999.",
            isTrue: false,
            explanation: "It lost its official maritime distress role but is still used by enthusiasts and some systems.",
            category: .history
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "A long press should represent a dot.",
            isTrue: false,
            explanation: "Usually short press = dot, long press = dash.",
            category: .signals
        ),
        MorseJourneyLearnDailyExploreQuestion(
            statement: "Morse code can only represent English letters and nothing else.",
            isTrue: false,
            explanation: "It includes numbers and some punctuation too.",
            category: .signals
        )
    ]
}
