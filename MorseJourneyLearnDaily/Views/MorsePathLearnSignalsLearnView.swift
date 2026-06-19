import SwiftUI

struct MorsePathLearnSignalsLearnView: View {
    @StateObject private var MorsePathLearnSignalsViewModel =
        MorsePathLearnSignalsLearnViewModel()
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
                                MorsePathLearnSignalsAvailableHeight:
                                    MorsePathLearnSignalsGeometry.size.height,
                                MorsePathLearnSignalsUsesCompactLayout: false
                            )
                            .padding(.bottom, 16)
                        }
                    } else {
                        MorsePathLearnSignalsContent(
                            MorsePathLearnSignalsAvailableHeight:
                                MorsePathLearnSignalsGeometry.size.height,
                            MorsePathLearnSignalsUsesCompactLayout:
                                MorsePathLearnSignalsGeometry.size.height < 690
                        )
                    }
                }
            }
            .navigationTitle("Learn Morse")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsMarkCurrentAsLearned()
            }
            .onDisappear {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsStopAttemptTone()
            }
        }
    }

    private func MorsePathLearnSignalsContent(
        MorsePathLearnSignalsAvailableHeight: CGFloat,
        MorsePathLearnSignalsUsesCompactLayout: Bool
    ) -> some View {
        let MorsePathLearnSignalsSpacing: CGFloat =
            MorsePathLearnSignalsUsesCompactLayout ? 10 : 14
        let MorsePathLearnSignalsHorizontalPadding: CGFloat =
            MorsePathLearnSignalsUsesCompactLayout ? 12 : 16

        return VStack(spacing: MorsePathLearnSignalsSpacing) {
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

            MorsePathLearnSignalsLearningCard(
                MorsePathLearnSignalsViewModel:
                    MorsePathLearnSignalsViewModel,
                MorsePathLearnSignalsIsPressing:
                    MorsePathLearnSignalsIsPressing,
                MorsePathLearnSignalsUsesCompactLayout:
                    MorsePathLearnSignalsUsesCompactLayout,
                MorsePathLearnSignalsPressStartedAt:
                    $MorsePathLearnSignalsPressStartedAt,
                MorsePathLearnSignalsIsPressingBinding:
                    $MorsePathLearnSignalsIsPressing
            )
            .frame(
                maxHeight:
                    MorsePathLearnSignalsUsesCompactLayout
                    ? 385
                    : min(430, MorsePathLearnSignalsAvailableHeight * 0.61)
            )

            MorsePathLearnSignalsNavigationControls

            VStack(spacing: MorsePathLearnSignalsUsesCompactLayout ? 4 : 7) {
                ProgressView(
                    value: Double(
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsCurrentIndex + 1
                    ),
                    total: Double(
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsItems.count
                    )
                )
                Text(
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsPositionText
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

            if !MorsePathLearnSignalsSizeCategory.isAccessibilityCategory {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, MorsePathLearnSignalsHorizontalPadding)
        .padding(.top, MorsePathLearnSignalsUsesCompactLayout ? 6 : 10)
    }

    private var MorsePathLearnSignalsNavigationControls: some View {
        HStack(spacing: 8) {
            Button {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsShowPrevious()
            } label: {
                Label("Previous", systemImage: "chevron.left")
            }
            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
            .disabled(
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsCurrentIndex == 0
            )

            Button {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsPlayCurrentSound()
            } label: {
                Label("Play", systemImage: "speaker.wave.2.fill")
            }
            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())

            Button {
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsShowNext()
            } label: {
                Label("Next", systemImage: "chevron.right")
            }
            .buttonStyle(MorsePathLearnSignalsSecondaryButtonStyle())
            .disabled(
                MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsCurrentIndex
                    == MorsePathLearnSignalsViewModel
                    .MorsePathLearnSignalsItems.count - 1
            )
        }
    }
}

private struct MorsePathLearnSignalsLearningCard: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsLearnViewModel
    let MorsePathLearnSignalsIsPressing: Bool
    let MorsePathLearnSignalsUsesCompactLayout: Bool
    @Binding var MorsePathLearnSignalsPressStartedAt: Date?
    @Binding var MorsePathLearnSignalsIsPressingBinding: Bool

    var body: some View {
        VStack(spacing: MorsePathLearnSignalsUsesCompactLayout ? 9 : 13) {
            Text(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentItem
                    .MorsePathLearnSignalsSymbol
            )
            .font(
                MorsePathLearnSignalsTypography.MorsePathLearnSignalsDemiBold(
                    MorsePathLearnSignalsUsesCompactLayout ? 62 : 74
                )
            )
            .minimumScaleFactor(0.5)

            Text(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentItem
                    .MorsePathLearnSignalsCode
            )
            .font(
                .system(
                    size: MorsePathLearnSignalsUsesCompactLayout ? 29 : 34,
                    weight: .semibold,
                    design: .monospaced
                )
            )
            .foregroundStyle(.tint)

            Text(
                MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentItem
                    .MorsePathLearnSignalsSpokenCode
            )
            .font(
                MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(
                    MorsePathLearnSignalsUsesCompactLayout ? 15 : 17
                )
            )
            .foregroundStyle(
                MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText
            )

            Divider()

            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your attempt")
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
                            .MorsePathLearnSignalsAttempt.isEmpty
                        ? "—"
                        : MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsAttempt
                    )
                    .font(
                        .system(
                            size:
                                MorsePathLearnSignalsUsesCompactLayout
                                ? 24
                                : 28,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(MorsePathLearnSignalsAttemptColor)
                    .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                MorsePathLearnSignalsPressButton
            }

            if let MorsePathLearnSignalsIsCorrect =
                MorsePathLearnSignalsViewModel
                .MorsePathLearnSignalsAttemptIsCorrect {
                HStack(spacing: 8) {
                    Label(
                        MorsePathLearnSignalsIsCorrect
                        ? "Correct"
                        : "Try again · \(MorsePathLearnSignalsViewModel.MorsePathLearnSignalsCurrentItem.MorsePathLearnSignalsCode)",
                        systemImage:
                            MorsePathLearnSignalsIsCorrect
                            ? "checkmark.circle.fill"
                            : "xmark.circle.fill"
                    )
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(14)
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsIsCorrect
                        ? Color.green
                        : Color.red
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                    Spacer()

                    Button("Reset") {
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsResetAttempt()
                    }
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(14)
                    )
                    .frame(minWidth: 56, minHeight: 44)
                }
            } else {
                Text("Short tap = dot · Hold = dash")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsCaption
                    )
                    .foregroundStyle(
                        MorsePathLearnSignalsTheme
                            .MorsePathLearnSignalsSecondaryText.opacity(0.7)
                    )
                    .frame(minHeight: 44)
            }
        }
        .padding(MorsePathLearnSignalsUsesCompactLayout ? 16 : 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                    lineWidth: 1
                )
        }
    }

    private var MorsePathLearnSignalsPressButton: some View {
        ZStack {
            Circle()
                .fill(
                    MorsePathLearnSignalsTheme
                        .MorsePathLearnSignalsButtonGradient
                        .opacity(MorsePathLearnSignalsIsPressing ? 0.75 : 1)
                )
            VStack(spacing: 1) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 20))
                Text("Press / Hold")
                    .font(
                        MorsePathLearnSignalsTypography
                            .MorsePathLearnSignalsMedium(10)
                    )
            }
            .foregroundStyle(.white)
        }
        .frame(
            width: MorsePathLearnSignalsUsesCompactLayout ? 78 : 88,
            height: MorsePathLearnSignalsUsesCompactLayout ? 78 : 88
        )
        .contentShape(Circle())
        .scaleEffect(MorsePathLearnSignalsIsPressing ? 0.94 : 1)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if MorsePathLearnSignalsPressStartedAt == nil,
                       MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsAttemptIsCorrect == nil {
                        MorsePathLearnSignalsPressStartedAt = Date()
                        MorsePathLearnSignalsIsPressingBinding = true
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsStartAttemptTone()
                    }
                }
                .onEnded { _ in
                    guard let MorsePathLearnSignalsStartedAt =
                        MorsePathLearnSignalsPressStartedAt
                    else { return }
                    let MorsePathLearnSignalsDuration =
                        Date().timeIntervalSince(MorsePathLearnSignalsStartedAt)
                    MorsePathLearnSignalsPressStartedAt = nil
                    MorsePathLearnSignalsIsPressingBinding = false
                    MorsePathLearnSignalsViewModel
                        .MorsePathLearnSignalsStopAttemptTone()

                    if MorsePathLearnSignalsDuration >= 0.35 {
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsAddAttemptDash()
                    } else {
                        MorsePathLearnSignalsViewModel
                            .MorsePathLearnSignalsAddAttemptDot()
                    }
                }
        )
        .animation(
            .spring(response: 0.22, dampingFraction: 0.72),
            value: MorsePathLearnSignalsIsPressing
        )
        .accessibilityLabel(
            "Enter Morse code. Short tap for dot, hold for dash."
        )
    }

    private var MorsePathLearnSignalsAttemptColor: Color {
        guard let MorsePathLearnSignalsIsCorrect =
            MorsePathLearnSignalsViewModel
            .MorsePathLearnSignalsAttemptIsCorrect
        else {
            return MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimaryText
        }
        return MorsePathLearnSignalsIsCorrect ? .green : .red
    }
}
