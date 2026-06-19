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
    @Published private(set) var MorsePathLearnSignalsQuizMistakesBySymbol: [String: Int]
    @Published private(set) var MorsePathLearnSignalsQuizBestScores: [String: Int]
    @Published private(set) var MorsePathLearnSignalsCompletedQuizSessions: Int

    private let MorsePathLearnSignalsDefaults: UserDefaults

    private enum MorsePathLearnSignalsKey {
        static let MorsePathLearnSignalsLearnedSymbols = "MorsePathLearnSignals.learnedSymbols"
        static let MorsePathLearnSignalsPracticeAttempts = "MorsePathLearnSignals.practiceAttempts"
        static let MorsePathLearnSignalsCorrectAttempts = "MorsePathLearnSignals.correctAttempts"
        static let MorsePathLearnSignalsMistakes = "MorsePathLearnSignals.mistakes"
        static let MorsePathLearnSignalsBestStreak = "MorsePathLearnSignals.bestStreak"
        static let MorsePathLearnSignalsCurrentStreak = "MorsePathLearnSignals.currentStreak"
        static let MorsePathLearnSignalsQuizMistakesBySymbol =
            "MorsePathLearnSignals.quiz.mistakesBySymbol"
        static let MorsePathLearnSignalsQuizBestScores =
            "MorsePathLearnSignals.quiz.bestScores"
        static let MorsePathLearnSignalsCompletedQuizSessions =
            "MorsePathLearnSignals.quiz.completedSessions"
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
        MorsePathLearnSignalsQuizMistakesBySymbol =
            MorsePathLearnSignalsDefaults.dictionary(
                forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizMistakesBySymbol
            ) as? [String: Int] ?? [:]
        MorsePathLearnSignalsQuizBestScores =
            MorsePathLearnSignalsDefaults.dictionary(
                forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizBestScores
            ) as? [String: Int] ?? [:]
        MorsePathLearnSignalsCompletedQuizSessions = MorsePathLearnSignalsDefaults.integer(
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCompletedQuizSessions
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

    func MorsePathLearnSignalsSaveQuizAnswer(
        MorsePathLearnSignalsSymbol: String,
        MorsePathLearnSignalsIsCorrect: Bool
    ) {
        guard !MorsePathLearnSignalsIsCorrect else { return }
        MorsePathLearnSignalsQuizMistakesBySymbol[MorsePathLearnSignalsSymbol, default: 0] += 1
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsQuizMistakesBySymbol,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizMistakesBySymbol
        )
    }

    func MorsePathLearnSignalsSaveQuizSession(
        MorsePathLearnSignalsResult: MorsePathLearnSignalsQuizResult
    ) {
        MorsePathLearnSignalsCompletedQuizSessions += 1
        let MorsePathLearnSignalsScoreKey = MorsePathLearnSignalsQuizScoreKey(
            MorsePathLearnSignalsMode: MorsePathLearnSignalsResult.MorsePathLearnSignalsMode,
            MorsePathLearnSignalsCategory:
                MorsePathLearnSignalsResult.MorsePathLearnSignalsCategory
        )
        MorsePathLearnSignalsQuizBestScores[MorsePathLearnSignalsScoreKey] = max(
            MorsePathLearnSignalsQuizBestScores[MorsePathLearnSignalsScoreKey] ?? 0,
            MorsePathLearnSignalsResult.MorsePathLearnSignalsCorrectAnswers
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsCompletedQuizSessions,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsCompletedQuizSessions
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsQuizBestScores,
            forKey: MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizBestScores
        )
    }

    func MorsePathLearnSignalsQuizBestScore(
        MorsePathLearnSignalsMode: MorsePathLearnSignalsQuizMode,
        MorsePathLearnSignalsCategory: MorsePathLearnSignalsLearnCategory
    ) -> Int {
        MorsePathLearnSignalsQuizBestScores[
            MorsePathLearnSignalsQuizScoreKey(
                MorsePathLearnSignalsMode: MorsePathLearnSignalsMode,
                MorsePathLearnSignalsCategory: MorsePathLearnSignalsCategory
            )
        ] ?? 0
    }

    var MorsePathLearnSignalsMostDifficultQuizSymbols: [(String, Int)] {
        MorsePathLearnSignalsQuizMistakesBySymbol
            .filter { $0.value > 0 }
            .sorted {
                if $0.value == $1.value {
                    return $0.key < $1.key
                }
                return $0.value > $1.value
            }
    }

    func MorsePathLearnSignalsResetProgress() {
        MorsePathLearnSignalsLearnedSymbols = []
        MorsePathLearnSignalsPracticeAttempts = 0
        MorsePathLearnSignalsCorrectAttempts = 0
        MorsePathLearnSignalsMistakes = 0
        MorsePathLearnSignalsBestStreak = 0
        MorsePathLearnSignalsCurrentStreak = 0
        MorsePathLearnSignalsQuizMistakesBySymbol = [:]
        MorsePathLearnSignalsQuizBestScores = [:]
        MorsePathLearnSignalsCompletedQuizSessions = 0

        [
            MorsePathLearnSignalsKey.MorsePathLearnSignalsLearnedSymbols,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsPracticeAttempts,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsCorrectAttempts,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsMistakes,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsBestStreak,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsCurrentStreak,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizMistakesBySymbol,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsQuizBestScores,
            MorsePathLearnSignalsKey.MorsePathLearnSignalsCompletedQuizSessions
        ].forEach(MorsePathLearnSignalsDefaults.removeObject)
    }

    private func MorsePathLearnSignalsQuizScoreKey(
        MorsePathLearnSignalsMode: MorsePathLearnSignalsQuizMode,
        MorsePathLearnSignalsCategory: MorsePathLearnSignalsLearnCategory
    ) -> String {
        "\(MorsePathLearnSignalsMode.rawValue)|\(MorsePathLearnSignalsCategory.rawValue)"
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
