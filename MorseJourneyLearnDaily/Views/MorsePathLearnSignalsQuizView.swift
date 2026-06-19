import SwiftUI

struct MorsePathLearnSignalsQuizView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsQuizViewModel()

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                Group {
                    if let MorsePathLearnSignalsResult =
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsResult {
                        MorsePathLearnSignalsQuizResultView(
                            MorsePathLearnSignalsResult: MorsePathLearnSignalsResult,
                            MorsePathLearnSignalsTryAgain: {
                                MorsePathLearnSignalsViewModel
                                    .MorsePathLearnSignalsStartSession()
                            },
                            MorsePathLearnSignalsReturnToSetup: {
                                MorsePathLearnSignalsViewModel
                                    .MorsePathLearnSignalsReturnToSetup()
                            }
                        )
                    } else if MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsIsSessionActive {
                        MorsePathLearnSignalsQuizSessionView(
                            MorsePathLearnSignalsViewModel:
                                MorsePathLearnSignalsViewModel
                        )
                    } else {
                        MorsePathLearnSignalsQuizSetupView(
                            MorsePathLearnSignalsViewModel:
                                MorsePathLearnSignalsViewModel
                        )
                    }
                }
            }
            .navigationTitle("Quiz")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear {
            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStopAudio()
        }
    }
}

private struct MorsePathLearnSignalsQuizSetupView: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsQuizViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                MorsePathLearnSignalsCard {
                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.tint)
                        Text("Train your Morse skills")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsTitle
                            )
                        Text(
                            "Complete 10 offline questions and strengthen the symbols that need more practice."
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsMedium(15)
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )
                        .multilineTextAlignment(.center)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Category")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsHeadline
                        )
                    Picker(
                        "Category",
                        selection:
                            $MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsSelectedCategory
                    ) {
                        ForEach(MorsePathLearnSignalsLearnCategory.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Training mode")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsHeadline
                        )
                    ForEach(
                        MorsePathLearnSignalsQuizMode.allCases
                    ) { MorsePathLearnSignalsMode in
                        MorsePathLearnSignalsModeCard(
                            MorsePathLearnSignalsMode:
                                MorsePathLearnSignalsMode,
                            MorsePathLearnSignalsIsSelected:
                                MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsSelectedMode
                                == MorsePathLearnSignalsMode
                        ) {
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsSelectedMode =
                                MorsePathLearnSignalsMode
                        }
                    }
                }

                MorsePathLearnSignalsCard {
                    HStack {
                        Label("Best score", systemImage: "trophy.fill")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsHeadline
                            )
                        Spacer()
                        Text(
                            "\(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsBestScore) / 10"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(22)
                        )
                        .foregroundStyle(.tint)
                    }
                }

                Button {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsStartSession()
                } label: {
                    Label("Start Quiz", systemImage: "play.fill")
                }
                .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
            }
            .padding()
        }
    }
}

private struct MorsePathLearnSignalsModeCard: View {
    let MorsePathLearnSignalsMode: MorsePathLearnSignalsQuizMode
    let MorsePathLearnSignalsIsSelected: Bool
    let MorsePathLearnSignalsAction: () -> Void

