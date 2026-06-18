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

final class MorsePathLearnSignalsPracticeViewModel: ObservableObject {
    @Published var MorsePathLearnSignalsTranslationMode:
        MorsePathLearnSignalsTranslationMode = .textToMorse {
        didSet {
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

    private let MorsePathLearnSignalsMorseServiceInstance = MorsePathLearnSignalsMorseService()
    private let MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService

    init(
        MorsePathLearnSignalsProgressService: MorsePathLearnSignalsProgressService =
            .MorsePathLearnSignalsShared
    ) {
        self.MorsePathLearnSignalsProgressService = MorsePathLearnSignalsProgressService
    }

    var MorsePathLearnSignalsTranslationResult: String {
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
        }
    }

    var MorsePathLearnSignalsRecognizedSymbol: String {
        guard !MorsePathLearnSignalsTapInput.isEmpty else { return "—" }
        return MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsSymbolForMorse(
            MorsePathLearnSignalsTapInput
        ) ?? "Unknown"
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

        let MorsePathLearnSignalsIsCorrect =
            MorsePathLearnSignalsMorseServiceInstance.MorsePathLearnSignalsSymbolForMorse(
                MorsePathLearnSignalsTapInput
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
        guard MorsePathLearnSignalsTapInput.count < 8 else { return }
        MorsePathLearnSignalsTapInput.append(MorsePathLearnSignalsElement)
        MorsePathLearnSignalsFeedbackMessage = ""
        MorsePathLearnSignalsFeedbackIsSuccess = nil
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
