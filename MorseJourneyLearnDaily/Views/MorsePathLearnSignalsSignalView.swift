import SwiftUI

struct MorsePathLearnSignalsSignalView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsSignalViewModel()
    @State private var MorsePathLearnSignalsPulse = false
    @State private var MorsePathLearnSignalsShowsSettings = false

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 16) {
                        MorsePathLearnSignalsFlashlightHeroView(
                            MorsePathLearnSignalsIsEnabled:
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsUsesFlashlight,
                            MorsePathLearnSignalsIsActive:
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLightImpulseActive,
                            MorsePathLearnSignalsPulse: MorsePathLearnSignalsPulse
                        )

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
                                        .font(
                                            MorsePathLearnSignalsTypography
                                                .MorsePathLearnSignalsCaption
                                        )
                                        .foregroundStyle(
                                            MorsePathLearnSignalsTheme
                                                .MorsePathLearnSignalsSecondaryText
                                        )
                                    Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsPreview)
                                        .font(
                                            .system(
                                                size: 17,
                                                weight: .semibold,
                                                design: .monospaced
                                            )
                                        )
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(minHeight: 72, alignment: .top)
                            }
                        }

                        if MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsSignaling {
                            Label(
                                "Signal is transmitting",
                                systemImage: "dot.radiowaves.left.and.right"
                            )
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsDemiBold(15)
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary
                            )
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
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Signal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        MorsePathLearnSignalsShowsSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Signal Settings")
                }
            }
            .sheet(isPresented: $MorsePathLearnSignalsShowsSettings) {
                MorsePathLearnSignalsSignalSettingsView(
                    MorsePathLearnSignalsViewModel: MorsePathLearnSignalsViewModel
                )
            }
            .alert(
                MorsePathLearnSignalsAlertTitle,
                isPresented: MorsePathLearnSignalsAlertIsPresented
            ) {
                MorsePathLearnSignalsAlertButtons
            } message: {
                Text(MorsePathLearnSignalsAlertMessage)
            }
            .onAppear {
                MorsePathLearnSignalsPulse = true
            }
            .onDisappear {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStop()
            }
        }
    }

    private var MorsePathLearnSignalsAlertIsPresented: Binding<Bool> {
        Binding(
            get: {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert != nil
            },
            set: { MorsePathLearnSignalsIsPresented in
                if !MorsePathLearnSignalsIsPresented {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert = nil
                }
            }
        )
    }

    private var MorsePathLearnSignalsAlertTitle: String {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .flashlightExplanation:
            return "Allow Flashlight Access"
        case .cameraDenied:
            return "Camera Access Needed"
        case .flashlightUnavailable:
            return "Flashlight Unavailable"
        default:
            return "Unable to Start"
        }
    }

    private var MorsePathLearnSignalsAlertMessage: String {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .emptyMessage:
            return "Enter a message before starting the signal."
        case .noOutput:
            return "Turn on flashlight, sound, or both."
        case .flashlightExplanation:
            return "Camera access is used only to control the flashlight. The app never captures photos or video."
        case .cameraDenied:
            return "Enable camera access in Settings to transmit Morse code with the flashlight."
        case .flashlightUnavailable:
            return "Flashlight is not available on this device."
        case nil:
            return ""
        }
    }

    @ViewBuilder
    private var MorsePathLearnSignalsAlertButtons: some View {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .flashlightExplanation:
            Button("Continue") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsConfirmFlashlightAccess()
            }
            Button("Not Now", role: .cancel) {}
        case .cameraDenied:
            Button("Open Settings") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsOpenSettings()
            }
            Button("Cancel", role: .cancel) {}
        default:
            Button("OK", role: .cancel) {}
        }
    }
}

private struct MorsePathLearnSignalsFlashlightHeroView: View {
    let MorsePathLearnSignalsIsEnabled: Bool
    let MorsePathLearnSignalsIsActive: Bool
    let MorsePathLearnSignalsPulse: Bool

    var body: some View {
        ZStack {
            if MorsePathLearnSignalsIsActive {
                Circle()
                    .fill(Color.yellow.opacity(0.24))
                    .frame(width: 210, height: 210)
                    .blur(radius: 18)
                    .scaleEffect(MorsePathLearnSignalsPulse ? 1.08 : 0.92)
                    .animation(
                        .easeInOut(duration: 0.55).repeatForever(autoreverses: true),
                        value: MorsePathLearnSignalsPulse
                    )
            }

            Image(
                MorsePathLearnSignalsIsEnabled
                    ? "morzeFlashlightOn"
                    : "morzeFlashlightOff"
            )
            .resizable()
            .scaledToFit()
            .frame(height: 205)
            .shadow(
                color: MorsePathLearnSignalsIsActive
                    ? Color.yellow.opacity(0.48)
                    : Color.black.opacity(0.12),
                radius: MorsePathLearnSignalsIsActive ? 24 : 10,
                y: 8
            )
        }
        .frame(maxWidth: .infinity, minHeight: 215)
        .accessibilityLabel(
            MorsePathLearnSignalsIsEnabled ? "Flashlight enabled" : "Flashlight disabled"
        )
    }
}

