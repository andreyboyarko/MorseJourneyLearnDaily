import SwiftUI

struct MorseJourneyLearnDailyTapView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsPracticeViewModel()
    @State private var MorsePathLearnSignalsPressStartedAt: Date?
    @State private var MorsePathLearnSignalsIsPressing = false
    @Environment(\.sizeCategory) private var MorsePathLearnSignalsSizeCategory

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                GeometryReader { MorsePathLearnSignalsGeometry in
                    if MorsePathLearnSignalsSizeCategory.isAccessibilityCategory {
                        ScrollView {
                            MorsePathLearnSignalsContent(
                                MorsePathLearnSignalsUsesCompactLayout: false
                            )
                            .padding(.bottom, 12)
                        }
                    } else {
                        MorsePathLearnSignalsContent(
                            MorsePathLearnSignalsUsesCompactLayout:
                                MorsePathLearnSignalsGeometry.size.height < 650
                        )
                    }
                }
            }
            .navigationTitle("Tap")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                MorsePathLearnSignalsInputDock(
                    MorsePathLearnSignalsAddDot: MorsePathLearnSignalsAddDot,
                    MorsePathLearnSignalsAddDash: MorsePathLearnSignalsAddDash
                )
            }
            .onDisappear {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsStopTapTone()
            }
        }
    }

    private func MorsePathLearnSignalsContent(
        MorsePathLearnSignalsUsesCompactLayout: Bool
    ) -> some View {
        VStack(spacing: MorsePathLearnSignalsUsesCompactLayout ? 8 : 11) {
            MorsePathLearnSignalsPressButton(
                MorsePathLearnSignalsUsesCompactLayout:
                    MorsePathLearnSignalsUsesCompactLayout
            )
            MorsePathLearnSignalsRecognitionCard(
                MorsePathLearnSignalsUsesCompactLayout:
                    MorsePathLearnSignalsUsesCompactLayout
            )
            MorsePathLearnSignalsFeedback
            MorsePathLearnSignalsTapActions

            if !MorsePathLearnSignalsSizeCategory.isAccessibilityCategory {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, MorsePathLearnSignalsUsesCompactLayout ? 12 : 16)
        .padding(.top, MorsePathLearnSignalsUsesCompactLayout ? 4 : 8)
    }

    private func MorsePathLearnSignalsPressButton(
        MorsePathLearnSignalsUsesCompactLayout: Bool
    ) -> some View {
        let MorsePathLearnSignalsDiameter: CGFloat =
            MorsePathLearnSignalsUsesCompactLayout ? 108 : 124

        return ZStack {
            Circle()
                .fill(
                    MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsButtonGradient
                        .opacity(MorsePathLearnSignalsIsPressing ? 0.78 : 1)
                )
                .frame(
                    width: MorsePathLearnSignalsDiameter,
                    height: MorsePathLearnSignalsDiameter
                )
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.28), lineWidth: 2)
                }
                .shadow(
                    color: MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsPrimary.opacity(0.3),
                    radius: MorsePathLearnSignalsIsPressing ? 6 : 10,
                    y: 5
                )

            VStack(spacing: 3) {
                Image("MorzeHand")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: MorsePathLearnSignalsUsesCompactLayout ? 38 : 46,
                        height: MorsePathLearnSignalsUsesCompactLayout ? 38 : 46
                    )
                Text("Press / Hold")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(
                                MorsePathLearnSignalsUsesCompactLayout ? 12 : 13
                            )
                    )
            }
            .foregroundStyle(.white)
        }
        .frame(
            width: MorsePathLearnSignalsDiameter,
            height: MorsePathLearnSignalsDiameter
        )
        .contentShape(Circle())
        .scaleEffect(MorsePathLearnSignalsIsPressing ? 0.95 : 1)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if MorsePathLearnSignalsPressStartedAt == nil {
                        MorsePathLearnSignalsPressStartedAt = Date()
                        MorsePathLearnSignalsIsPressing = true
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsStartTapTone()
                    }
                }
                .onEnded { _ in
                    let MorsePathLearnSignalsDuration = Date().timeIntervalSince(
                        MorsePathLearnSignalsPressStartedAt ?? Date()
                    )
                    MorsePathLearnSignalsIsPressing = false
                    MorsePathLearnSignalsPressStartedAt = nil
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsStopTapTone()
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

    private func MorsePathLearnSignalsRecognitionCard(
        MorsePathLearnSignalsUsesCompactLayout: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Your signal")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsCaption
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText
                    )
                Spacer()
                HStack(spacing: 8) {
                    Text("Translation")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsCaption
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )

                    Text(
                        MorsePathLearnSignalsViewModel
                            .MorseJourneyLearnDailyTapTranslation
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(22)
                    )
                    .foregroundStyle(.tint)
                    .frame(minWidth: 24)
                }
            }

            if MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTapInput.isEmpty {
                Text("—")
                    .font(
                        .system(
                            size:
                                MorsePathLearnSignalsUsesCompactLayout ? 26 : 30,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .frame(minHeight: 42)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(
                            .adaptive(
                                minimum:
                                    MorsePathLearnSignalsUsesCompactLayout
                                    ? 18
                                    : 22
                            ),
                            spacing: 4
                        )
                    ],
                    alignment: .leading,
                    spacing: 3
                ) {
                    ForEach(
                        Array(
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsTapInput.enumerated()
                        ),
                        id: \.offset
                    ) { MorsePathLearnSignalsIndex, MorsePathLearnSignalsElement in
                        let MorsePathLearnSignalsMatches =
                            MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsTapElementMatchesExpected(
                                at: MorsePathLearnSignalsIndex
                            )
                        VStack(spacing: 0) {
                            Text(String(MorsePathLearnSignalsElement))
                                .font(
                                    .system(
                                        size:
                                            MorsePathLearnSignalsUsesCompactLayout
                                            ? 25
                                            : 29,
                                        weight: .bold,
                                        design: .monospaced
                                    )
                                )
                                .foregroundStyle(
                                    MorsePathLearnSignalsMatches == nil
                                    ? MorsePathLearnSignalsTheme
                                        .MorsePathLearnSignalsPrimaryText
                                    : MorsePathLearnSignalsMatches == true
                                    ? Color.green
                                    : Color.red
                                )

                            Rectangle()
                                .fill(Color.red)
                                .frame(height: 2)
                                .opacity(
                                    MorsePathLearnSignalsMatches == false ? 1 : 0
                                )
                        }
                    }
                }
                .frame(minHeight: 42, alignment: .topLeading)
            }
        }
        .padding(MorsePathLearnSignalsUsesCompactLayout ? 13 : 16)
        .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                    lineWidth: 1
                )
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
        HStack(spacing: 8) {
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

            Button("Check") {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCheck()
            }
            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
        }
    }

    private func MorsePathLearnSignalsAddDot() {
        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDot()
    }

    private func MorsePathLearnSignalsAddDash() {
        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDash()
    }
}

