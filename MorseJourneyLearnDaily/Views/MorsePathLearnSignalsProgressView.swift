import SwiftUI

struct MorsePathLearnSignalsProgressView: View {
    @ObservedObject private var MorsePathLearnSignalsProgressServiceInstance =
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsShared
    @State private var MorsePathLearnSignalsShowsResetConfirmation = false
    @State private var MorsePathLearnSignalsShowsSettings = false

    private let MorsePathLearnSignalsColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
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
                        }

                        MorsePathLearnSignalsCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Keep going", systemImage: "sparkles")
                                    .font(
                                        MorsePathLearnSignalsTypography
                                            .MorsePathLearnSignalsHeadline
                                    )
                                Text(
                                    MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsPracticeAttempts == 0
                                    ? "Complete your first Tap Practice check to begin building a streak."
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        MorsePathLearnSignalsShowsSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings")
                }
            }
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
                Text("Learned symbols and practice statistics will be permanently removed.")
            }
            .sheet(isPresented: $MorsePathLearnSignalsShowsSettings) {
                MorsePathLearnSignalsSettingsView()
            }
        }
    }

    private func MorsePathLearnSignalsLearnedCount(
        in MorsePathLearnSignalsDictionary: [String: String]
    ) -> Int {
        Set(MorsePathLearnSignalsDictionary.keys)
            .intersection(MorsePathLearnSignalsProgressServiceInstance.MorsePathLearnSignalsLearnedSymbols)
            .count
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

private struct MorsePathLearnSignalsSettingsView: View {
    @Environment(\.dismiss) private var MorsePathLearnSignalsDismiss

    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    LabeledContent("App", value: "Morse Path: Learn Signals!")
                    LabeledContent("Version", value: "1.0")
                }

                Section("Privacy") {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Works offline")
                            Text("No data is collected or shared.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "lock.shield.fill")
                            .foregroundStyle(.green)
                    }

                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Flashlight access")
                            Text("The camera is used only to control the flashlight. No photos or videos are captured.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "flashlight.on.fill")
                            .foregroundStyle(.tint)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        MorsePathLearnSignalsDismiss()
                    }
                }
            }
        }
    }
}
