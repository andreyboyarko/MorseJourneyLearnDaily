import Foundation
import Combine
import SwiftUI
import UIKit

final class MorsePathLearnSignalsLearnViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsSelectedCategory: MorsePathLearnSignalsLearnCategory = .letters {
        didSet {
            MorsePathLearnSignalsCurrentIndex = 0
            MorsePathLearnSignalsMarkCurrentAsLearned()
        }
    }
    @Published private(set) var MorsePathLearnSignalsCurrentIndex = 0

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
        MorsePathLearnSignalsMarkCurrentAsLearned()
    }

    func MorsePathLearnSignalsShowNext() {
        guard MorsePathLearnSignalsCurrentIndex < MorsePathLearnSignalsItems.count - 1 else { return }
        MorsePathLearnSignalsCurrentIndex += 1
        MorsePathLearnSignalsMarkCurrentAsLearned()
    }

    func MorsePathLearnSignalsPlayCurrentSound() {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
            MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode,
            speed: .medium
        )
    }

    func MorsePathLearnSignalsMarkCurrentAsLearned() {
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveLearnedSymbol(
            MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsSymbol
        )
    }
}

final class MorsePathLearnSignalsTapViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsInput = ""
    @Published private(set) var MorsePathLearnSignalsFeedbackMessage = ""
    @Published private(set) var MorsePathLearnSignalsFeedbackIsSuccess: Bool?

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()
    private let MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService

    init(
        MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService =
            .MorsePathLearnSignalsShared
    ) {
        self.MorsePathLearnSignalsProgressService = MorsePathLearnSignalsProgressService
    }

    var MorsePathLearnSignalsRecognizedSymbol: String {
        guard !MorsePathLearnSignalsInput.isEmpty else { return "—" }
        return MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsSymbolForMorse(
            MorsePathLearnSignalsInput
        ) ?? "Unknown"
    }

    func MorsePathLearnSignalsAddDot() {
        MorsePathLearnSignalsAppend(".")
    }

    func MorsePathLearnSignalsAddDash() {
        MorsePathLearnSignalsAppend("-")
    }

    func MorsePathLearnSignalsDeleteLast() {
        guard !MorsePathLearnSignalsInput.isEmpty else { return }
        MorsePathLearnSignalsInput.removeLast()
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
    }

    func MorsePathLearnSignalsClear() {
        MorsePathLearnSignalsInput = ""
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
    }

    func MorsePathLearnSignalsCheck() {
        guard !MorsePathLearnSignalsInput.isEmpty else {
            MorsePathLearnSignalsFeedbackMessage = "Enter a Morse sequence first."
            MorsePathLearnSignalsFeedbackIsSuccess = false
            return
        }

        let MorsePathLearnSignalsIsCorrect =
            MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsSymbolForMorse(
                MorsePathLearnSignalsInput
            ) != nil
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsSaveAttempt(
            MorsePathLearnSignalsIsCorrect: MorsePathLearnSignalsIsCorrect
        )
        MorsePathLearnSignalsFeedbackIsSuccess = MorsePathLearnSignalsIsCorrect
        MorsePathLearnSignalsFeedbackMessage = MorsePathLearnSignalsIsCorrect
            ? "Valid signal. Nice work!"
            : "This sequence is not in the dictionary."
    }

    private func MorsePathLearnSignalsAppend(_ MorsePathLearnSignalsElement: Character) {
        guard MorsePathLearnSignalsInput.count < 8 else { return }
        MorsePathLearnSignalsInput.append(MorsePathLearnSignalsElement)
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

final class MorsePathLearnSignalsTranslateViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsMode: MorsePathLearnSignalsTranslationMode = .textToMorse
    @Published var MorsePathLearnSignalsInput = ""
    @Published private(set) var MorsePathLearnSignalsResult = ""
    @Published var MorsePathLearnSignalsShowsCopiedConfirmation = false

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()

    func MorsePathLearnSignalsTranslate() {
        let MorsePathLearnSignalsTrimmedInput = MorsePathLearnSignalsInput.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !MorsePathLearnSignalsTrimmedInput.isEmpty else {
            MorsePathLearnSignalsResult = ""
            return
        }

        switch MorsePathLearnSignalsMode {
        case .textToMorse:
            MorsePathLearnSignalsResult =
                MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsTextToMorse(
                    MorsePathLearnSignalsTrimmedInput
                )
        case .morseToText:
            MorsePathLearnSignalsResult =
                MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsMorseToText(
                    MorsePathLearnSignalsTrimmedInput
                )
        }
    }

    func MorsePathLearnSignalsCopy() {
        guard !MorsePathLearnSignalsResult.isEmpty else { return }
        UIPasteboard.general.string = MorsePathLearnSignalsResult
        MorsePathLearnSignalsShowsCopiedConfirmation = true
    }

    func MorsePathLearnSignalsClear() {
        MorsePathLearnSignalsInput = ""
        MorsePathLearnSignalsResult = ""
        MorsePathLearnSignalsShowsCopiedConfirmation = false
    }
}

final class MorsePathLearnSignalsSignalViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsMessage = ""
    @Published var MorsePathLearnSignalsUsesFlashlight = true
    @Published var MorsePathLearnSignalsUsesSound = true
    @Published var MorsePathLearnSignalsRepeats = false
    @Published var MorsePathLearnSignalsSpeed: MorsePathLearnSignalsSignalSpeed = .medium
    @Published private(set) var MorsePathLearnSignalsIsSignaling = false
    @Published var MorsePathLearnSignalsAlertMessage: String?

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()
    private let MorsePathLearnSignalsSoundServiceInstance = MorsePathLearnSignalsSoundService()
    private let MorsePathLearnSignalsFlashlightServiceInstance =
        MorsePathLearnSignalsFlashlightService()
    private var MorsePathLearnSignalsSoundTimer: Timer?

    var MorsePathLearnSignalsPreview: String {
        MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsTextToMorse(
            MorsePathLearnSignalsMessage
        )
    }

    func MorsePathLearnSignalsStart() {
        let MorsePathLearnSignalsMorse = MorsePathLearnSignalsPreview
        guard !MorsePathLearnSignalsMorse.isEmpty else {
            MorsePathLearnSignalsAlertMessage = "Enter a message before starting the signal."
            return
        }
        guard MorsePathLearnSignalsUsesFlashlight || MorsePathLearnSignalsUsesSound else {
            MorsePathLearnSignalsAlertMessage = "Turn on flashlight, sound, or both."
            return
        }
        if MorsePathLearnSignalsUsesFlashlight,
           !MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsIsFlashlightAvailable() {
            MorsePathLearnSignalsAlertMessage = "Flashlight is not available on this device."
            return
        }

        MorsePathLearnSignalsStop()
        MorsePathLearnSignalsIsSignaling = true

        if MorsePathLearnSignalsUsesFlashlight {
            MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsStartSignal(
                morse: MorsePathLearnSignalsMorse,
                speed: MorsePathLearnSignalsSpeed,
                repeatSignal: MorsePathLearnSignalsRepeats
            )
        }
        if MorsePathLearnSignalsUsesSound {
            MorsePathLearnSignalsPlaySoundCycle(MorsePathLearnSignalsMorse)
        }
    }

    func MorsePathLearnSignalsStop() {
        MorsePathLearnSignalsSoundTimer?.invalidate()
        MorsePathLearnSignalsSoundTimer = nil
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsStop()
        MorsePathLearnSignalsFlashlightServiceInstance.MorsePathLearnSignalsStopSignal()
        MorsePathLearnSignalsIsSignaling = false
    }

    private func MorsePathLearnSignalsPlaySoundCycle(_ MorsePathLearnSignalsMorse: String) {
        MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
            MorsePathLearnSignalsMorse,
            speed: MorsePathLearnSignalsSpeed
        )
        guard MorsePathLearnSignalsRepeats else { return }

        let MorsePathLearnSignalsCycleDuration =
            MorsePathLearnSignalsDuration(of: MorsePathLearnSignalsMorse)
        MorsePathLearnSignalsSoundTimer = Timer.scheduledTimer(
            withTimeInterval: MorsePathLearnSignalsCycleDuration,
            repeats: true
        ) { [weak self] _ in
            guard let self, MorsePathLearnSignalsIsSignaling else { return }
            MorsePathLearnSignalsSoundServiceInstance.MorsePathLearnSignalsPlayMorse(
                MorsePathLearnSignalsMorse,
                speed: MorsePathLearnSignalsSpeed
            )
        }
    }

    private func MorsePathLearnSignalsDuration(of MorsePathLearnSignalsMorse: String) -> TimeInterval {
        let MorsePathLearnSignalsUnit = MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration
        return MorsePathLearnSignalsMorse.reduce(0) { MorsePathLearnSignalsTotal, MorsePathLearnSignalsCharacter in
            switch MorsePathLearnSignalsCharacter {
            case ".": return MorsePathLearnSignalsTotal + 2 * MorsePathLearnSignalsUnit
            case "-": return MorsePathLearnSignalsTotal + 4 * MorsePathLearnSignalsUnit
            case " ": return MorsePathLearnSignalsTotal + 2 * MorsePathLearnSignalsUnit
            case "/": return MorsePathLearnSignalsTotal + 4 * MorsePathLearnSignalsUnit
            default: return MorsePathLearnSignalsTotal
            }
        } + 7 * MorsePathLearnSignalsUnit
    }
}
