import SwiftUI

struct MorsePathLearnSignalsLearnView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsLearnViewModel()

    var body: some View {
        NavigationStack {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 20) {
                        Picker(
                            "Category",
                            selection: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsSelectedCategory
                        ) {
                            ForEach(MorsePathLearnSignalsLearnCategory.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)

                        MorsePathLearnSignalsCard {
                            VStack(spacing: 18) {
                                Text(
                                    MorsePathLearnSignalsViewModel
                                        .MorsePathLearnSignalsCurrentItem
                                        .MorsePathLearnSignalsSymbol
                                )
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsDemiBold(92)
                                )
                                .minimumScaleFactor(0.5)

                                Text(
                                    MorsePathLearnSignalsViewModel
                                        .MorsePathLearnSignalsCurrentItem
                                        .MorsePathLearnSignalsCode
                                )
                                .font(.system(size: 42, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.tint)

                                Text(
                                    MorsePathLearnSignalsViewModel
                                        .MorsePathLearnSignalsCurrentItem
                                        .MorsePathLearnSignalsSpokenCode
                                )
                                .font(
                                    MorsePathLearnSignalsTypography
                                        .MorsePathLearnSignalsMedium(20)
                                )
                                .foregroundStyle(
                                    MorsePathLearnSignalsTheme
                                        .MorsePathLearnSignalsSecondaryText
                                )
                            }
                            .frame(minHeight: 300)
                        }

                        HStack(spacing: 10) {
                            Button {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsShowPrevious()
                            } label: {
                                Label("Previous", systemImage: "chevron.left")
                            }
                            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                            .disabled(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentIndex == 0)

                            Button {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsPlayCurrentSound()
                            } label: {
                                Label("Play", systemImage: "speaker.wave.2.fill")
                            }
                            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

                            Button {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsShowNext()
                            } label: {
                                Label("Next", systemImage: "chevron.right")
                            }
                            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                            .disabled(
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentIndex
                                    == MorsePathLearnSignalsViewModel.MorsePathLearnSignalsItems.count - 1
                            )
                        }

                        VStack(spacing: 8) {
                            ProgressView(
                                value: Double(
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentIndex + 1
                                ),
                                total: Double(
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsItems.count
                                )
                            )
                            Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsPositionText)
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
                    .padding()
                }
            }
            .navigationTitle("Learn Morse")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMarkCurrentAsLearned()
            }
        }
    }
}
