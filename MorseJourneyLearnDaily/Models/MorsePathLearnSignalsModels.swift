import Foundation
import AVFoundation

enum MorsePathLearnSignalsLearnCategory: String, CaseIterable, Identifiable {
    case letters = "Letters"
    case numbers = "Numbers"
    case symbols = "Symbols"

    var id: String { rawValue }
}

enum MorsePathLearnSignalsSignalSpeed: String, CaseIterable, Identifiable {
    case slow = "Slow"
    case medium = "Medium"
    case fast = "Fast"

    var id: String { rawValue }

    var MorsePathLearnSignalsUnitDuration: TimeInterval {
        switch self {
        case .slow: return 0.28
        case .medium: return 0.16
        case .fast: return 0.09
        }
    }
}

enum MorsePathLearnSignalsTranslationMode: String, CaseIterable, Identifiable {
    case textToMorse = "Text to Morse"
    case morseToText = "Morse to Text"

    var id: String { rawValue }
}

enum MorsePathLearnSignalsCameraAuthorizationState {
    case notDetermined
    case authorized
    case denied
    case restricted

    init(MorsePathLearnSignalsStatus: AVAuthorizationStatus) {
        switch MorsePathLearnSignalsStatus {
        case .notDetermined:
            self = .notDetermined
        case .authorized:
            self = .authorized
        case .denied:
            self = .denied
        case .restricted:
            self = .restricted
        @unknown default:
            self = .denied
        }
    }
}

enum MorsePathLearnSignalsSignalAlert: String, Identifiable {
    case emptyMessage
    case noOutput
    case flashlightExplanation
    case cameraDenied
    case flashlightUnavailable

    var id: String { rawValue }
}

struct MorsePathLearnSignalsMorseItem: Identifiable, Hashable {
    let MorsePathLearnSignalsSymbol: String
    let MorsePathLearnSignalsCode: String

    var id: String { MorsePathLearnSignalsSymbol }

    var MorsePathLearnSignalsSpokenCode: String {
        MorsePathLearnSignalsCode
            .map { $0 == "." ? "Dot" : "Dash" }
            .joined(separator: " ")
    }
}

struct MorsePathLearnSignalsMorseDictionary {
    static let MorsePathLearnSignalsLetters: [String: String] = [
        "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
        "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
        "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
        "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
        "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
        "Z": "--.."
    ]

    static let MorsePathLearnSignalsNumbers: [String: String] = [
        "0": "-----", "1": ".----", "2": "..---", "3": "...--", "4": "....-",
        "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----."
    ]

    static let MorsePathLearnSignalsSymbols: [String: String] = [
        ".": ".-.-.-", ",": "--..--", "?": "..--..", "!": "-.-.--",
        "/": "-..-.", "-": "-....-", "(": "-.--.", ")": "-.--.-"
    ]

    static let MorsePathLearnSignalsAll: [String: String] =
        MorsePathLearnSignalsLetters
        .merging(MorsePathLearnSignalsNumbers) { MorsePathLearnSignalsCurrent, _ in MorsePathLearnSignalsCurrent }
        .merging(MorsePathLearnSignalsSymbols) { MorsePathLearnSignalsCurrent, _ in MorsePathLearnSignalsCurrent }

    static func MorsePathLearnSignalsItems(
        for MorsePathLearnSignalsCategory: MorsePathLearnSignalsLearnCategory
    ) -> [MorsePathLearnSignalsMorseItem] {
        let MorsePathLearnSignalsSource: [String: String]
        switch MorsePathLearnSignalsCategory {
        case .letters:
            MorsePathLearnSignalsSource = MorsePathLearnSignalsLetters
        case .numbers:
            MorsePathLearnSignalsSource = MorsePathLearnSignalsNumbers
        case .symbols:
            MorsePathLearnSignalsSource = MorsePathLearnSignalsSymbols
        }

        return MorsePathLearnSignalsSource
            .map {
                MorsePathLearnSignalsMorseItem(
                    MorsePathLearnSignalsSymbol: $0.key,
                    MorsePathLearnSignalsCode: $0.value
                )
            }
            .sorted { $0.MorsePathLearnSignalsSymbol < $1.MorsePathLearnSignalsSymbol }
    }
}
