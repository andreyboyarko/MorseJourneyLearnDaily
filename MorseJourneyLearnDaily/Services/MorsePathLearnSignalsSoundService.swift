import AVFoundation
import Foundation

final class MorsePathLearnSignalsSoundService {
    private let MorsePathLearnSignalsAudioEngine = AVAudioEngine()
    private let MorsePathLearnSignalsPlayerNode = AVAudioPlayerNode()
    private var MorsePathLearnSignalsIsConfigured = false

    func MorsePathLearnSignalsPlayMorse(
        _ MorsePathLearnSignalsMorse: String,
        speed MorsePathLearnSignalsSpeed: MorsePathLearnSignalsSignalSpeed
    ) {
        MorsePathLearnSignalsStop()
        MorsePathLearnSignalsConfigureAudioIfNeeded()

        let MorsePathLearnSignalsFormat = MorsePathLearnSignalsAudioEngine.mainMixerNode.outputFormat(forBus: 0)
        let MorsePathLearnSignalsSampleRate = MorsePathLearnSignalsFormat.sampleRate
        let MorsePathLearnSignalsUnit = MorsePathLearnSignalsSpeed.MorsePathLearnSignalsUnitDuration
        let MorsePathLearnSignalsDurations = MorsePathLearnSignalsAudioDurations(
            for: MorsePathLearnSignalsMorse,
            unit: MorsePathLearnSignalsUnit
        )

        for MorsePathLearnSignalsDuration in MorsePathLearnSignalsDurations {
            guard let MorsePathLearnSignalsBuffer = MorsePathLearnSignalsMakeBuffer(
                duration: abs(MorsePathLearnSignalsDuration),
                sampleRate: MorsePathLearnSignalsSampleRate,
                format: MorsePathLearnSignalsFormat,
                isSilent: MorsePathLearnSignalsDuration < 0
            ) else { continue }
            MorsePathLearnSignalsPlayerNode.scheduleBuffer(MorsePathLearnSignalsBuffer)
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try MorsePathLearnSignalsAudioEngine.start()
            MorsePathLearnSignalsPlayerNode.play()
        } catch {
            MorsePathLearnSignalsStop()
        }
    }

    func MorsePathLearnSignalsStop() {
        MorsePathLearnSignalsPlayerNode.stop()
        MorsePathLearnSignalsAudioEngine.pause()
    }

    private func MorsePathLearnSignalsConfigureAudioIfNeeded() {
        guard !MorsePathLearnSignalsIsConfigured else { return }
        MorsePathLearnSignalsAudioEngine.attach(MorsePathLearnSignalsPlayerNode)
        let MorsePathLearnSignalsFormat = MorsePathLearnSignalsAudioEngine.mainMixerNode.outputFormat(forBus: 0)
        MorsePathLearnSignalsAudioEngine.connect(
            MorsePathLearnSignalsPlayerNode,
            to: MorsePathLearnSignalsAudioEngine.mainMixerNode,
            format: MorsePathLearnSignalsFormat
        )
        MorsePathLearnSignalsIsConfigured = true
    }

    private func MorsePathLearnSignalsAudioDurations(
        for MorsePathLearnSignalsMorse: String,
        unit MorsePathLearnSignalsUnit: TimeInterval
    ) -> [TimeInterval] {
        var MorsePathLearnSignalsDurations: [TimeInterval] = []
        for MorsePathLearnSignalsCharacter in MorsePathLearnSignalsMorse {
            switch MorsePathLearnSignalsCharacter {
            case ".":
                MorsePathLearnSignalsDurations += [MorsePathLearnSignalsUnit, -MorsePathLearnSignalsUnit]
            case "-":
                MorsePathLearnSignalsDurations += [3 * MorsePathLearnSignalsUnit, -MorsePathLearnSignalsUnit]
            case " ":
                MorsePathLearnSignalsDurations.append(-2 * MorsePathLearnSignalsUnit)
            case "/":
                MorsePathLearnSignalsDurations.append(-4 * MorsePathLearnSignalsUnit)
            default:
                continue
            }
        }
        return MorsePathLearnSignalsDurations
    }

    private func MorsePathLearnSignalsMakeBuffer(
        duration MorsePathLearnSignalsDuration: TimeInterval,
        sampleRate MorsePathLearnSignalsSampleRate: Double,
        format MorsePathLearnSignalsFormat: AVAudioFormat,
        isSilent MorsePathLearnSignalsIsSilent: Bool
    ) -> AVAudioPCMBuffer? {
        let MorsePathLearnSignalsFrameCount = AVAudioFrameCount(
            MorsePathLearnSignalsDuration * MorsePathLearnSignalsSampleRate
        )
        guard MorsePathLearnSignalsFrameCount > 0,
              let MorsePathLearnSignalsBuffer = AVAudioPCMBuffer(
                pcmFormat: MorsePathLearnSignalsFormat,
                frameCapacity: MorsePathLearnSignalsFrameCount
              ),
              let MorsePathLearnSignalsChannels = MorsePathLearnSignalsBuffer.floatChannelData
        else { return nil }

        MorsePathLearnSignalsBuffer.frameLength = MorsePathLearnSignalsFrameCount
        for MorsePathLearnSignalsFrame in 0..<Int(MorsePathLearnSignalsFrameCount) {
            let MorsePathLearnSignalsValue: Float = MorsePathLearnSignalsIsSilent
                ? 0
                : 0.18 * sin(
                    2 * .pi * 650 * Float(MorsePathLearnSignalsFrame) / Float(MorsePathLearnSignalsSampleRate)
                )
            for MorsePathLearnSignalsChannel in 0..<Int(MorsePathLearnSignalsFormat.channelCount) {
                MorsePathLearnSignalsChannels[MorsePathLearnSignalsChannel][MorsePathLearnSignalsFrame] =
                    MorsePathLearnSignalsValue
            }
        }
        return MorsePathLearnSignalsBuffer
    }
}
