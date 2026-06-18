import AVFoundation
import Foundation
import UIKit

final class MorsePathLearnSignalsFlashlightService {
    func MorsePathLearnSignalsAuthorizationState() -> MorsePathLearnSignalsCameraAuthorizationState {
        MorsePathLearnSignalsCameraAuthorizationState(
            MorsePathLearnSignalsStatus: AVCaptureDevice.authorizationStatus(for: .video)
        )
    }

    func MorsePathLearnSignalsRequestCameraAccess() async -> Bool {
        await withCheckedContinuation { MorsePathLearnSignalsContinuation in
            AVCaptureDevice.requestAccess(for: .video) { MorsePathLearnSignalsGranted in
                MorsePathLearnSignalsContinuation.resume(returning: MorsePathLearnSignalsGranted)
            }
        }
    }

    func MorsePathLearnSignalsIsFlashlightAvailable() -> Bool {
        guard let MorsePathLearnSignalsDevice = AVCaptureDevice.default(for: .video) else {
            return false
        }
        return MorsePathLearnSignalsDevice.hasTorch && MorsePathLearnSignalsDevice.isTorchAvailable
    }

    @discardableResult
    func MorsePathLearnSignalsSetTorch(MorsePathLearnSignalsIsOn: Bool) -> Bool {
        guard let MorsePathLearnSignalsDevice = AVCaptureDevice.default(for: .video),
              MorsePathLearnSignalsDevice.hasTorch,
              MorsePathLearnSignalsDevice.isTorchAvailable else {
            return false
        }

        do {
            try MorsePathLearnSignalsDevice.lockForConfiguration()
            defer { MorsePathLearnSignalsDevice.unlockForConfiguration() }
            if MorsePathLearnSignalsIsOn {
                try MorsePathLearnSignalsDevice.setTorchModeOn(level: 1)
            } else {
                MorsePathLearnSignalsDevice.torchMode = .off
            }
            return true
        } catch {
            return false
        }
    }

    func MorsePathLearnSignalsOpenApplicationSettings() {
        guard let MorsePathLearnSignalsURL = URL(
            string: UIApplication.openSettingsURLString
        ) else { return }
        UIApplication.shared.open(MorsePathLearnSignalsURL)
    }
}
