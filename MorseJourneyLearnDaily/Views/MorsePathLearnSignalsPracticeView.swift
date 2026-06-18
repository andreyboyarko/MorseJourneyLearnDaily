import SwiftUI

struct MorsePathLearnSignalsPracticeView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsPracticeViewModel()
    @State private var MorsePathLearnSignalsPressStartedAt: Date?
    @State private var MorsePathLearnSignalsIsPressing = false
    @FocusState private var MorsePathLearnSignalsTranslationEditorIsFocused: Bool

    var body: some View {
        NavigationStack {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 16) {
                        MorsePathLearnSignalsTranslatorSection(
                            MorsePathLearnSignalsViewModel: MorsePathLearnSignalsViewModel,
                            MorsePathLearnSignalsTranslationEditorIsFocused:
                                $MorsePathLearnSignalsTranslationEditorIsFocused
                        )

                        MorsePathLearnSignalsTapInstructions
                        MorsePathLearnSignalsPressButton
                        MorsePathLearnSignalsRecognitionCard
                        MorsePathLearnSignalsFeedback
                        MorsePathLearnSignalsTapActions
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 104)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                MorsePathLearnSignalsInputDock(
                    MorsePathLearnSignalsAddDot: MorsePathLearnSignalsAddDot,
                    MorsePathLearnSignalsAddDash: MorsePathLearnSignalsAddDash
                )
            }
        }
    }

    private var MorsePathLearnSignalsTapInstructions: some View {
        MorsePathLearnSignalsCard {
            HStack(spacing: 18) {
                Label("Short tap = dot", systemImage: "circle.fill")
                Label("Long press = dash", systemImage: "minus")
            }
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(14))
            .foregroundStyle(
                MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
            )
            .frame(maxWidth: .infinity)
        }
    }

    private var MorsePathLearnSignalsPressButton: some View {
        ZStack {
            Circle()
                .fill(
                    MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsButtonGradient
                        .opacity(MorsePathLearnSignalsIsPressing ? 0.78 : 1)
                )
                .frame(width: 154, height: 154)
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.28), lineWidth: 2)
                }
                .shadow(
                    color: MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsPrimary.opacity(0.3),
                    radius: MorsePathLearnSignalsIsPressing ? 8 : 16,
                    y: 8
                )

            VStack(spacing: 5) {
                Image("MorzeHand")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                Text("Press / Hold")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(15)
                    )
            }
            .foregroundStyle(.white)
        }
        .contentShape(Circle())
        .scaleEffect(MorsePathLearnSignalsIsPressing ? 0.95 : 1)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if MorsePathLearnSignalsPressStartedAt == nil {
                        MorsePathLearnSignalsTranslationEditorIsFocused = false
                        MorsePathLearnSignalsPressStartedAt = Date()
                        MorsePathLearnSignalsIsPressing = true
                    }
                }
                .onEnded { _ in
                    let MorsePathLearnSignalsDuration = Date().timeIntervalSince(
                        MorsePathLearnSignalsPressStartedAt ?? Date()
                    )
                    MorsePathLearnSignalsIsPressing = false
                    MorsePathLearnSignalsPressStartedAt = nil
                    if MorsePathLearnSignalsDuration >= 0.35 {
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDash()
                    } else {
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDot()
                    }
                }
        )
        .animation(
            .spring(response: 0.22, dampingFraction: 0.7),
            value: MorsePathLearnSignalsIsPressing
        )
    }

    private var MorsePathLearnSignalsRecognitionCard: some View {
        MorsePathLearnSignalsCard {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Your signal")
                        .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsCaption)
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
                        )
                    Text(
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTapInput.isEmpty
                            ? "—"
                            : MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTapInput
                    )
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .frame(height: 54)

                VStack(alignment: .trailing, spacing: 5) {
                    Text("Symbol")
                        .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsCaption)
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
                        )
                    Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsRecognizedSymbol)
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(28)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    @ViewBuilder
    private var MorsePathLearnSignalsFeedback: some View {
        if !MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackMessage.isEmpty {
            Label(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackMessage,
                systemImage:
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackIsSuccess == true
                    ? "checkmark.circle.fill"
                    : "exclamationmark.circle.fill"
            )
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(14))
            .foregroundStyle(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackIsSuccess == true
                    ? Color.green
                    : Color.orange
            )
            .multilineTextAlignment(.center)
        }
    }

    private var MorsePathLearnSignalsTapActions: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Button("Clear") {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsClearTapInput()
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

                Button {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsDeleteLast()
                } label: {
                    Label("Delete", systemImage: "delete.left")
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
            }

            Button("Check") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCheck()
            }
            .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
        }
    }

    private func MorsePathLearnSignalsAddDot() {
        MorsePathLearnSignalsTranslationEditorIsFocused = false
        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDot()
    }

    private func MorsePathLearnSignalsAddDash() {
        MorsePathLearnSignalsTranslationEditorIsFocused = false
        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDash()
    }
}