    var body: some View {
        Button(action: MorsePathLearnSignalsAction) {
            HStack(spacing: 14) {
                Image(systemName: MorsePathLearnSignalsMode.MorsePathLearnSignalsIcon)
                    .font(.title2)
                    .foregroundStyle(.tint)
                    .frame(width: 34)
                VStack(alignment: .leading, spacing: 3) {
                    Text(MorsePathLearnSignalsMode.rawValue)
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsHeadline
                        )
                    Text(MorsePathLearnSignalsDescription)
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsCaption
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(
                    systemName:
                        MorsePathLearnSignalsIsSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundStyle(
                    MorsePathLearnSignalsIsSelected
                    ? MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary
                    : MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
                )
            }
            .padding(16)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        MorsePathLearnSignalsIsSelected
                        ? MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary
                        : MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                        lineWidth: MorsePathLearnSignalsIsSelected ? 2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    private var MorsePathLearnSignalsDescription: String {
        switch MorsePathLearnSignalsMode {
        case .mixed:
            return "Visual recognition, code entry, and listening."
        case .listening:
            return "Identify every symbol by sound."
        }
    }
}

private struct MorsePathLearnSignalsQuizSessionView: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsQuizViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                HStack {
                    Text(
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsQuestionPositionText
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsHeadline
                    )
                    Spacer()
                    Label(
                        "\(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCorrectAnswers)",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsHeadline
                    )
                    .foregroundStyle(.green)
                }

                Button {
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsReturnToSetup()
                } label: {
                    Label("End Quiz", systemImage: "xmark.circle")
                }
                .font(
                    MorsePathLearnSignalsTypography
                        .MorsePathLearnSignalsMedium(14)
                )
                .frame(maxWidth: .infinity, alignment: .trailing)

                ProgressView(
                    value:
                        MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsProgressValue
                )

                if let MorsePathLearnSignalsQuestion =
                    MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsCurrentQuestion {
                    MorsePathLearnSignalsQuestionCard(
                        MorsePathLearnSignalsQuestion:
                            MorsePathLearnSignalsQuestion,
                        MorsePathLearnSignalsReplaySound: {
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsReplaySound()
                        }
                    )

                    if MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType
                        == .enterCode {
                        MorsePathLearnSignalsCodeAnswerView(
                            MorsePathLearnSignalsViewModel:
                                MorsePathLearnSignalsViewModel,
                            MorsePathLearnSignalsQuestion:
                                MorsePathLearnSignalsQuestion
                        )
                    } else {
                        MorsePathLearnSignalsOptionsView(
                            MorsePathLearnSignalsViewModel:
                                MorsePathLearnSignalsViewModel,
                            MorsePathLearnSignalsQuestion:
                                MorsePathLearnSignalsQuestion
                        )
                    }

                    if MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsHasAnswered {
                        MorsePathLearnSignalsAnswerFeedback(
                            MorsePathLearnSignalsIsCorrect:
                                MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsAnswerWasCorrect == true,
                            MorsePathLearnSignalsQuestion:
                                MorsePathLearnSignalsQuestion
                        )

                        Button {
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsAdvance()
                        } label: {
                            Label(
                                MorsePathLearnSignalsViewModel
                                    .MorsePathLearnSignalsCurrentQuestionIndex == 9
                                ? "See Results"
                                : "Next",
                                systemImage: "arrow.right"
                            )
                        }
                        .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
}

private struct MorsePathLearnSignalsQuestionCard: View {
    let MorsePathLearnSignalsQuestion: MorsePathLearnSignalsQuizQuestion
    let MorsePathLearnSignalsReplaySound: () -> Void

    var body: some View {
        MorsePathLearnSignalsCard {
            VStack(spacing: 18) {
                Text(MorsePathLearnSignalsPrompt)
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(15)
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText
                    )
                    .multilineTextAlignment(.center)

                switch MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType {
                case .recognizeCode:
                    Text(
                        MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                            .MorsePathLearnSignalsCode
                    )
                    .font(
                        .system(
                            size: 48,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(.tint)
                case .enterCode:
                    Text(
                        MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
                            .MorsePathLearnSignalsSymbol
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(72)
                    )
                case .listening:
                    Button(action: MorsePathLearnSignalsReplaySound) {
                        VStack(spacing: 10) {
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .font(.system(size: 58))
                            Text("Play Again")
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsHeadline
                                )
                        }
                    }
                    .accessibilityLabel("Play Morse signal again")
                }
            }
            .frame(minHeight: 190)
        }
    }

    private var MorsePathLearnSignalsPrompt: String {
        switch MorsePathLearnSignalsQuestion.MorsePathLearnSignalsType {
        case .recognizeCode:
            return "Which symbol matches this Morse code?"
        case .enterCode:
            return "Enter the Morse code for this symbol."
        case .listening:
            return "Listen and choose the correct symbol."
        }
    }
}

private struct MorsePathLearnSignalsOptionsView: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsQuizViewModel
    let MorsePathLearnSignalsQuestion: MorsePathLearnSignalsQuizQuestion

    private let MorsePathLearnSignalsColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: MorsePathLearnSignalsColumns, spacing: 12) {
            ForEach(
                MorsePathLearnSignalsQuestion.MorsePathLearnSignalsOptions,
                id: \.self
            ) { MorsePathLearnSignalsOption in
                Button {
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsSelectAnswer(
                            MorsePathLearnSignalsOption
                        )
                } label: {
                    Text(MorsePathLearnSignalsOption)
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(28)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)
                        .background(
                            MorsePathLearnSignalsOptionBackground(
                                MorsePathLearnSignalsOption
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                        )
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                            .stroke(
                                MorsePathLearnSignalsOptionBorder(
                                    MorsePathLearnSignalsOption
                                ),
                                lineWidth: 2
                            )
                        }
                }
                .buttonStyle(.plain)
                .disabled(
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsHasAnswered
                )
            }
        }
    }

