import Foundation
import Combine
import SwiftUI
import UIKit

final class MorsePathLearnSignalsLearnViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsSelectedCategory: MorsePathLearnSignalsLearnCategory = .letters {
        didSet {
            MorsePathLearnSignalsCurrentIndex = 0
            MorsePathLearnSignalsResetAttempt()
            MorsePathLearnSignalsMarkCurrentAsLearned()
        }
    }
    @Published private(set) var MorsePathLearnSignalsCurrentIndex = 0
    @Published private(set) var MorsePathLearnSignalsAttempt = ""
    @Published private(set) var MorsePathLearnSignalsAttemptIsCorrect: Bool?

    let MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService
    private let MorsePathLearnSignalsSoundServiceInstance = MorsePathLearnSignalsSoundService()

    init(
        MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService =
            .MorsePathLearnSignalsShared
    ) {
        self.MorsePathLearnSignalsProgressService = MorsePathLearnSignalsProgressService
    }

    var MorsePathLearnSignalsItems: [MorsePathLearnSignalsMorseItem] {
        MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsItems(
            for: MorsePathLearnSignalsSelectedCategory
        )
    }

    var MorsePathLearnSignalsCurrentItem: MorsePathLearnSignalsMorseItem {
        MorsePathLearnSignalsItems[MorsePathLearnSignalsCurrentIndex]
    }

    var MorsePathLearnSignalsPositionText: String {
        "\(MorsePathLearnSignalsCurrentIndex + 1) / \(MorsePathLearnSignalsItems.count)"
    }

    func MorsePathLearnSignalsShowPrevious() {
        guard MorsePathLearnSignalsCurrentIndex > 0 else { return }
        MorsePathLearnSignalsCurrentIndex -= 1
        MorsePathLearnSignalsResetAttempt()
        MorsePathLearnSignalsMarkCurrentAsLearned()
    }

    func MorsePathLearnSignalsShowNext() {
        guard MorsePathLearnSignalsCurrentIndex < MorsePathLearnSignalsItems.count - 1 else { return }
        MorsePathLearnSignalsCurrentIndex += 1
        MorsePathLearnSignalsResetAttempt()
        MorsePathLearnSignalsMarkCurrentAsLearned()
    }

    func MorseJourneyLearnDailySelectItem(
        MorseJourneyLearnDailyItem: MorsePathLearnSignalsMorseItem,
        MorseJourneyLearnDailyCategory: MorsePathLearnSignalsLearnCategory
    ) {
        MorsePathLearnSignalsSelectedCategory = MorseJourneyLearnDailyCategory

        guard let MorseJourneyLearnDailyIndex =
            MorsePathLearnSignalsItems.firstIndex(of: MorseJourneyLearnDailyItem)
        else { return }

        MorsePathLearnSignalsCurrentIndex = MorseJourneyLearnDailyIndex
        MorsePathLearnSignalsResetAttempt()
        MorsePathLearnSignalsMarkCurrentAsLearned()
    }

    func MorsePathLearnSignalsPlayCurrentSound() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
            MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode,
            speed: .medium
        )
    }

    func MorsePathLearnSignalsStartAttemptTone() {
        guard MorsePathLearnSignalsAttemptIsCorrect == nil else { return }
        MorsePathLearnSignalsSoundServiceInstance
            .MorsePathLearnSignalsStartContinuousTone()
    }

    func MorsePathLearnSignalsStopAttemptTone() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
    }

    func MorsePathLearnSignalsMarkCurrentAsLearned() {
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveLearnedSymbol(
            MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsSymbol
        )
    }

    func MorsePathLearnSignalsAddAttemptDot() {
        MorsePathLearnSignalsAppendAttempt(".")
    }

    func MorsePathLearnSignalsAddAttemptDash() {
        MorsePathLearnSignalsAppendAttempt("-")
    }

    func MorsePathLearnSignalsResetAttempt() {
        MorsePathLearnSignalsStopAttemptTone()
        MorsePathLearnSignalsAttempt = ""
        MorsePathLearnSignalsAttemptIsCorrect = nil
    }

    private func MorsePathLearnSignalsAppendAttempt(
        _ MorsePathLearnSignalsElement: Character
    ) {
        guard MorsePathLearnSignalsAttemptIsCorrect == nil,
              MorsePathLearnSignalsAttempt.count
                < MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode.count
        else { return }

        MorsePathLearnSignalsAttempt.append(MorsePathLearnSignalsElement)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if MorsePathLearnSignalsAttempt.count
            == MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode.count {
            MorsePathLearnSignalsAttemptIsCorrect =
                MorsePathLearnSignalsAttempt
                == MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode
            UINotificationFeedbackGenerator().notificationOccurred(
                MorsePathLearnSignalsAttemptIsCorrect == true ? .success : .error
            )
        }
    }
}

final class MorsePathLearnSignalsPracticeViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsTranslationMode:
        MorsePathLearnSignalsTranslationMode = .textToMorse {
        didSet {
            MorseJourneyLearnDailyCancelPendingTapToTextActions()
            MorseJourneyLearnDailyStopTapToTextTone()
            MorsePathLearnSignalsTranslationInput = ""
            MorsePathLearnSignalsShowsCopiedConfirmation = false
        }
    }
    @Published var MorsePathLearnSignalsTranslationInput = "" {
        didSet {
            MorsePathLearnSignalsShowsCopiedConfirmation = false
        }
    }
    @Published var MorsePathLearnSignalsShowsCopiedConfirmation = false
    @Published var MorsePathLearnSignalsTapInput = ""
    @Published private(set) var MorsePathLearnSignalsFeedbackMessage = ""
    @Published private(set) var MorsePathLearnSignalsFeedbackIsSuccess: Bool?
    @Published private(set) var MorseJourneyLearnDailyTapToTextCode = ""
    @Published private(set) var MorseJourneyLearnDailyTapToTextResult = ""
    @Published private(set) var MorseJourneyLearnDailyTapToTextHasError = false
    @Published private(set) var MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()
    private let MorsePathLearnSignalsSoundServiceInstance =
        MorsePathLearnSignalsSoundService()
    private let MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService
    private var MorseJourneyLearnDailyLetterCommitTask: Task<Void, Never>?
    private var MorseJourneyLearnDailyWordSpaceTask: Task<Void, Never>?

    init(
        MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService =
            .MorsePathLearnSignalsShared
    ) {
        self.MorsePathLearnSignalsProgressService = MorsePathLearnSignalsProgressService
    }

    var MorsePathLearnSignalsTranslationResult: String {
        if MorsePathLearnSignalsTranslationMode == .tapToText {
            return MorseJourneyLearnDailyTapToTextResult
        }

        let MorsePathLearnSignalsTrimmedInput =
            MorsePathLearnSignalsTranslationInput.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        guard !MorsePathLearnSignalsTrimmedInput.isEmpty else { return "" }

        switch MorsePathLearnSignalsTranslationMode {
        case .textToMorse:
            return MorsePathLearnSignalsMorseServiceInstance
                .MorsePathLearnSignalsTextToMorse(MorsePathLearnSignalsTrimmedInput)
        case .morseToText:
            return MorsePathLearnSignalsMorseServiceInstance
                .MorsePathLearnSignalsMorseToText(MorsePathLearnSignalsTrimmedInput)
        case .tapToText:
            return ""
        }
    }

    var MorsePathLearnSignalsExpectedTapSignal: String {
        let MorsePathLearnSignalsSource: String
        switch MorsePathLearnSignalsTranslationMode {
        case .textToMorse:
            MorsePathLearnSignalsSource = MorsePathLearnSignalsTranslationResult
        case .morseToText:
            MorsePathLearnSignalsSource = MorsePathLearnSignalsTranslationInput
        case .tapToText:
            MorsePathLearnSignalsSource = ""
        }
        return String(
            MorsePathLearnSignalsSource.filter { $0 == "." || $0 == "-" }
        )
    }

    var MorseJourneyLearnDailyTapTranslation: String {
        guard !MorsePathLearnSignalsTapInput.isEmpty else { return "" }
        return MorsePathLearnSignalsMorseServiceInstance
            .MorsePathLearnSignalsSymbolForMorse(
                MorsePathLearnSignalsTapInput
            ) ?? ""
    }

    func MorsePathLearnSignalsTapElementMatchesExpected(
        at MorsePathLearnSignalsIndex: Int
    ) -> Bool? {
        guard !MorsePathLearnSignalsExpectedTapSignal.isEmpty,
              MorsePathLearnSignalsTapInput.indices.contains(
                MorsePathLearnSignalsTapInput.index(
                    MorsePathLearnSignalsTapInput.startIndex,
                    offsetBy: MorsePathLearnSignalsIndex
                )
              )
        else { return nil }

        guard MorsePathLearnSignalsIndex
            < MorsePathLearnSignalsExpectedTapSignal.count
        else { return false }

        let MorsePathLearnSignalsInputIndex =
            MorsePathLearnSignalsTapInput.index(
                MorsePathLearnSignalsTapInput.startIndex,
                offsetBy: MorsePathLearnSignalsIndex
            )
        let MorsePathLearnSignalsExpectedIndex =
            MorsePathLearnSignalsExpectedTapSignal.index(
                MorsePathLearnSignalsExpectedTapSignal.startIndex,
                offsetBy: MorsePathLearnSignalsIndex
            )
        return MorsePathLearnSignalsTapInput[MorsePathLearnSignalsInputIndex]
            == MorsePathLearnSignalsExpectedTapSignal[
                MorsePathLearnSignalsExpectedIndex
            ]
    }

    func MorsePathLearnSignalsCopyTranslation() {
        guard !MorsePathLearnSignalsTranslationResult.isEmpty else { return }
        UIPasteboard.general.string = MorsePathLearnSignalsTranslationResult
        MorsePathLearnSignalsShowsCopiedConfirmation = true
    }

    func MorsePathLearnSignalsClearTranslation() {
        MorsePathLearnSignalsTranslationInput = ""
        MorsePathLearnSignalsShowsCopiedConfirmation = false
    }

    func MorsePathLearnSignalsAddDot() {
        MorsePathLearnSignalsAppend(".")
    }

    func MorsePathLearnSignalsAddDash() {
        MorsePathLearnSignalsAppend("-")
    }

    func MorsePathLearnSignalsStartTapTone() {
        MorsePathLearnSignalsSoundServiceInstance
            .MorsePathLearnSignalsStartContinuousTone()
    }

    func MorsePathLearnSignalsStopTapTone() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
    }

    func MorseJourneyLearnDailyStartTapToTextTone() {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()
        MorsePathLearnSignalsSoundServiceInstance
            .MorsePathLearnSignalsStartContinuousTone()
    }

    func MorseJourneyLearnDailyStopTapToTextTone() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
    }

    func MorseJourneyLearnDailyAddTapToTextDot() {
        MorseJourneyLearnDailyAppendTapToTextElement(".")
    }

    func MorseJourneyLearnDailyAddTapToTextDash() {
        MorseJourneyLearnDailyAppendTapToTextElement("-")
    }

    func MorseJourneyLearnDailyCommitTapToTextLetter() {
        MorseJourneyLearnDailyLetterCommitTask?.cancel()
        MorseJourneyLearnDailyLetterCommitTask = nil
        guard !MorseJourneyLearnDailyTapToTextCode.isEmpty else { return }

        guard let MorseJourneyLearnDailySymbol =
            MorsePathLearnSignalsMorseServiceInstance
            .MorsePathLearnSignalsSymbolForMorse(
                MorseJourneyLearnDailyTapToTextCode
            )
        else {
            MorseJourneyLearnDailyTapToTextHasError = true
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }

        MorseJourneyLearnDailyTapToTextResult.append(
            contentsOf: MorseJourneyLearnDailySymbol
        )
        MorseJourneyLearnDailyTapToTextCode = ""
        MorseJourneyLearnDailyTapToTextHasError = false
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        MorseJourneyLearnDailyScheduleAutomaticWordSpace()
    }

    func MorseJourneyLearnDailyAddTapToTextSpace() {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()

        if !MorseJourneyLearnDailyTapToTextCode.isEmpty {
            MorseJourneyLearnDailyCommitTapToTextLetter()
            guard !MorseJourneyLearnDailyTapToTextHasError else { return }
        }

        guard !MorseJourneyLearnDailyTapToTextResult.isEmpty,
              !MorseJourneyLearnDailyTapToTextResult.hasSuffix(" ")
        else { return }
        MorseJourneyLearnDailyTapToTextResult.append(" ")
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false
    }

    func MorseJourneyLearnDailyDeleteTapToText() {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()
        MorseJourneyLearnDailyTapToTextHasError = false
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false

        if !MorseJourneyLearnDailyTapToTextCode.isEmpty {
            MorseJourneyLearnDailyTapToTextCode.removeLast()
            if !MorseJourneyLearnDailyTapToTextCode.isEmpty {
                MorseJourneyLearnDailyScheduleAutomaticLetterCommit()
            }
        } else if !MorseJourneyLearnDailyTapToTextResult.isEmpty {
            MorseJourneyLearnDailyTapToTextResult.removeLast()
        }
    }

    func MorseJourneyLearnDailyClearTapToText() {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()
        MorseJourneyLearnDailyStopTapToTextTone()
        MorseJourneyLearnDailyTapToTextCode = ""
        MorseJourneyLearnDailyTapToTextResult = ""
        MorseJourneyLearnDailyTapToTextHasError = false
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false
    }

    func MorseJourneyLearnDailyCopyTapToText() {
        guard !MorseJourneyLearnDailyTapToTextResult.isEmpty else { return }
        UIPasteboard.general.string =
            MorseJourneyLearnDailyTapToTextResult
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = true
    }

    func MorseJourneyLearnDailyStopTapToText() {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()
        MorseJourneyLearnDailyStopTapToTextTone()
    }

    func MorsePathLearnSignalsDeleteLast() {
        guard !MorsePathLearnSignalsTapInput.isEmpty else { return }
        MorsePathLearnSignalsTapInput.removeLast()
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
    }

    func MorsePathLearnSignalsClearTapInput() {
        MorsePathLearnSignalsTapInput = ""
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
    }

    func MorsePathLearnSignalsCheck() {
        guard !MorsePathLearnSignalsTapInput.isEmpty else {
            MorsePathLearnSignalsFeedbackMessage = "Enter a Morse sequence first."
            MorsePathLearnSignalsFeedbackIsSuccess = false
            return
        }

        let MorsePathLearnSignalsIsCorrect: Bool
        if MorsePathLearnSignalsExpectedTapSignal.isEmpty {
            MorsePathLearnSignalsIsCorrect =
                MorsePathLearnSignalsMorseServiceInstance
                .MorsePathLearnSignalsSymbolForMorse(
                    MorsePathLearnSignalsTapInput
                ) != nil
        } else {
            MorsePathLearnSignalsIsCorrect =
                MorsePathLearnSignalsTapInput
                == MorsePathLearnSignalsExpectedTapSignal
        }
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveAttempt(
            MorsePathLearnSignalsIsCorrect: MorsePathLearnSignalsIsCorrect
        )
        MorsePathLearnSignalsFeedbackIsSuccess = MorsePathLearnSignalsIsCorrect
        if MorsePathLearnSignalsExpectedTapSignal.isEmpty {
            MorsePathLearnSignalsFeedbackMessage = MorsePathLearnSignalsIsCorrect
                ? "Valid signal. Nice work!"
                : "This sequence is not in the dictionary."
        } else {
            MorsePathLearnSignalsFeedbackMessage = MorsePathLearnSignalsIsCorrect
                ? "Signal matches the translation."
                : "Red underlined elements do not match."
        }
    }

    private func MorsePathLearnSignalsAppend(_ MorsePathLearnSignalsElement: Character) {
        guard MorsePathLearnSignalsTapInput.count < 24 else { return }
        MorsePathLearnSignalsTapInput.append(MorsePathLearnSignalsElement)
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func MorseJourneyLearnDailyAppendTapToTextElement(
        _ MorseJourneyLearnDailyElement: Character
    ) {
        MorseJourneyLearnDailyCancelPendingTapToTextActions()
        guard MorseJourneyLearnDailyTapToTextCode.count < 8 else { return }
        MorseJourneyLearnDailyTapToTextCode.append(
            MorseJourneyLearnDailyElement
        )
        MorseJourneyLearnDailyTapToTextHasError = false
        MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation = false
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        MorseJourneyLearnDailyScheduleAutomaticLetterCommit()
    }

    private func MorseJourneyLearnDailyScheduleAutomaticLetterCommit() {
        MorseJourneyLearnDailyLetterCommitTask?.cancel()
        MorseJourneyLearnDailyLetterCommitTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 800_000_000)
            guard !Task.isCancelled else { return }
            self?.MorseJourneyLearnDailyCommitTapToTextLetter()
        }
    }

    private func MorseJourneyLearnDailyScheduleAutomaticWordSpace() {
        MorseJourneyLearnDailyWordSpaceTask?.cancel()
        MorseJourneyLearnDailyWordSpaceTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            guard !Task.isCancelled else { return }
            self?.MorseJourneyLearnDailyAddTapToTextSpace()
        }
    }

    private func MorseJourneyLearnDailyCancelPendingTapToTextActions() {
        MorseJourneyLearnDailyLetterCommitTask?.cancel()
        MorseJourneyLearnDailyLetterCommitTask = nil
        MorseJourneyLearnDailyWordSpaceTask?.cancel()
        MorseJourneyLearnDailyWordSpaceTask = nil
    }
}

final class MorsePathLearnSignalsSignalViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsMessage = ""
    @Published private(set) var MorsePathLearnSignalsUsesFlashlight: Bool
    @Published var MorsePathLearnSignalsUsesSound: Bool {
        didSet { MorsePathLearnSignalsSaveSettings() }
    }
    @Published var MorsePathLearnSignalsRepeats: Bool {
        didSet { MorsePathLearnSignalsSaveSettings() }
    }
    @Published var MorsePathLearnSignalsSpeed: MorsePathLearnSignalsSignalSpeed {
        didSet { MorsePathLearnSignalsSaveSettings() }
    }
    @Published private(set) var MorsePathLearnSignalsIsSignaling = false
    @Published private(set) var MorsePathLearnSignalsIsLightImpulseActive = false
    @Published var MorsePathLearnSignalsActiveAlert: MorsePathLearnSignalsSignalAlert?

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()
    private let MorsePathLearnSignalsSoundServiceInstance = MorsePathLearnSignalsSoundService()
    private let MorsePathLearnSignalsFlashlightServiceInstance =
        MorsePathLearnSignalsFlashlightService()
    private let MorsePathLearnSignalsDefaults: UserDefaults
    private var MorsePathLearnSignalsSignalTask: Task<Void, Never>?

    private enum MorsePathLearnSignalsSettingsKey {
        static let MorsePathLearnSignalsUsesFlashlight =
            "MorsePathLearnSignals.settings.usesFlashlight"
        static let MorsePathLearnSignalsUsesSound =
            "MorsePathLearnSignals.settings.usesSound"
        static let MorsePathLearnSignalsRepeats =
            "MorsePathLearnSignals.settings.repeats"
        static let MorsePathLearnSignalsSpeed =
            "MorsePathLearnSignals.settings.speed"
    }

    init(MorsePathLearnSignalsDefaults: UserDefaults = .standard) {
        self.MorsePathLearnSignalsDefaults = MorsePathLearnSignalsDefaults
        MorsePathLearnSignalsUsesFlashlight = MorsePathLearnSignalsDefaults.bool(
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsUsesFlashlight
        )
        MorsePathLearnSignalsUsesSound =
            MorsePathLearnSignalsDefaults.object(
                forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsUsesSound
            ) == nil
            ? true
            : MorsePathLearnSignalsDefaults.bool(
                forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsUsesSound
            )
        MorsePathLearnSignalsRepeats = MorsePathLearnSignalsDefaults.bool(
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsRepeats
        )
        MorsePathLearnSignalsSpeed = MorsePathLearnSignalsSignalSpeed(
            rawValue: MorsePathLearnSignalsDefaults.string(
                forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsSpeed
            ) ?? ""
        ) ?? .medium

        if MorsePathLearnSignalsFlashlightServiceInstance
            .MorsePathLearnSignalsAuthorizationState() != .authorized {
            MorsePathLearnSignalsUsesFlashlight = false
        }
    }

    var MorsePathLearnSignalsPreview: String {
        MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsTextToMorse(
            MorsePathLearnSignalsMessage
        )
    }

    func MorsePathLearnSignalsFlashlightToggleRequested(
        MorsePathLearnSignalsNewValue: Bool
    ) {
        guard MorsePathLearnSignalsNewValue else {
            MorsePathLearnSignalsUsesFlashlight = false
            MorsePathLearnSignalsSaveSettings()
            return
        }

        switch MorsePathLearnSignalsFlashlightServiceInstance
            .MorsePathLearnSignalsAuthorizationState() {
        case .notDetermined:
            MorsePathLearnSignalsActiveAlert = .flashlightExplanation
        case .authorized:
            MorsePathLearnSignalsEnableFlashlightIfAvailable()
        case .denied, .restricted:
            MorsePathLearnSignalsActiveAlert = .cameraDenied
        }
    }

    func MorsePathLearnSignalsConfirmFlashlightAccess() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let MorsePathLearnSignalsGranted =
                await MorsePathLearnSignalsFlashlightServiceInstance
                    .MorsePathLearnSignalsRequestCameraAccess()
            if MorsePathLearnSignalsGranted {
                MorsePathLearnSignalsEnableFlashlightIfAvailable()
            } else {
                MorsePathLearnSignalsUsesFlashlight = false
                MorsePathLearnSignalsSaveSettings()
                MorsePathLearnSignalsActiveAlert = .cameraDenied
            }
        }
    }

    func MorsePathLearnSignalsOpenSettings() {
        MorsePathLearnSignalsFlashlightServiceInstance
            .MorsePathLearnSignalsOpenApplicationSettings()
    }

    func MorsePathLearnSignalsStart() {
        let MorsePathLearnSignalsMorse = MorsePathLearnSignalsPreview
        guard !MorsePathLearnSignalsMorse.isEmpty else {
            MorsePathLearnSignalsActiveAlert = .emptyMessage
            return
        }
        guard MorsePathLearnSignalsUsesFlashlight || MorsePathLearnSignalsUsesSound else {
            MorsePathLearnSignalsActiveAlert = .noOutput
            return
        }
        if MorsePathLearnSignalsUsesFlashlight,
           !MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsIsFlashlightAvailable() {
            MorsePathLearnSignalsUsesFlashlight = false
            MorsePathLearnSignalsSaveSettings()
            MorsePathLearnSignalsActiveAlert = .flashlightUnavailable
            return
        }

        MorsePathLearnSignalsStop()
        MorsePathLearnSignalsIsSignaling = true
        MorsePathLearnSignalsSignalTask = Task { @MainActor [weak self] in
            await self?.MorsePathLearnSignalsRunSignal(MorsePathLearnSignalsMorse)
        }
    }

    func MorsePathLearnSignalsStop() {
        MorsePathLearnSignalsSignalTask?.cancel()
        MorsePathLearnSignalsSignalTask = nil
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
        MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsSetTorch(
            MorsePathLearnSignalsIsOn: false
        )
        MorsePathLearnSignalsIsLightImpulseActive = false
        MorsePathLearnSignalsIsSignaling = false
    }

    private func MorsePathLearnSignalsRunSignal(
        _ MorsePathLearnSignalsMorse: String
    ) async {
        repeat {
            for MorsePathLearnSignalsCharacter in MorsePathLearnSignalsMorse {
                guard !Task.isCancelled else {
                    MorsePathLearnSignalsStop()
                    return
                }
                await MorsePathLearnSignalsTransmit(MorsePathLearnSignalsCharacter)
            }

            guard MorsePathLearnSignalsRepeats, !Task.isCancelled else { break }
            await MorsePathLearnSignalsSleep(
                MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration * 7
            )
        }
        while MorsePathLearnSignalsRepeats && !Task.isCancelled

        MorsePathLearnSignalsStop()
    }

    private func MorsePathLearnSignalsTransmit(
        _ MorsePathLearnSignalsCharacter: Character
    ) async {
        let MorsePathLearnSignalsUnit = MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration
        switch MorsePathLearnSignalsCharacter {
        case ".", "-":
            let MorsePathLearnSignalsDuration =
                MorsePathLearnSignalsUnit * (MorsePathLearnSignalsCharacter == "." ? 1 : 3)
            MorsePathLearnSignalsIsLightImpulseActive = true
            if MorsePathLearnSignalsUsesFlashlight {
                MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsSetTorch(
                    MorsePathLearnSignalsIsOn: true
                )
            }
            if MorsePathLearnSignalsUsesSound {
                MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
                    String(MorsePathLearnSignalsCharacter),
                    speed: MorsePathLearnSignalsSpeed
                )
            }
            await MorsePathLearnSignalsSleep(MorsePathLearnSignalsDuration)
            MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
            MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsSetTorch(
                MorsePathLearnSignalsIsOn: false
            )
            MorsePathLearnSignalsIsLightImpulseActive = false
            await MorsePathLearnSignalsSleep(MorsePathLearnSignalsUnit)
        case " ":
            await MorsePathLearnSignalsSleep(MorsePathLearnSignalsUnit * 2)
        case "/":
            await MorsePathLearnSignalsSleep(MorsePathLearnSignalsUnit * 4)
        default:
            break
        }
    }

    private func MorsePathLearnSignalsSleep(_ MorsePathLearnSignalsDuration: TimeInterval) async {
        let MorsePathLearnSignalsNanoseconds = UInt64(
            max(0, MorsePathLearnSignalsDuration) * 1_000_000_000
        )
        try? await Task.sleep(nanoseconds: MorsePathLearnSignalsNanoseconds)
    }

    private func MorsePathLearnSignalsEnableFlashlightIfAvailable() {
        guard MorsePathLearnSignalsFlashlightServiceInstance
            .MorsePathLearnSignalsIsFlashlightAvailable() else {
            MorsePathLearnSignalsUsesFlashlight = false
            MorsePathLearnSignalsSaveSettings()
            MorsePathLearnSignalsActiveAlert = .flashlightUnavailable
            return
        }
        MorsePathLearnSignalsUsesFlashlight = true
        MorsePathLearnSignalsSaveSettings()
    }

    private func MorsePathLearnSignalsSaveSettings() {
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsUsesFlashlight,
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsUsesFlashlight
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsUsesSound,
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsUsesSound
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsRepeats,
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsRepeats
        )
        MorsePathLearnSignalsDefaults.set(
            MorsePathLearnSignalsSpeed.rawValue,
            forKey: MorsePathLearnSignalsSettingsKey.MorsePathLearnSignalsSpeed
        )
    }
}