private struct MorsePathLearnSignalsTranslatorSection: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsPracticeViewModel
    var MorsePathLearnSignalsTranslationEditorIsFocused: FocusState<Bool>.Binding

    var body: some View {
        VStack(spacing: 12) {
            Picker(
                "Translation mode",
                selection:
                    $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTranslationMode
            ) {
                ForEach(MorsePathLearnSignalsTranslationMode.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)

            ZStack(alignment: .topLeading) {
                if MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsTranslationInput.isEmpty {
                    Text(
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTranslationMode
                            == .textToMorse
                            ? "Enter text to use as a Morse guide"
                            : "Enter Morse code to decode"
                    )
                    .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody)
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
                    )
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
                }

                TextEditor(
                    text:
                        $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTranslationInput
                )
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody)
                .focused(MorsePathLearnSignalsTranslationEditorIsFocused)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 74, maxHeight: 96)
            }
            .padding(12)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
            }

            MorsePathLearnSignalsCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Live translation")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsCaption
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsSecondaryText
                            )

                        Spacer()

                        Button {
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsCopyTranslation()
                        } label: {
                            Image(
                                systemName:
                                    MorsePathLearnSignalsViewModel
                                        .MorsePathLearnSignalsShowsCopiedConfirmation
                                    ? "checkmark"
                                    : "doc.on.doc"
                            )
                        }
                        .disabled(
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsTranslationResult.isEmpty
                        )

                        Button {
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsClearTranslation()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }

                    if MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsTranslationResult.isEmpty {
                        Text("Translation appears here as you type.")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsMedium(15)
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsSecondaryText
                            )
                    } else {
                        Text(
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsTranslationResult
                        )
                        .font(
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsTranslationMode == .textToMorse
                            ? .system(.body, design: .monospaced, weight: .semibold)
                            : MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(18)
                        )
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(minHeight: 64, alignment: .top)
            }
        }
    }
}

private struct MorsePathLearnSignalsInputDock: View {
    let MorsePathLearnSignalsAddDot: () -> Void
    let MorsePathLearnSignalsAddDash: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            MorsePathLearnSignalsDockButton(
                MorsePathLearnSignalsTitle: ".",
                MorsePathLearnSignalsAccessibilityLabel: "Add dot",
                MorsePathLearnSignalsAction: MorsePathLearnSignalsAddDot
            )
            MorsePathLearnSignalsDockButton(
                MorsePathLearnSignalsTitle: "−",
                MorsePathLearnSignalsAccessibilityLabel: "Add dash",
                MorsePathLearnSignalsAction: MorsePathLearnSignalsAddDash
            )
        }
        .padding(.horizontal, 18)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

private struct MorsePathLearnSignalsDockButton: View {
    let MorsePathLearnSignalsTitle: String
    let MorsePathLearnSignalsAccessibilityLabel: String
    let MorsePathLearnSignalsAction: () -> Void

    var body: some View {
        Button(action: MorsePathLearnSignalsAction) {
            Text(MorsePathLearnSignalsTitle)
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsButtonGradient
                )
                .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                .shadow(
                    color: MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsPrimary.opacity(0.2),
                    radius: 8,
                    y: 4
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(MorsePathLearnSignalsAccessibilityLabel)
    }
}
