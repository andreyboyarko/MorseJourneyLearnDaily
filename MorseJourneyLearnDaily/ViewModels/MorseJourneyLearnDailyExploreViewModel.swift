import Combine
import Foundation
import UIKit

final class MorseJourneyLearnDailyExploreViewModel: ObservableObject {
    @Published var MorseJourneyLearnDailySelectedCategory:
        MorseJourneyLearnDailyExploreCategory = .all {
        didSet {
            MorseJourneyLearnDailyPrepareQueue(
                MorseJourneyLearnDailyAvoiding:
                    MorseJourneyLearnDailyCurrentQuestion?.id
            )
            MorseJourneyLearnDailyLoadNextQuestion()
        }
    }
    @Published private(set) var MorseJourneyLearnDailyCurrentQuestion:
        MorseJourneyLearnDailyExploreQuestion?
    @Published private(set) var MorseJourneyLearnDailySelectedAnswer: Bool?
    @Published private(set) var MorseJourneyLearnDailyAnswerIsCorrect: Bool?
    @Published private(set) var MorseJourneyLearnDailyCorrectAnswers = 0
    @Published private(set) var MorseJourneyLearnDailyTotalAnswers = 0
    @Published private(set) var MorseJourneyLearnDailyCurrentStreak = 0

    private var MorseJourneyLearnDailyQuestionQueue:
        [MorseJourneyLearnDailyExploreQuestion] = []
    private var MorseJourneyLearnDailyLastQuestionID: UUID?

    init() {
        MorseJourneyLearnDailyPrepareQueue(MorseJourneyLearnDailyAvoiding: nil)
        MorseJourneyLearnDailyLoadNextQuestion()
    }

    func MorseJourneyLearnDailyAnswer(_ MorseJourneyLearnDailyAnswer: Bool) {
        guard MorseJourneyLearnDailySelectedAnswer == nil,
              let MorseJourneyLearnDailyQuestion =
                MorseJourneyLearnDailyCurrentQuestion
        else { return }

        let MorseJourneyLearnDailyIsCorrect =
            MorseJourneyLearnDailyAnswer == MorseJourneyLearnDailyQuestion.isTrue
        MorseJourneyLearnDailySelectedAnswer = MorseJourneyLearnDailyAnswer
        MorseJourneyLearnDailyAnswerIsCorrect = MorseJourneyLearnDailyIsCorrect
        MorseJourneyLearnDailyTotalAnswers += 1

        if MorseJourneyLearnDailyIsCorrect {
            MorseJourneyLearnDailyCorrectAnswers += 1
            MorseJourneyLearnDailyCurrentStreak += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            MorseJourneyLearnDailyCurrentStreak = 0
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    func MorseJourneyLearnDailyNextQuestion() {
        guard MorseJourneyLearnDailySelectedAnswer != nil else { return }
        MorseJourneyLearnDailyLoadNextQuestion()
    }

    func MorseJourneyLearnDailyRestart() {
        MorseJourneyLearnDailyCorrectAnswers = 0
        MorseJourneyLearnDailyTotalAnswers = 0
        MorseJourneyLearnDailyCurrentStreak = 0
        MorseJourneyLearnDailyPrepareQueue(
            MorseJourneyLearnDailyAvoiding:
                MorseJourneyLearnDailyCurrentQuestion?.id
        )
        MorseJourneyLearnDailyLoadNextQuestion()
    }

    private func MorseJourneyLearnDailyLoadNextQuestion() {
        if MorseJourneyLearnDailyQuestionQueue.isEmpty {
            MorseJourneyLearnDailyPrepareQueue(
                MorseJourneyLearnDailyAvoiding:
                    MorseJourneyLearnDailyLastQuestionID
            )
        }

        MorseJourneyLearnDailyCurrentQuestion =
            MorseJourneyLearnDailyQuestionQueue.isEmpty
            ? nil
            : MorseJourneyLearnDailyQuestionQueue.removeFirst()
        MorseJourneyLearnDailyLastQuestionID =
            MorseJourneyLearnDailyCurrentQuestion?.id
        MorseJourneyLearnDailySelectedAnswer = nil
        MorseJourneyLearnDailyAnswerIsCorrect = nil
    }

    private func MorseJourneyLearnDailyPrepareQueue(
        MorseJourneyLearnDailyAvoiding MorseJourneyLearnDailyQuestionID: UUID?
    ) {
        var MorseJourneyLearnDailyQuestions =
            MorseJourneyLearnDailyExploreQuestionStore
            .MorseJourneyLearnDailyQuestions
            .filter { MorseJourneyLearnDailyQuestion in
                MorseJourneyLearnDailySelectedCategory == .all
                    || MorseJourneyLearnDailyQuestion.category
                        == MorseJourneyLearnDailySelectedCategory
            }
            .shuffled()

        if MorseJourneyLearnDailyQuestions.count > 1,
           MorseJourneyLearnDailyQuestions.first?.id
            == MorseJourneyLearnDailyQuestionID {
            MorseJourneyLearnDailyQuestions.swapAt(0, 1)
        }

        MorseJourneyLearnDailyQuestionQueue = MorseJourneyLearnDailyQuestions
    }
}