private struct MorsePathLearnSignalsSettingToggleRow: View {
    let MorsePathLearnSignalsTitle: String
    let MorsePathLearnSignalsSystemImage: String
    @Binding var MorsePathLearnSignalsIsOn: Bool

    var body: some View {
        Toggle(isOn: $MorsePathLearnSignalsIsOn) {
            Label(
                MorsePathLearnSignalsTitle,
                systemImage: MorsePathLearnSignalsSystemImage
            )
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(16))
        }
        .tint(MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary)
        .padding(.vertical, 12)
    }
}

private struct MorsePathLearnSignalsSignalSettingsView: View {
    @Environment(\.dismiss) private var MorsePathLearnSignalsDismiss
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsSignalViewModel

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    MorsePathLearnSignalsCard {
                        VStack(spacing: 0) {
                            MorsePathLearnSignalsSettingToggleRow(
                                MorsePathLearnSignalsTitle: "Flashlight",
                                MorsePathLearnSignalsSystemImage: "flashlight.on.fill",
                                MorsePathLearnSignalsIsOn: Binding(
                                    get: {
                                        MorsePathLearnSignalsViewModel
                                            .MorsePathLearnSignalsUsesFlashlight
                                    },
                                    set: {
                                        MorsePathLearnSignalsViewModel
                                            .MorsePathLearnSignalsFlashlightToggleRequested(
                                                MorsePathLearnSignalsNewValue: $0
                                            )
                                    }
                                )
                            )

                            Divider()

                            MorsePathLearnSignalsSettingToggleRow(
                                MorsePathLearnSignalsTitle: "Sound",
                                MorsePathLearnSignalsSystemImage: "speaker.wave.2.fill",
                                MorsePathLearnSignalsIsOn:
                                    $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsUsesSound
                            )

                            Divider()

                            MorsePathLearnSignalsSettingToggleRow(
                                MorsePathLearnSignalsTitle: "Repeat",
                                MorsePathLearnSignalsSystemImage: "repeat",
                                MorsePathLearnSignalsIsOn:
                                    $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsRepeats
                            )

                            Divider()

                            VStack(alignment: .leading, spacing: 12) {
                                Label("Speed", systemImage: "speedometer")
                                    .font(
                                        MorsePathLearnSignalsTypography
                                            .MorsePathLearnSignalsMedium(16)
                                    )
                                Picker(
                                    "Speed",
                                    selection:
                                        $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsSpeed
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
                    .padding()
                }
            }
            .navigationTitle("Signal Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        MorsePathLearnSignalsDismiss()
                    }
                }
            }
            .alert(
                MorsePathLearnSignalsAlertTitle,
                isPresented: MorsePathLearnSignalsAlertIsPresented
            ) {
                MorsePathLearnSignalsAlertButtons
            } message: {
                Text(MorsePathLearnSignalsAlertMessage)
            }
        }
    }

    private var MorsePathLearnSignalsAlertIsPresented: Binding<Bool> {
        Binding(
            get: {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert != nil
            },
            set: { MorsePathLearnSignalsIsPresented in
                if !MorsePathLearnSignalsIsPresented {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert = nil
                }
            }
        )
    }

    private var MorsePathLearnSignalsAlertTitle: String {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .flashlightExplanation:
            return "Allow Flashlight Access"
        case .cameraDenied:
            return "Camera Access Needed"
        case .flashlightUnavailable:
            return "Flashlight Unavailable"
        default:
            return "Signal Settings"
        }
    }

    private var MorsePathLearnSignalsAlertMessage: String {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .flashlightExplanation:
            return "Camera access is used only to control the flashlight. The app never captures photos or video."
        case .cameraDenied:
            return "Enable camera access in Settings to transmit Morse code with the flashlight."
        case .flashlightUnavailable:
            return "Flashlight is not available on this device."
        case .emptyMessage:
            return "Enter a message before starting the signal."
        case .noOutput:
            return "Turn on flashlight, sound, or both."
        case nil:
            return ""
        }
    }

    @ViewBuilder
    private var MorsePathLearnSignalsAlertButtons: some View {
        switch MorsePathLearnSignalsViewModel.MorsePathLearnSignalsActiveAlert {
        case .flashlightExplanation:
            Button("Continue") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsConfirmFlashlightAccess()
            }
            Button("Not Now", role: .cancel) {}
        case .cameraDenied:
            Button("Open Settings") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsOpenSettings()
            }
            Button("Cancel", role: .cancel) {}
        default:
            Button("OK", role: .cancel) {}
        }
    }
}