    private func MorsePathLearnSignalsOptionBackground(
        _ MorsePathLearnSignalsOption: String
    ) -> Color {
        guard MorsePathLearnSignalsViewModel.MorsePathLearnSignalsHasAnswered
        else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
        }
        if MorsePathLearnSignalsOption
            == MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
            .MorsePathLearnSignalsSymbol {
            return Color.green.opacity(0.16)
        }
        if MorsePathLearnSignalsOption
            == MorsePathLearnSignalsViewModel.MorsePathLearnSignalsSelectedAnswer {
            return Color.red.opacity(0.14)
        }
        return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
    }

    private func MorsePathLearnSignalsOptionBorder(
        _ MorsePathLearnSignalsOption: String
    ) -> Color {
        guard MorsePathLearnSignalsViewModel.MorsePathLearnSignalsHasAnswered
        else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder
        }
        if MorsePathLearnSignalsOption
            == MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem
            .MorsePathLearnSignalsSymbol {
            return .green
        }
        if MorsePathLearnSignalsOption
            == MorsePathLearnSignalsViewModel.MorsePathLearnSignalsSelectedAnswer {
            return .red
        }
        return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder
    }
}

private struct MorsePathLearnSignalsCodeAnswerView: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsQuizViewModel
    let MorsePathLearnSignalsQuestion: MorsePathLearnSignalsQuizQuestion

    var body: some View {
        VStack(spacing: 12) {
            Text(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsEnteredCode
                    .isEmpty
                ? "—"
                : MorsePathLearnSignalsViewModel.MorsePathLearnSignalsEnteredCode
            )
            .font(.system(size: 38, weight: .bold, design: .monospaced))
            .foregroundStyle(MorsePathLearnSignalsCodeColor)
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        MorsePathLearnSignalsCodeBorderColor,
                        lineWidth: 2
                    )
            }

            HStack(spacing: 12) {
                MorsePathLearnSignalsCodeButton(".") {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDot()
                }
                MorsePathLearnSignalsCodeButton("−") {
                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAddDash()
                }
                Button {
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsDeleteCodeElement()
                } label: {
                    Image(systemName: "delete.left.fill")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                }
                .buttonStyle(.bordered)
            }
            .disabled(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsHasAnswered
            )

            if !MorsePathLearnSignalsViewModel
                .MorsePathLearnSignalsHasAnswered {
                Button("Check Answer") {
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsSubmitCode()
                }
                .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
                .disabled(
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsEnteredCode.isEmpty
                )
            }
        }
    }

    private func MorsePathLearnSignalsCodeButton(
        _ MorsePathLearnSignalsTitle: String,
        action MorsePathLearnSignalsAction: @escaping () -> Void
    ) -> some View {
        Button(action: MorsePathLearnSignalsAction) {
            Text(MorsePathLearnSignalsTitle)
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .frame(maxWidth: .infinity)
                .frame(height: 58)
        }
        .buttonStyle(.bordered)
    }

    private var MorsePathLearnSignalsCodeColor: Color {
        guard MorsePathLearnSignalsViewModel.MorsePathLearnSignalsHasAnswered
        else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimaryText
        }
        return MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAnswerWasCorrect
            == true ? .green : .red
    }

    private var MorsePathLearnSignalsCodeBorderColor: Color {
        guard MorsePathLearnSignalsViewModel.MorsePathLearnSignalsHasAnswered
        else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder
        }
        return MorsePathLearnSignalsViewModel.MorsePathLearnSignalsAnswerWasCorrect
            == true ? .green : .red
    }
}

