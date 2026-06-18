import Foundation
import Combine

final class MorsePathLearnSignalsProgressService: ObservableObject {
    static let MorsePathLearnSignalsShared = MorsePathLearnSignalsProgressService()

    @Published private(set) var MorsePathLearnSignalsLearnedSymbols: Set<String>
    @Published private(set) var MorsePathLearnSignalsPracticeAttempts: Int
    @Published private(set) var MorsePathLearnSignalsCorrectAttempts: Int
    @Published private(set) var MorsePathLearnSignalsMistakes: Int
    @Published private(set) var MorsePathLearnSignalsBestStreak: Int
    @Published private(set) var MorsePathLearnSignalsCurrentStreak: Int

    private let MorsePathLearnSignalsDefaults: UserDefaults

    private enum MorsePathLearnSignalsKey {
        static let MorsePathLearnSignalsLearnedSymbols = "MorsePathLearnSignals.learnedSymbols"
        static let MorsePathLearnSignalsPracticeAttempts = "MorsePathLearnSignals.practiceAttempts"
        static let MorsePathLearnSignalsCorrectAttempts = "MorsePathLearnSignals.correctAttempts"
        static let MorsePathLearnSignalsMistakes = "MorsePathLearnSignals.mistakes"
        static let MorsePathLearnSignalsBestStreak = "MorsePathLearnSignals.bestStreak"
        static let MorsePathLearnSignalsCurrentStreak = "MorsePathLearnSignals.currentStreak"
    }

    init(MorsePathLearnSignalsDefaults: UserDefaults = .standard) {
        self.MorsePathLearnSignalsDefaults = MorsePathLearnSignalsDefaults
        MorsePathLearnSignalsLearnedSymbols = Set(
            MorsePathLearnSignalsDefaults.stringArray(
                forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsLearnedSymbols
            ) ?? []
        )
        MorsePathLearnSignalsPracticeAttempts = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsPracticeAttempts
        )
        MorsePathLearnSignalsCorrectAttempts = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCorrectAttempts
        )
        MorsePathLearnSignalsMistakes = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsMistakes
        )
        MorsePathLearnSignalsBestStreak = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsBestStreak
        )
        MorsePathLearnSignalsCurrentStreak = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCurrentStreak
        )
    }

    func MorsePathLearnSignalsSaveLearnedSymbol(_ MorsePathLearnSignalsSymbol: String) {
        MorsePathLearnSignalsLearnedSymbols.insert(MorsePathLearnSignalsSymbol)
        MorsePathLearnSignalsDefaults.set(
            Array(MorsePathLearnSignalsLearnedSymbols),
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsLearnedSymbols
        )
    }

    func MorsePathLearnSignalsSaveAttempt(MorsePathLearnSignalsIsCorrect: Bool) {
        MorsePathLearnSignalsPracticeAttempts += 1
        if MorsePathLearnSignalsIsCorrect {
            MorsePathLearnSignalsCorrectAttempts += 1
            MorsePathLearnSignalsCurrentStreak += 1
            MorsePathLearnSignalsBestStreak = max(
                MorsePathLearnSignalsBestStreak,
                MorsePathLearnSignalsCurrentStreak
            )
        } else {
            MorsePathLearnSignalsMistakes += 1
            MorsePathLearnSignalsCurrentStreak = 0
        }
        MorsePathLearnSignalsPersistStatistics()
    }

    func MorsePathLearnSignalsResetProgress() {
        MorsePathLearnSignalsLearnedSymbols = []
        MorsePathLearnSignalsPracticeAttempts = 0
        MorsePathLearnSignalsCorrectAttempts = 0
        MorsePathLearnSignalsMistakes = 0
        MorsePathLearnSignalsBestStreak = 0
        MorsePathLearnSignalsCurrentStreak = 0

        [
            MorsePathLearnSignalsKey.MorsePathLearnSignalsLearnedSymbols,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsPracticeAttempts,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsCorrectAttempts,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsMistakes,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsBestStreak,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsCurrentStreak
        ].forEach(MorsePathLearnSignalsDefaults.removeObject)
    }

    private func MorsePathLearnSignalsPersistStatistics() {
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsPracticeAttempts,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsPracticeAttempts
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsCorrectAttempts,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCorrectAttempts
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsMistakes,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsMistakes
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsBestStreak,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsBestStreak
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsCurrentStreak,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCurrentStreak
        )
    }
}
