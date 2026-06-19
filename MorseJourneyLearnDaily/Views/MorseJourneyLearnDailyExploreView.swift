import SwiftUI

struct MorseJourneyLearnDailyExploreView: View {
    @StateObject private var MorseJourneyLearnDailyViewModel =
        MorseJourneyLearnDailyExploreViewModel()
    @State private var MorseJourneyLearnDailyShowsSettings = false

    var body: some View {
        NavigationView {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 16) {
                        MorseJourneyLearnDailyScoreRow(
                            MorseJourneyLearnDailyCorrect:
                                MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyCorrectAnswers,
                            MorseJourneyLearnDailyTotal:
                                MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyTotalAnswers,
                            MorseJourneyLearnDailyStreak:
                                MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyCurrentStreak
                        )

                        MorseJourneyLearnDailyCategoryFilter(
                            MorseJourneyLearnDailySelection:
                                $MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailySelectedCategory
                        )

                        if let MorseJourneyLearnDailyQuestion =
                            MorseJourneyLearnDailyViewModel
                            .MorseJourneyLearnDailyCurrentQuestion {
                            MorseJourneyLearnDailyQuestionCard(
                                MorseJourneyLearnDailyQuestion:
                                    MorseJourneyLearnDailyQuestion,
                                MorseJourneyLearnDailySelectedAnswer:
                                    MorseJourneyLearnDailyViewModel
                                    .MorseJourneyLearnDailySelectedAnswer,
                                MorseJourneyLearnDailyAnswerIsCorrect:
                                    MorseJourneyLearnDailyViewModel
                                    .MorseJourneyLearnDailyAnswerIsCorrect,
                                MorseJourneyLearnDailyAnswer: {
                                    MorseJourneyLearnDailyViewModel
                                        .MorseJourneyLearnDailyAnswer($0)
                                },
                                MorseJourneyLearnDailyNext: {
                                    MorseJourneyLearnDailyViewModel
                                        .MorseJourneyLearnDailyNextQuestion()
                                }
                            )
                        }

                        Button {
                            MorseJourneyLearnDailyViewModel
                                .MorseJourneyLearnDailyRestart()
                        } label: {
                            Label("Restart", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(
                            MorsePathLearnSignalsSecondaryButtonStyle()
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        MorseJourneyLearnDailyShowsSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $MorseJourneyLearnDailyShowsSettings) {
                MorseJourneyLearnDailySettingsView()
            }
        }
    }
}

private struct MorseJourneyLearnDailyScoreRow: View {
    let MorseJourneyLearnDailyCorrect: Int
    let MorseJourneyLearnDailyTotal: Int
    let MorseJourneyLearnDailyStreak: Int

    var body: some View {
        HStack(spacing: 10) {
            MorseJourneyLearnDailyScoreItem(
                MorseJourneyLearnDailyTitle: "Score",
                MorseJourneyLearnDailyValue:
                    "\(MorseJourneyLearnDailyCorrect) / \(MorseJourneyLearnDailyTotal)",
                MorseJourneyLearnDailyIcon: "checkmark.circle.fill"
            )
            MorseJourneyLearnDailyScoreItem(
                MorseJourneyLearnDailyTitle: "Streak",
                MorseJourneyLearnDailyValue:
                    "\(MorseJourneyLearnDailyStreak)",
                MorseJourneyLearnDailyIcon: "flame.fill"
            )
        }
    }
}

private struct MorseJourneyLearnDailyScoreItem: View {
    let MorseJourneyLearnDailyTitle: String
    let MorseJourneyLearnDailyValue: String
    let MorseJourneyLearnDailyIcon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: MorseJourneyLearnDailyIcon)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(MorseJourneyLearnDailyTitle)
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsCaption
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText
                    )
                Text(MorseJourneyLearnDailyValue)
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(18)
                    )
            }
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                    lineWidth: 1
                )
        }
    }
}

