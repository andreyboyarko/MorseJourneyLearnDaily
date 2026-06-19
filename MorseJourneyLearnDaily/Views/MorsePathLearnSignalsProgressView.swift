import SwiftUI

struct MorsePathLearnSignalsProgressView: View {
    @ObservedObject private var MorsePathLearnSignalsProgressServiceInstance =
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsShared
    @State private var MorsePathLearnSignalsShowsResetConfirmation = false

    private let MorsePathLearnSignalsColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        MorsePathLearnSignalsScreenBackground {
            ScrollView {
                VStack(spacing: 18) {
                        LazyVGrid(columns: MorsePathLearnSignalsColumns, spacing: 12) {
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Letters Learned",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsLearnedCount(
                                        in: MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsLetters
                                    ),
                                MorsePathLearnSignalsTotal:
                                    MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsLetters.count,
                                MorsePathLearnSignalsIcon: "character.book.closed.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Numbers Learned",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsLearnedCount(
                                        in: MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsNumbers
                                    ),
                                MorsePathLearnSignalsTotal:
                                    MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsNumbers.count,
                                MorsePathLearnSignalsIcon: "number.square.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Practice Attempts",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsPracticeAttempts,
                                MorsePathLearnSignalsIcon: "hand.tap.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Correct Attempts",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsCorrectAttempts,
                                MorsePathLearnSignalsIcon: "checkmark.circle.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Mistakes",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsMistakes,
                                MorsePathLearnSignalsIcon: "arrow.counterclockwise.circle.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Best Streak",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsBestStreak,
                                MorsePathLearnSignalsIcon: "flame.fill"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Quiz Sessions",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsProgressServiceInstance
                                    .MorsePathLearnSignalsCompletedQuizSessions,
                                MorsePathLearnSignalsIcon: "brain.head.profile"
                            )
                            MorsePathLearnSignalsMetricCard(
                                MorsePathLearnSignalsTitle: "Best Quiz Score",
                                MorsePathLearnSignalsValue:
                                    MorsePathLearnSignalsBestQuizScore,
                                MorsePathLearnSignalsTotal: 10,
                                MorsePathLearnSignalsIcon: "trophy.fill"
                            )
                        }

                        MorsePathLearnSignalsDifficultSymbolsCard(
                            MorsePathLearnSignalsSymbols:
                                Array(
                                    MorsePathLearnSignalsProgressServiceInstance
                                        .MorsePathLearnSignalsMostDifficultQuizSymbols
                                        .prefix(5)
                                )
                        )

                        MorsePathLearnSignalsCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Keep going", systemImage: "sparkles")
                                    .font(
                                        MorsePathLearnSignalsTypography
                                            .MorsePathLearnSignalsHeadline
                                    )
                                Text(
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsPracticeAttempts == 0
                                        && MorsePathLearnSignalsProgressServiceInstance
                                            .MorsePathLearnSignalsCompletedQuizSessions == 0
                                    ? "Complete your first practice or quiz session to begin building progress."
                                    : "A little practice every day makes signals feel natural."
                                )
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsMedium(15)
                                )
                                .foregroundStyle(
                                    MorsePathLearnSignalsTheme
                                        .MorsePathLearnSignalsSecondaryText
                                )
                            }
                        }

                        Button(role: .destructive) {
                            MorsePathLearnSignalsShowsResetConfirmation = true
                        } label: {
                            Label("Reset Progress", systemImage: "trash")
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsHeadline
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                }
                .padding()
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Reset all progress?",
            isPresented: $MorsePathLearnSignalsShowsResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Progress", role: .destructive) {
                MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsResetProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Learned symbols, practice statistics, and quiz results will be permanently removed.")
        }
    }

    private func MorsePathLearnSignalsLearnedCount(
        in MorsePathLearnSignalsDictionary: [String: String]
    ) -> Int {
        Set(MorsePathLearnSignalsDictionary.keys)
            .intersection(MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsLearnedSymbols)
            .count
    }

    private var MorsePathLearnSignalsBestQuizScore: Int {
        MorsePathLearnSignalsProgressServiceInstance
            .MorsePathLearnSignalsQuizBestScores.values.max() ?? 0
    }
}

private struct MorsePathLearnSignalsMetricCard: View {
    let MorsePathLearnSignalsTitle: String
    let MorsePathLearnSignalsValue: Int
    var MorsePathLearnSignalsTotal: Int?
    let MorsePathLearnSignalsIcon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: MorsePathLearnSignalsIcon)
                .font(.title2)
                .foregroundStyle(.tint)
            Text(
                MorsePathLearnSignalsTotal.map {
                    "\(MorsePathLearnSignalsValue) / \($0)"
                } ?? "\(MorsePathLearnSignalsValue)"
            )
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsDemiBold(22))
            Text(MorsePathLearnSignalsTitle)
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsCaption)
                .foregroundStyle(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
                )
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
        .padding(16)
        .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder, lineWidth: 1)
        }
    }
}

private struct MorsePathLearnSignalsDifficultSymbolsCard: View {
    let MorsePathLearnSignalsSymbols: [(String, Int)]

    var body: some View {
        MorsePathLearnSignalsCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Needs more practice", systemImage: "target")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsHeadline
                    )

                if MorsePathLearnSignalsSymbols.isEmpty {
                    Text(
                        "Quiz mistakes will appear here so you know what to review."
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(15)
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText
                    )
                } else {
                    ForEach(
                        Array(MorsePathLearnSignalsSymbols.enumerated()),
                        id: \.offset
                    ) { MorsePathLearnSignalsIndex, MorsePathLearnSignalsEntry in
                        HStack {
                            Text(MorsePathLearnSignalsEntry.0)
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsDemiBold(22)
                                )
                                .frame(width: 36, alignment: .leading)
                            Text(
                                MorsePathLearnSignalsMorseDictionary
                                    .MorsePathLearnSignalsAll[
                                        MorsePathLearnSignalsEntry.0
                                    ] ?? ""
                            )
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold,
                                    design: .monospaced
                                )
                            )
                            Spacer()
                            Text(
                                "\(MorsePathLearnSignalsEntry.1) \(MorsePathLearnSignalsEntry.1 == 1 ? "mistake" : "mistakes")"
                            )
                            .font(
                                MorsePathLearnSignalsTypography
                                    .MorsePathLearnSignalsCaption
                            )
                            .foregroundStyle(
                                MorsePathLearnSignalsTheme
                                    .MorsePathLearnSignalsSecondaryText
                            )
                        }

                        if MorsePathLearnSignalsIndex
                            < MorsePathLearnSignalsSymbols.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}