struct MorseJourneyLearnDailyTranslateView: View {
    @StateObject private var MorseJourneyLearnDailyViewModel =
        MorsePathLearnSignalsPracticeViewModel()
    @FocusState private var MorseJourneyLearnDailyEditorIsFocused: Bool

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    MorsePathLearnSignalsTranslatorSection(
                        MorsePathLearnSignalsViewModel:
                            MorseJourneyLearnDailyViewModel,
                        MorsePathLearnSignalsTranslationEditorIsFocused:
                            $MorseJourneyLearnDailyEditorIsFocused,
                        MorsePathLearnSignalsUsesCompactLayout: false
                    )
                    .padding()
                }
            }
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                MorseJourneyLearnDailyViewModel
                    .MorseJourneyLearnDailyStopTapToText()
            }
        }
    }
}

private struct MorsePathLearnSignalsTranslatorSection: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsPracticeViewModel
    var MorsePathLearnSignalsTranslationEditorIsFocused: FocusState<Bool>.Binding
    let MorsePathLearnSignalsUsesCompactLayout: Bool

    var body: some View {
        VStack(spacing: MorsePathLearnSignalsUsesCompactLayout ? 7 : 9) {
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

            if MorsePathLearnSignalsViewModel
                .MorsePathLearnSignalsTranslationMode == .tapToText {
                MorseJourneyLearnDailyTapToTextSection(
                    MorseJourneyLearnDailyViewModel:
                        MorsePathLearnSignalsViewModel
                )
            } else {
                ZStack(alignment: .topLeading) {
                    if MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsTranslationInput.isEmpty {
                        Text(
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsTranslationMode
                                == .textToMorse
                                ? "Enter text to use as a Morse guide"
                                : "Enter Morse code to decode"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsBody
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                    }

                    TextEditor(
                        text:
                            $MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsTranslationInput
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsBody
                    )
                    .focused(
                        MorsePathLearnSignalsTranslationEditorIsFocused
                    )
                    .frame(
                        height:
                            MorsePathLearnSignalsUsesCompactLayout ? 54 : 66
                    )
                }
                .padding(
                    MorsePathLearnSignalsUsesCompactLayout ? 8 : 10
                )
                .background(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                    .stroke(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
                }

                VStack(alignment: .leading, spacing: 6) {
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
                            ? .system(size: 17, weight: .semibold, design: .monospaced)
                            : MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(18)
                        )
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(
                    MorsePathLearnSignalsUsesCompactLayout ? 11 : 14
                )
                .frame(
                    maxWidth: .infinity,
                    minHeight:
                        MorsePathLearnSignalsUsesCompactLayout ? 68 : 76,
                    alignment: .top
                )
                .background(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                    .stroke(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
                }
            }
        }
    }
}

private struct MorseJourneyLearnDailyTapToTextSection: View {
    @ObservedObject var MorseJourneyLearnDailyViewModel:
        MorsePathLearnSignalsPracticeViewModel
    @State private var MorseJourneyLearnDailyPressStartedAt: Date?
    @State private var MorseJourneyLearnDailyIsPressing = false

    var body: some View {
        VStack(spacing: 14) {
            MorsePathLearnSignalsCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Your message")
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
                            MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyCopyTapToText()
                        } label: {
                            Image(
                                systemName:
                                    MorseJourneyLearnDailyViewModel
                                    .MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation
                                    ? "checkmark"
                                    : "doc.on.doc"
                            )
                        }
                        .disabled(
                            MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyTapToTextResult.isEmpty
                        )
                    }

                    Text(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextResult.isEmpty
                        ? "Your tapped message appears here."
                        : MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextResult
                    )
                    .font(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextResult.isEmpty
                        ? MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(16)
                        : MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(25)
                    )
                    .foregroundStyle(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextResult.isEmpty
                        ? MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText
                        : MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsPrimaryText
                    )
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 72,
                        alignment: .topLeading
                    )
                    .textSelection(.enabled)
                }
            }

            HStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current letter")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsCaption
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )

                    Text(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextCode.isEmpty
                        ? "—"
                        : MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextCode
                    )
                    .font(
                        .system(
                            size: 34,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextHasError
                        ? Color.red
                        : MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsPrimaryText
                    )

                    if MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyTapToTextHasError {
                        Text("Unknown signal — edit or clear it.")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsCaption
                            )
                            .foregroundStyle(.red)
                    } else {
                        Text("Auto-commits after 0.8 seconds")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsCaption
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsSecondaryText
                            )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                MorseJourneyLearnDailyTapToTextPressButton
            }
            .padding(16)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
            }

            HStack(spacing: 8) {
                Button("Commit Letter") {
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyCommitTapToTextLetter()
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

                Button("Space") {
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyAddTapToTextSpace()
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
            }

            HStack(spacing: 8) {
                Button {
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyDeleteTapToText()
                } label: {
                    Label("Delete", systemImage: "delete.left")
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

                Button {
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyClearTapToText()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

                Button {
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyCopyTapToText()
                } label: {
                    Label(
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation
                        ? "Copied"
                        : "Copy",
                        systemImage:
                            MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyTapToTextShowsCopiedConfirmation
                            ? "checkmark"
                            : "doc.on.doc"
                    )
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                .disabled(
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyTapToTextResult.isEmpty
                )
            }
        }
    }

    private var MorseJourneyLearnDailyTapToTextPressButton: some View {
        ZStack {
            Circle()
                .fill(
                    MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsButtonGradient
                        .opacity(
                            MorseJourneyLearnDailyIsPressing ? 0.76 : 1
                        )
                )
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.28), lineWidth: 2)
                }

            VStack(spacing: 3) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 28))
                Text("Press / Hold")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(11)
                    )
            }
            .foregroundStyle(.white)
        }
        .frame(width: 112, height: 112)
        .contentShape(Circle())
        .scaleEffect(MorseJourneyLearnDailyIsPressing ? 0.95 : 1)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if MorseJourneyLearnDailyPressStartedAt == nil {
                        MorseJourneyLearnDailyPressStartedAt = Date()
                        MorseJourneyLearnDailyIsPressing = true
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyStartTapToTextTone()
                    }
                }
                .onEnded { _ in
                    guard let MorseJourneyLearnDailyStartedAt =
                        MorseJourneyLearnDailyPressStartedAt
                    else { return }

                    let MorseJourneyLearnDailyDuration =
                        Date().timeIntervalSince(
                            MorseJourneyLearnDailyStartedAt
                        )
                    MorseJourneyLearnDailyPressStartedAt = nil
                    MorseJourneyLearnDailyIsPressing = false
                    MorseJourneyLearnDailyViewModel
                        .MorseJourneyLearnDailyStopTapToTextTone()

                    if MorseJourneyLearnDailyDuration >= 0.35 {
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyAddTapToTextDash()
                    } else {
                        MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyAddTapToTextDot()
                    }
                }
        )
        .animation(
            .spring(response: 0.22, dampingFraction: 0.72),
            value: MorseJourneyLearnDailyIsPressing
        )
        .accessibilityLabel(
            "Tap to enter a dot. Hold to enter a dash."
        )
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
        .padding(.top, 7)
        .padding(.bottom, 6)
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
                .frame(height: 48)
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
