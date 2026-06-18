import SwiftUI

struct MorsePathLearnSignalsTapView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsTapViewModel()
    @State private var MorsePathLearnSignalsPressStartedAt: Date?
    @State private var MorsePathLearnSignalsIsPressing = false

    var body: some View {
        NavigationStack {
            MorsePathLearnSignalsScreenBackground {
                ScrollView {
                    VStack(spacing: 20) {
                        MorsePathLearnSignalsCard {
                            VStack(spacing: 8) {
                                Label("Short tap = dot", systemImage: "circle.fill")
                                Label("Long press = dash", systemImage: "minus")
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ZStack {
                            Circle()
                                .fill(MorsePathLearnSignalsIsPressing ? Color.accentColor.opacity(0.75) : Color.accentColor)
                                .frame(width: 190, height: 190)
                                .shadow(color: Color.accentColor.opacity(0.25), radius: 18, y: 8)
                            VStack(spacing: 8) {
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 38))
                                Text("Press / Hold")
                                    .font(.headline)
                            }
                            .foregroundStyle(.white)
                        }
                        .contentShape(Circle())
                        .scaleEffect(MorsePathLearnSignalsIsPressing ? 0.96 : 1)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if MorsePathLearnSignalsPressStartedAt == nil {
                                        MorsePathLearnSignalsPressStartedAt = Date()
                                        MorsePathLearnSignalsIsPressing = true
                                    }
                                }
                                .onEnded { _ in
                                    let MorsePathLearnSignalsDuration =
                                        Date().timeIntervalSince(
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
                        .animation(.easeOut(duration: 0.12), value: MorsePathLearnSignalsIsPressing)

                        MorsePathLearnSignalsCard {
                            VStack(spacing: 14) {
                                Text(
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsInput.isEmpty
                                        ? "Your signal"
                                        : MorsePathLearnSignalsViewModel.MorsePathLearnSignalsInput
                                )
                                .font(.system(size: 38, weight: .bold, design: .monospaced))
                                .foregroundStyle(
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsInput.isEmpty
                                        ? .secondary
                                        : .primary
                                )
                                .frame(minHeight: 50)

                                Divider()

                                Text("Recognized symbol")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsRecognizedSymbol)
                                    .font(.largeTitle.bold())
                            }
                        }

                        if !MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackMessage.isEmpty {
                            Label(
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackMessage,
                                systemImage:
                                    MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackIsSuccess == true
                                    ? "checkmark.circle.fill"
                                    : "exclamationmark.circle.fill"
                            )
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsFeedbackIsSuccess == true
                                    ? Color.green
                                    : Color.orange
                            )
                        }

                        HStack(spacing: 10) {
                            Button("Clear") {
                                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsClear()
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
                    .padding()
                }
            }
            .navigationTitle("Tap Practice")
        }
    }
}
