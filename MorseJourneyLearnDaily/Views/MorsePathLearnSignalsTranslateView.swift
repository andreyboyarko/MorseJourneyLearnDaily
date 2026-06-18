import SwiftUI

struct MorsePathLearnSignalsTranslateView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsTranslateViewModel()

    var body: some View {
        NavigationStack {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 18) {
                        Picker(
                            "Translation mode",
                            selection: $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMode
                        ) {
                            ForEach(MorsePathLearnSignalsTranslationMode.allCases) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)

                        MorsePathLearnSignalsEditorView(
                            MorsePathLearnSignalsPlaceholder:
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMode == .textToMorse
                                ? "Enter text"
                                : "Enter Morse code",
                            MorsePathLearnSignalsText:
                                $MorsePathLearnSignalsViewModel.MorsePathLearnSignalsInput
                        )

                        MorsePathLearnSignalsCard {
                            if MorsePathLearnSignalsViewModel.MorsePathLearnSignalsResult.isEmpty {
                                MorsePathLearnSignalsEmptyStateView(
                                    MorsePathLearnSignalsIcon: "text.magnifyingglass",
                                    MorsePathLearnSignalsTitle: "Translation appears here",
                                    MorsePathLearnSignalsMessage:
                                        "Enter a message, then tap Translate."
                                )
                            } else {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Result")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                    Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsResult)
                                        .font(
                                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMode == .textToMorse
                                            ? .system(.title3, design: .monospaced, weight: .semibold)
                                            : .title3.weight(.semibold)
                                        )
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(minHeight: 110, alignment: .top)
                            }
                        }

                        Button {
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsTranslate()
                        } label: {
                            Label("Translate", systemImage: "arrow.left.arrow.right")
                        }
                        .buttonStyle(MorsePathLearnSignalsPrimaryButtonStyle())

                        HStack(spacing: 10) {
                            Button {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCopy()
                            } label: {
                                Label(
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsShowsCopiedConfirmation
                                        ? "Copied"
                                        : "Copy",
                                    systemImage:
                                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsShowsCopiedConfirmation
                                        ? "checkmark"
                                        : "doc.on.doc"
                                )
                            }
                            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                            .disabled(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsResult.isEmpty)

                            Button {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsClear()
                            } label: {
                                Label("Clear", systemImage: "xmark")
                            }
                            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Translate")
            .onChange(of: MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMode) { _ in
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsClear()
            }
        }
    }
}
