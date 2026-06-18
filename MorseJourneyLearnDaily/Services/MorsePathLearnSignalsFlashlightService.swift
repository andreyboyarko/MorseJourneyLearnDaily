import AVFoundation
import Foundation

final class MorsePathLearnSignalsFlashlightService {
    private var MorsePathLearnSignalsWorkItem: DispatchWorkItem?

    func MorsePathLearnSignalsStartSignal(
        morse MorsePathLearnSignalsMorse: String,
        speed MorsePathLearnSignalsSpeed: MorsePathLearnSignalsSignalSpeed,
        repeatSignal MorsePathLearnSignalsRepeatSignal: Bool
    ) {
        MorsePathLearnSignalsStopSignal()

        let MorsePathLearnSignalsWorkItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            repeat {
                for MorsePathLearnSignalsCharacter in MorsePathLearnSignalsMorse {
                    if self.MorsePathLearnSignalsWorkItem?.isCancelled == true { return }
                    if MorsePathLearnSignalsCharacter == "." || MorsePathLearnSignalsCharacter == "-" {
                        let MorsePathLearnSignalsMultiplier: Double =
                            MorsePathLearnSignalsCharacter == "." ? 1 : 3
                        MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: true)
                        Thread.sleep(
                            forTimeInterval:
                                MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration
                                * MorsePathLearnSignalsMultiplier
                        )
                        MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: false)
                        Thread.sleep(
                            forTimeInterval: MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration
                        )
                    } else if MorsePathLearnSignalsCharacter == " " {
                        Thread.sleep(
                            forTimeInterval:
                                MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration * 2
                        )
                    } else if MorsePathLearnSignalsCharacter == "/" {
                        Thread.sleep(
                            forTimeInterval:
                                MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration * 4
                        )
                    }
                    if self.MorsePathLearnSignalsWorkItem?.isCancelled == true { return }
                }
                MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: false)
                if MorsePathLearnSignalsRepeatSignal {
                    Thread.sleep(
                        forTimeInterval:
                            MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration * 7
                    )
                }
            } while MorsePathLearnSignalsRepeatSignal
                && self.MorsePathLearnSignalsWorkItem?.isCancelled == false
        }

        self.MorsePathLearnSignalsWorkItem = MorsePathLearnSignalsWorkItem
        DispatchQueue.global(qos: .userInitiated).async(execute: MorsePathLearnSignalsWorkItem)
    }

    func MorsePathLearnSignalsStopSignal() {
        MorsePathLearnSignalsWorkItem?.cancel()
        MorsePathLearnSignalsWorkItem = nil
        MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: false)
    }

    func MorsePathLearnSignalsIsFlashlightAvailable() -> Bool {
        guard let MorsePathLearnSignalsDevice = AVCaptureDevice.default(for: .video) else {
            return false
        }
        return MorsePathLearnSignalsDevice.hasTorch && MorsePathLearnSignalsDevice.isTorchAvailable
    }

    private func MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: Bool) {
        guard let MorsePathLearnSignalsDevice = AVCaptureDevice.default(for: .video),
              MorsePathLearnSignalsDevice.hasTorch else { return }
        do {
            try MorsePathLearnSignalsDevice.lockForConfiguration()
            MorsePathLearnSignalsDevice.torchMode = MorsePathLearnSignalsIsOn ? .on : .off
            MorsePathLearnSignalsDevice.unlockForConfiguration()
        } catch {
            return
        }
    }
}
