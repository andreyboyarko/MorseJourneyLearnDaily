import Foundation
import Combine
import SwiftUI
import UIKit

final class MorsePathLearnSignalsQuizViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsSelectedCategory:
        MorsePathLearnSignalsLearnCategory = .letters
    @Published var MorsePathLearnSignalsSelectedMode:
        MorsePathLearnSignalsQuizMode = .mixed
    @Published private(set) var MorsePathLearnSignalsQuestions:
        [MorsePathLearnSignalsQuizQuestion] = []
    @Published private(set) var MorsePathLearnSignalsCurrentQuestionIndex = 0
    @Published private(set) var MorsePathLearnSignalsCorrectAnswers = 0
    @Published private(set) var MorsePathLearnSignalsHasAnswered = false
    @Published private(set) var MorsePathLearnSignalsAnswerWasCorrect: Bool?
    @Published private(set) var MorsePathLearnSignalsSelectedAnswer: String?
    @Published var MorsePathLearnSignalsEnteredCode = ""
    @Published private(set) var MorsePathLearnSignalsResult:
        MorsePathLearnSignalsQuizResult?
    @Published private(set) var MorsePathLearnSignalsIsSessionActive = false

    private let MorsePathLearnSignalsQuestionCount = 10
    private let MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService
    private let MorsePathLearnSignalsSoundServiceInstance =
        MorsePathLearnSignalsSoundService()
    private var MorsePathLearnSignalsSessionMistakes: [MorsePathLearnSignalsQuizMistake] = []

    init(
        MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService =
            .MorsePathLearnSignalsShared
    ) {
        self.MorsePathLearnSignalsProgressService = MorsePathLearnSignalsProgressService
    }

    var MorsePathLearnSignalsCurrentQuestion: MorsePathLearnSignalsQuizQuestion? {
        guard MorsePathLearnSignalsQuestions.indices.contains(
            MorsePathLearnSignalsCurrentQuestionIndex
        ) else { return nil }
        return MorsePathLearnSignalsQuestions[MorsePathLearnSignalsCurrentQuestionIndex]
    }

    var MorsePathLearnSignalsQuestionPositionText: String {
        "\(MorsePathLearnSignalsCurrentQuestionIndex + 1) / \(MorsePathLearnSignalsQuestionCount)"
    }

    var MorsePathLearnSignalsProgressValue: Double {
        Double(MorsePathLearnSignalsCurrentQuestionIndex + 1)
            / Double(MorsePathLearnSignalsQuestionCount)
    }

    var MorsePathLearnSignalsBestScore: Int {
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsQuizBestScore(
            MorsePathLearnSignalsMode: MorsePathLearnSignalsSelectedMode,
            MorsePathLearnSignalsCategory: MorsePathLearnSignalsSelectedCategory
        )
    }

    func MorsePathLearnSignalsStartSession() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
        MorsePathLearnSignalsQuestions = MorsePathLearnSignalsMakeQuestions()
        MorsePathLearnSignalsCurrentQuestionIndex = 0
        MorsePathLearnSignalsCorrectAnswers = 0
        MorsePathLearnSignalsSessionMistakes = []
        MorsePathLearnSignalsResult = nil
        MorsePathLearnSignalsIsSessionActive = true
        MorsePathLearnSignalsResetAnswerState()
        MorsePathLearnSignalsPlayCurrentQuestionIfNeeded()
    }

    func MorsePathLearnSignalsSelectAnswer(_ MorsePathLearnSignalsAnswer: String) {
        guard !MorsePathLearnSignalsHasAnswered,
              let MorsePathLearnSignalsQuestion = MorsePathLearnSignalsCurrentQuestion,
              MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType != .enterCode
        else { return }
        MorsePathLearnSignalsSelectedAnswer = MorsePathLearnSignalsAnswer
        MorsePathLearnSignalsEvaluate(
            MorsePathLearnSignalsAnswer,
            correctAnswer:
                MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                .MorsePathLearnSignalsSymbol
        )
    }

    func MorsePathLearnSignalsAddDot() {
        MorsePathLearnSignalsAppendCode(".")
    }

    func MorsePathLearnSignalsAddDash() {
        MorsePathLearnSignalsAppendCode("-")
    }

    func MorsePathLearnSignalsDeleteCodeElement() {
        guard !MorsePathLearnSignalsHasAnswered,
              !MorsePathLearnSignalsEnteredCode.isEmpty
        else { return }
        MorsePathLearnSignalsEnteredCode.removeLast()
    }

    func MorsePathLearnSignalsSubmitCode() {
        guard !MorsePathLearnSignalsHasAnswered,
              !MorsePathLearnSignalsEnteredCode.isEmpty,
              let MorsePathLearnSignalsQuestion = MorsePathLearnSignalsCurrentQuestion,
              MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType == .enterCode
        else { return }
        MorsePathLearnSignalsSelectedAnswer = MorsePathLearnSignalsEnteredCode
        MorsePathLearnSignalsEvaluate(
            MorsePathLearnSignalsEnteredCode,
            correctAnswer:
                MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                .MorsePathLearnSignalsCode
        )
    }

    func MorsePathLearnSignalsReplaySound() {
        guard MorsePathLearnSignalsCurrentQuestion?
            .MorsePathLearnSignalsType == .listening
        else { return }
        MorsePathLearnSignalsPlayCurrentQuestionIfNeeded()
    }

    func MorsePathLearnSignalsAdvance() {
        guard MorsePathLearnSignalsHasAnswered else { return }
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
        if MorsePathLearnSignalsCurrentQuestionIndex
            < MorsePathLearnSignalsQuestions.count - 1 {
            MorsePathLearnSignalsCurrentQuestionIndex += 1
            MorsePathLearnSignalsResetAnswerState()
            MorsePathLearnSignalsPlayCurrentQuestionIfNeeded()
        } else {
            MorsePathLearnSignalsFinishSession()
        }
    }

    func MorsePathLearnSignalsReturnToSetup() {
        MorsePathLearnSignalsStopAudio()
        MorsePathLearnSignalsIsSessionActive = false
        MorsePathLearnSignalsResult = nil
        MorsePathLearnSignalsQuestions = []
        MorsePathLearnSignalsResetAnswerState()
    }

    func MorsePathLearnSignalsStopAudio() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
    }

    private func MorsePathLearnSignalsEvaluate(
        _ MorsePathLearnSignalsAnswer: String,
        correctAnswer MorsePathLearnSignalsCorrectAnswer: String
    ) {
        guard !MorsePathLearnSignalsHasAnswered,
              let MorsePathLearnSignalsQuestion = MorsePathLearnSignalsCurrentQuestion
        else { return }

        let MorsePathLearnSignalsIsCorrect =
            MorsePathLearnSignalsAnswer == MorsePathLearnSignalsCorrectAnswer
        MorsePathLearnSignalsHasAnswered = true
        MorsePathLearnSignalsAnswerWasCorrect = MorsePathLearnSignalsIsCorrect
        if MorsePathLearnSignalsIsCorrect {
            MorsePathLearnSignalsCorrectAnswers += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            MorsePathLearnSignalsSessionMistakes.append(
                MorsePathLearnSignalsQuizMistake(
                    MorsePathLearnSignalsSymbol:
                        MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                        .MorsePathLearnSignalsSymbol,
                    MorsePathLearnSignalsCode:
                        MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                        .MorsePathLearnSignalsCode,
                    MorsePathLearnSignalsAnswer: MorsePathLearnSignalsAnswer
                )
            )
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveQuizAnswer(
            MorsePathLearnSignalsSymbol:
                MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                .MorsePathLearnSignalsSymbol,
            MorsePathLearnSignalsIsCorrect: MorsePathLearnSignalsIsCorrect
        )
    }

    private func MorsePathLearnSignalsFinishSession() {
        let MorsePathLearnSignalsFinishedResult = MorsePathLearnSignalsQuizResult(
            MorsePathLearnSignalsMode: MorsePathLearnSignalsSelectedMode,
            MorsePathLearnSignalsCategory: MorsePathLearnSignalsSelectedCategory,
            MorsePathLearnSignalsCorrectAnswers: MorsePathLearnSignalsCorrectAnswers,
            MorsePathLearnSignalsTotalQuestions: MorsePathLearnSignalsQuestionCount,
            MorsePathLearnSignalsMistakes: MorsePathLearnSignalsSessionMistakes
        )
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveQuizSession(
            MorsePathLearnSignalsResult: MorsePathLearnSignalsFinishedResult
        )
        MorsePathLearnSignalsResult = MorsePathLearnSignalsFinishedResult
        MorsePathLearnSignalsIsSessionActive = false
    }

    private func MorsePathLearnSignalsResetAnswerState() {
        MorsePathLearnSignalsHasAnswered = false
        MorsePathLearnSignalsAnswerWasCorrect = nil
        MorsePathLearnSignalsSelectedAnswer = nil
        MorsePathLearnSignalsEnteredCode = ""
    }

    private func MorsePathLearnSignalsAppendCode(
        _ MorsePathLearnSignalsElement: Character
    ) {
        guard !MorsePathLearnSignalsHasAnswered,
              MorsePathLearnSignalsEnteredCode.count < 8
        else { return }
        MorsePathLearnSignalsEnteredCode.append(MorsePathLearnSignalsElement)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func MorsePathLearnSignalsPlayCurrentQuestionIfNeeded() {
        guard let MorsePathLearnSignalsQuestion = MorsePathLearnSignalsCurrentQuestion,
              MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType == .listening
        else { return }
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
            MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                .MorsePathLearnSignalsCode,
            speed: .medium
        )
    }

    private func MorsePathLearnSignalsMakeQuestions()
        -> [MorsePathLearnSignalsQuizQuestion] {
        let MorsePathLearnSignalsItems =
            MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsItems(
                for: MorsePathLearnSignalsSelectedCategory
            )
        guard !MorsePathLearnSignalsItems.isEmpty else { return [] }

        var MorsePathLearnSignalsQuestions: [MorsePathLearnSignalsQuizQuestion] = []
        var MorsePathLearnSignalsPreviousSymbol: String?

        for MorsePathLearnSignalsIndex in 0..<MorsePathLearnSignalsQuestionCount {
            let MorsePathLearnSignalsItem = MorsePathLearnSignalsChooseItem(
                from: MorsePathLearnSignalsItems,
                excluding: MorsePathLearnSignalsPreviousSymbol
            )
            MorsePathLearnSignalsPreviousSymbol =
                MorsePathLearnSignalsItem.MorsePathLearnSignalsSymbol

            let MorsePathLearnSignalsType: MorsePathLearnSignalsQuizQuestionType
            if MorsePathLearnSignalsSelectedMode == .listening {
                MorsePathLearnSignalsType = .listening
            } else {
                let MorsePathLearnSignalsMixedTypes:
                    [MorsePathLearnSignalsQuizQuestionType] = [
                        .recognizeCode, .enterCode, .listening
                    ]
                MorsePathLearnSignalsType =
                    MorsePathLearnSignalsMixedTypes[
                        MorsePathLearnSignalsIndex
                            % MorsePathLearnSignalsMixedTypes.count
                    ]
            }

            let MorsePathLearnSignalsOptions =
                MorsePathLearnSignalsType == .enterCode
                ? []
                : MorsePathLearnSignalsMakeOptions(
                    for: MorsePathLearnSignalsItem,
                    from: MorsePathLearnSignalsItems
                )
            MorsePathLearnSignalsQuestions.append(
                MorsePathLearnSignalsQuizQuestion(
                    MorsePathLearnSignalsType: MorsePathLearnSignalsType,
                    MorsePathLearnSignalsItem: MorsePathLearnSignalsItem,
                    MorsePathLearnSignalsOptions: MorsePathLearnSignalsOptions
                )
            )
        }
        return MorsePathLearnSignalsQuestions
    }

    private func MorsePathLearnSignalsChooseItem(
        from MorsePathLearnSignalsItems: [MorsePathLearnSignalsMorseItem],
        excluding MorsePathLearnSignalsExcludedSymbol: String?
    ) -> MorsePathLearnSignalsMorseItem {
        let MorsePathLearnSignalsAvailableItems = MorsePathLearnSignalsItems.filter {
            $0.MorsePathLearnSignalsSymbol != MorsePathLearnSignalsExcludedSymbol
        }
        let MorsePathLearnSignalsPool =
            MorsePathLearnSignalsAvailableItems.isEmpty
            ? MorsePathLearnSignalsItems
            : MorsePathLearnSignalsAvailableItems

        if Int.random(in: 0..<100) < 65 {
            let MorsePathLearnSignalsWeightedItems =
                MorsePathLearnSignalsPool.flatMap { MorsePathLearnSignalsItem in
                    let MorsePathLearnSignalsMistakeCount =
                        MorsePathLearnSignalsProgressService
                        .MorsePathLearnSignalsQuizMistakesBySymbol[
                            MorsePathLearnSignalsItem.MorsePathLearnSignalsSymbol
                        ] ?? 0
                    return Array(
                        repeating: MorsePathLearnSignalsItem,
                        count: max(1, min(MorsePathLearnSignalsMistakeCount + 1, 6))
                    )
                }
            return MorsePathLearnSignalsWeightedItems.randomElement()
                ?? MorsePathLearnSignalsPool[0]
        }
        return MorsePathLearnSignalsPool.randomElement()
            ?? MorsePathLearnSignalsItems[0]
    }

    private func MorsePathLearnSignalsMakeOptions(
        for MorsePathLearnSignalsCorrectItem: MorsePathLearnSignalsMorseItem,
        from MorsePathLearnSignalsItems: [MorsePathLearnSignalsMorseItem]
    ) -> [String] {
        let MorsePathLearnSignalsDistractors = MorsePathLearnSignalsItems
            .filter {
                $0.MorsePathLearnSignalsSymbol
                    != MorsePathLearnSignalsCorrectItem.MorsePathLearnSignalsSymbol
            }
            .shuffled()
            .prefix(3)
            .map(\.MorsePathLearnSignalsSymbol)
        return (
            Array(MorsePathLearnSignalsDistractors)
                + [MorsePathLearnSignalsCorrectItem.MorsePathLearnSignalsSymbol]
        ).shuffled()
    }
}
