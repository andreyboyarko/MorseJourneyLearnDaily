import Combine
import Foundation
import SwiftUI

final class MorsePathLearnSignalsSplashViewModel: ObservableObject {
    @Published private(set) var MorsePathLearnSignalsIsVisible = true
    @Published private(set) var MorsePathLearnSignalsActiveCharacterIndex: Int?
    @Published private(set) var MorsePathLearnSignalsIsLogoLit = false

    let MorsePathLearnSignalsMessage = ".... . .-.. .-.. --- -.-.--"

    private var MorsePathLearnSignalsAnimationTask: Task<Void, Never>?

    func MorsePathLearnSignalsStart() {
        guard MorsePathLearnSignalsAnimationTask == nil else { return }
        MorsePathLearnSignalsAnimationTask = Task { @MainActor [weak self] in
            guard let self else { return }
            let MorsePathLearnSignalsStartedAt = Date()

            for MorsePathLearnSignalsIndex in MorsePathLearnSignalsMessage.indices {
                guard !Task.isCancelled else { return }
                let MorsePathLearnSignalsCharacter =
                    MorsePathLearnSignalsMessage[MorsePathLearnSignalsIndex]
                let MorsePathLearnSignalsOffset =
                    MorsePathLearnSignalsMessage.distance(
                        from: MorsePathLearnSignalsMessage.startIndex,
                        to: MorsePathLearnSignalsIndex
                    )

                if MorsePathLearnSignalsCharacter == "." || MorsePathLearnSignalsCharacter == "-" {
                    MorsePathLearnSignalsActiveCharacterIndex = MorsePathLearnSignalsOffset
                    MorsePathLearnSignalsIsLogoLit = true
                    await MorsePathLearnSignalsSleep(
                        MorsePathLearnSignalsCharacter == "." ? 0.055 : 0.14
                    )
                    MorsePathLearnSignalsIsLogoLit = false
                    await MorsePathLearnSignalsSleep(0.025)
                } else {
                    MorsePathLearnSignalsActiveCharacterIndex = nil
                    await MorsePathLearnSignalsSleep(0.045)
                }
            }

            MorsePathLearnSignalsActiveCharacterIndex = nil
            MorsePathLearnSignalsIsLogoLit = false
            let MorsePathLearnSignalsElapsed = Date().timeIntervalSince(
                MorsePathLearnSignalsStartedAt
            )
            await MorsePathLearnSignalsSleep(max(0, 2.8 - MorsePathLearnSignalsElapsed))
            withAnimation(.easeInOut(duration: 0.35)) {
                self.MorsePathLearnSignalsIsVisible = false
            }
        }
    }

    private func MorsePathLearnSignalsSleep(_ MorsePathLearnSignalsDuration: TimeInterval) async {
        try? await Task.sleep(
            nanoseconds: UInt64(max(0, MorsePathLearnSignalsDuration) * 1_000_000_000)
        )
    }
}