private struct MorseJourneyLearnDailyCategoryFilter: View {
    @Binding var MorseJourneyLearnDailySelection:
        MorseJourneyLearnDailyExploreCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MorseJourneyLearnDailyExploreCategory.allCases) {
                    MorseJourneyLearnDailyCategory in
                    Button {
                        MorseJourneyLearnDailySelection =
                            MorseJourneyLearnDailyCategory
                    } label: {
                        Label(
                            MorseJourneyLearnDailyCategory.rawValue,
                            systemImage:
                                MorseJourneyLearnDailyCategory
                                .MorseJourneyLearnDailyIcon
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsMedium(13)
                        )
                        .padding(.horizontal, 13)
                        .frame(minHeight: 40)
                        .foregroundStyle(
                            MorseJourneyLearnDailySelection
                                == MorseJourneyLearnDailyCategory
                            ? Color.white
                            : MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsPrimaryText
                        )
                        .background(
                            MorseJourneyLearnDailySelection
                                == MorseJourneyLearnDailyCategory
                            ? MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsPrimary
                            : MorsePathLearnSignalsTheme
                                .MorsePathLearnSignalsCard
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct MorseJourneyLearnDailyQuestionCard: View {
    let MorseJourneyLearnDailyQuestion:
        MorseJourneyLearnDailyExploreQuestion
    let MorseJourneyLearnDailySelectedAnswer: Bool?
    let MorseJourneyLearnDailyAnswerIsCorrect: Bool?
    let MorseJourneyLearnDailyAnswer: (Bool) -> Void
    let MorseJourneyLearnDailyNext: () -> Void

    var body: some View {
        MorsePathLearnSignalsCard {
            VStack(spacing: 18) {
                Label(
                    MorseJourneyLearnDailyQuestion.category.rawValue,
                    systemImage:
                        MorseJourneyLearnDailyQuestion.category
                        .MorseJourneyLearnDailyIcon
                )
                .font(
                    MorsePathLearnSignalsTypography
                        .MorsePathLearnSignalsCaption
                )
                .foregroundStyle(.tint)

                Text(MorseJourneyLearnDailyQuestion.statement)
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsDemiBold(22)
                    )
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 112)

                HStack(spacing: 12) {
                    MorseJourneyLearnDailyAnswerButton(
                        MorseJourneyLearnDailyTitle: "True",
                        MorseJourneyLearnDailyIcon: "checkmark",
                        MorseJourneyLearnDailyValue: true,
                        MorseJourneyLearnDailyCorrectValue:
                            MorseJourneyLearnDailyQuestion.isTrue,
                        MorseJourneyLearnDailySelectedAnswer:
                            MorseJourneyLearnDailySelectedAnswer,
                        MorseJourneyLearnDailyAction:
                            MorseJourneyLearnDailyAnswer
                    )
                    MorseJourneyLearnDailyAnswerButton(
                        MorseJourneyLearnDailyTitle: "False",
                        MorseJourneyLearnDailyIcon: "xmark",
                        MorseJourneyLearnDailyValue: false,
                        MorseJourneyLearnDailyCorrectValue:
                            MorseJourneyLearnDailyQuestion.isTrue,
                        MorseJourneyLearnDailySelectedAnswer:
                            MorseJourneyLearnDailySelectedAnswer,
                        MorseJourneyLearnDailyAction:
                            MorseJourneyLearnDailyAnswer
                    )
                }

                if let MorseJourneyLearnDailyIsCorrect =
                    MorseJourneyLearnDailyAnswerIsCorrect {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(
                            MorseJourneyLearnDailyIsCorrect
                            ? "Correct"
                            : "Wrong",
                            systemImage:
                                MorseJourneyLearnDailyIsCorrect
                                ? "checkmark.circle.fill"
                                : "xmark.circle.fill"
                        )
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsHeadline
                        )
                        .foregroundStyle(
                            MorseJourneyLearnDailyIsCorrect
                            ? Color.green
                            : Color.red
                        )

                        Text(MorseJourneyLearnDailyQuestion.explanation)
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsMedium(15)
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsSecondaryText
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(14)
                    .background(
                        (MorseJourneyLearnDailyIsCorrect
                            ? Color.green
                            : Color.red).opacity(0.1)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                    )

                    Button {
                        MorseJourneyLearnDailyNext()
                    } label: {
                        Label("Next", systemImage: "arrow.right")
                    }
                    .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())
                }
            }
        }
    }
}

private struct MorseJourneyLearnDailyAnswerButton: View {
    let MorseJourneyLearnDailyTitle: String
    let MorseJourneyLearnDailyIcon: String
    let MorseJourneyLearnDailyValue: Bool
    let MorseJourneyLearnDailyCorrectValue: Bool
    let MorseJourneyLearnDailySelectedAnswer: Bool?
    let MorseJourneyLearnDailyAction: (Bool) -> Void

    var body: some View {
        Button {
            MorseJourneyLearnDailyAction(MorseJourneyLearnDailyValue)
        } label: {
            Label(
                MorseJourneyLearnDailyTitle,
                systemImage: MorseJourneyLearnDailyIcon
            )
            .font(
                MorsePathLearnSignalsTypography
                    .MorsePathLearnSignalsHeadline
            )
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .background(MorseJourneyLearnDailyBackgroundColor)
            .foregroundStyle(MorseJourneyLearnDailyForegroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        MorseJourneyLearnDailyBorderColor,
                        lineWidth: 2
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(MorseJourneyLearnDailySelectedAnswer != nil)
    }

    private var MorseJourneyLearnDailyBackgroundColor: Color {
        guard MorseJourneyLearnDailySelectedAnswer != nil else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
        }
        if MorseJourneyLearnDailyValue == MorseJourneyLearnDailyCorrectValue {
            return Color.green.opacity(0.16)
        }
        if MorseJourneyLearnDailySelectedAnswer
            == MorseJourneyLearnDailyValue {
            return Color.red.opacity(0.14)
        }
        return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard
    }

    private var MorseJourneyLearnDailyForegroundColor: Color {
        guard MorseJourneyLearnDailySelectedAnswer != nil else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimaryText
        }
        if MorseJourneyLearnDailyValue == MorseJourneyLearnDailyCorrectValue {
            return .green
        }
        if MorseJourneyLearnDailySelectedAnswer
            == MorseJourneyLearnDailyValue {
            return .red
        }
        return MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
    }

    private var MorseJourneyLearnDailyBorderColor: Color {
        guard MorseJourneyLearnDailySelectedAnswer != nil else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder
        }
        if MorseJourneyLearnDailyValue == MorseJourneyLearnDailyCorrectValue {
            return .green
        }
        if MorseJourneyLearnDailySelectedAnswer
            == MorseJourneyLearnDailyValue {
            return .red
        }
        return MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder
    }
}