private struct MorsePathLearnSignalsAnswerFeedback: View {
    let MorsePathLearnSignalsIsCorrect: Bool
    let MorsePathLearnSignalsQuestion: MorsePathLearnSignalsQuizQuestion

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(
                systemName:
                    MorsePathLearnSignalsIsCorrect
                    ? "checkmark.circle.fill"
                    : "xmark.circle.fill"
            )
            VStack(alignment: .leading, spacing: 3) {
                Text(MorsePathLearnSignalsIsCorrect ? "Correct!" : "Not quite")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsHeadline
                    )
                if !MorsePathLearnSignalsIsCorrect {
                    Text(
                        "Correct answer: \(MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem.MorsePathLearnSignalsSymbol)  \(MorsePathLearnSignalsQuestion.MorsePathLearnSignalsItem.MorsePathLearnSignalsCode)"
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(14)
                    )
                }
            }
            Spacer()
        }
        .foregroundStyle(MorsePathLearnSignalsIsCorrect ? Color.green : Color.red)
        .padding(14)
        .background(
            (MorsePathLearnSignalsIsCorrect ? Color.green : Color.red)
                .opacity(0.1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct MorsePathLearnSignalsQuizResultView: View {
    let MorsePathLearnSignalsResult: MorsePathLearnSignalsQuizResult
    let MorsePathLearnSignalsTryAgain: () -> Void
    let MorsePathLearnSignalsReturnToSetup: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                MorsePathLearnSignalsCard {
                    VStack(spacing: 10) {
                        Image(systemName: MorsePathLearnSignalsResultIcon)
                            .font(.system(size: 52))
                            .foregroundStyle(.tint)
                        Text("Session Complete")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsTitle
                            )
                        Text(
                            "\(MorsePathLearnSignalsResult.MorsePathLearnSignalsCorrectAnswers) / \(MorsePathLearnSignalsResult.MorsePathLearnSignalsTotalQuestions)"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(42)
                        )
                        Text(
                            "\(MorsePathLearnSignalsResult.MorsePathLearnSignalsAccuracy)% accuracy"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsMedium(16)
                        )
                        .foregroundStyle(
                            MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsSecondaryText
                        )
                    }
                }

                if MorsePathLearnSignalsResult.MorsePathLearnSignalsMistakes.isEmpty {
                    MorsePathLearnSignalsCard {
                        Label(
                            "Perfect session — no mistakes!",
                            systemImage: "sparkles"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsHeadline
                        )
                        .foregroundStyle(.green)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Review mistakes")
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsHeadline
                            )
                        ForEach(
                            MorsePathLearnSignalsResult
                                .MorsePathLearnSignalsMistakes
                        ) { MorsePathLearnSignalsMistake in
                            HStack {
                                Text(
                                    MorsePathLearnSignalsMistake
                                        .MorsePathLearnSignalsSymbol
                                )
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsDemiBold(24)
                                )
                                .frame(width: 42)
                                Text(
                                    MorsePathLearnSignalsMistake
                                        .MorsePathLearnSignalsCode
                                )
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .semibold,
                                        design: .monospaced
                                    )
                                )
                                Spacer()
                                Text(
                                    "You: \(MorsePathLearnSignalsMistake.MorsePathLearnSignalsAnswer)"
                                )
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsCaption
                                )
                                .foregroundStyle(
                                    MorsePathLearnSignalsTheme
                                        .MorsePathLearnSignalsSecondaryText
                                )
                                .lineLimit(1)
                            }
                            .padding(14)
                            .background(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsCard
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                        }
                    }
                }

                Button {
                    MorsePathLearnSignalsTryAgain()
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())

                Button("Change Mode or Category") {
                    MorsePathLearnSignalsReturnToSetup()
                }
                .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
            }
            .padding()
        }
    }

    private var MorsePathLearnSignalsResultIcon: String {
        switch MorsePathLearnSignalsResult.MorsePathLearnSignalsCorrectAnswers {
        case 9...10: return "trophy.fill"
        case 6...8: return "star.circle.fill"
        default: return "arrow.up.heart.fill"
        }
    }
}
