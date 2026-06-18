import SwiftUI

struct MorsePathLearnSignalsSignalView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsSignalViewModel()

    var body: some View {
        NavigationStack {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 18) {
                        MorsePathLearnSignalsEditorView(
                            MorsePathLearnSignalsPlaceholder: "Enter message",
                            MorsePathLearnSignalsText:
                                $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMessage
                        )

                        MorsePathLearnSignalsCard {
                            if MorsePathLearnSignalsViewModel.MorsePathLearnSignalsPreview.isEmpty {
                                MorsePathLearnSignalsEmptyStateView(
                                    MorsePathLearnSignalsIcon: "waveform",
                                    MorsePathLearnSignalsTitle: "Signal preview",
                                    MorsePathLearnSignalsMessage:
                                        "Your message will appear here in Morse code."
                                )
                            } else {
                                VStack(alignment: .leading, spacing: 10) {
                                    Label("Morse preview", systemImage: "waveform")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                    Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsPreview)
                                        .font(.system(.body, design: .monospaced, weight: .semibold))
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(minHeight: 90, alignment: .top)
                            }
                        }

                        MorsePathLearnSignalsCard {
                            VStack(spacing: 0) {
                                Toggle(
                                    isOn: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsUsesFlashlight
                                ) {
                                    Label("Flashlight", systemImage: "flashlight.on.fill")
                                }
                                .padding(.vertical, 12)

                                Divider()

                                Toggle(
                                    isOn: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsUsesSound
                                ) {
                                    Label("Sound", systemImage: "speaker.wave.2.fill")
                                }
                                .padding(.vertical, 12)

                                Divider()

                                Toggle(
                                    isOn: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsRepeats
                                ) {
                                    Label("Repeat", systemImage: "repeat")
                                }
                                .padding(.vertical, 12)

                                Divider()

                                VStack(alignment: .leading, spacing: 10) {
                                    Label("Speed", systemImage: "speedometer")
                                    Picker(
                                        "Speed",
                                        selection: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsSpeed
                                    ) {
                                        ForEach(MorsePathLearnSignalsSignalSpeed.allCases) {
                                            Text($0.rawValue).tag($0)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .padding(.top, 14)
                            }
                        }

                        if MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsSignaling {
                            Label("Signal is transmitting", systemImage: "dot.radiowaves.left.and.right")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.tint)
                        }

                        Button {
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStart()
                        } label: {
                            Label("Start Signal", systemImage: "play.fill")
                        }
                        .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
                        .disabled(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsSignaling)

                        Button {
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStop()
                        } label: {
                            Label("Stop", systemImage: "stop.fill")
                        }
                        .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                        .disabled(!MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsSignaling)
                    }
                    .padding()
                }
            }
            .navigationTitle("Signal")
            .alert(
                "Unable to Start",
                isPresented: Binding(
                    get: {
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAlertMessage != nil
                    },
                    set: { MorsePathLearnSignalsIsPresented in
                        if !MorsePathLearnSignalsIsPresented {
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAlertMessage = nil
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAlertMessage ?? "")
            }
            .onDisappear {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStop()
            }
        }
    }
}
