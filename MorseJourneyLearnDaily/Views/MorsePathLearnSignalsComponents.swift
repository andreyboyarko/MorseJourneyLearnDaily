import SwiftUI

struct MorsePathLearnSignalsScreenBackground<Content: View>: View {
    private let MorsePathLearnSignalsContent: Content
    @Environment(\.colorScheme)
    private var MorseJourneyLearnDailyColorScheme

    init(@ViewBuilder MorsePathLearnSignalsContent: () -> Content) {
        self.MorsePathLearnSignalsContent = MorsePathLearnSignalsContent()
    }

    var body: some View {
        ZStack {
            MorsePathLearnSignalsTheme.MorsePathLearnSignalsBackgroundGradient
                .ignoresSafeArea()

            if MorseJourneyLearnDailyColorScheme == .dark {
                GeometryReader { MorseJourneyLearnDailyGeometry in
                    Circle()
                        .fill(Color(red: 0.302, green: 0.722, blue: 1))
                        .frame(width: 360, height: 360)
                        .blur(radius: 120)
                        .opacity(0.13)
                        .position(
                            x: MorseJourneyLearnDailyGeometry.size.width + 70,
                            y: 20
                        )

                    Circle()
                        .fill(Color(red: 0.216, green: 0.835, blue: 0.839))
                        .frame(width: 420, height: 420)
                        .blur(radius: 140)
                        .opacity(0.10)
                        .position(
                            x: -80,
                            y: MorseJourneyLearnDailyGeometry.size.height + 70
                        )
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }

            MorsePathLearnSignalsContent
        }
        .foregroundStyle(MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimaryText)
    }
}

struct MorsePathLearnSignalsCard<Content: View>: View {
    private let MorsePathLearnSignalsContent: Content

    init(@ViewBuilder MorsePathLearnSignalsContent: () -> Content) {
        self.MorsePathLearnSignalsContent = MorsePathLearnSignalsContent()
    }

    var body: some View {
        MorsePathLearnSignalsContent
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(MorsePathLearnSignalsCardShape)
            .overlay {
                MorsePathLearnSignalsCardShape
                    .stroke(
                        MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
            }
            .shadow(
                color: MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary.opacity(0.08),
                radius: 14,
                y: 8
            )
    }

    private var MorsePathLearnSignalsCardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
    }
}

struct MorsePathLearnSignalsPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration MorsePathLearnSignalsConfiguration: Configuration) -> some View {
        MorsePathLearnSignalsConfiguration.label
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsHeadline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                MorsePathLearnSignalsTheme.MorsePathLearnSignalsButtonGradient
                    .opacity(MorsePathLearnSignalsConfiguration.isPressed ? 0.75 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary.opacity(0.22),
                radius: 10,
                y: 6
            )
            .scaleEffect(MorsePathLearnSignalsConfiguration.isPressed ? 0.98 : 1)
    }
}

struct MorsePathLearnSignalsSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration MorsePathLearnSignalsConfiguration: Configuration) -> some View {
        MorsePathLearnSignalsConfiguration.label
            .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(15))
            .foregroundStyle(MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder,
                        lineWidth: 1
                    )
            }
            .opacity(MorsePathLearnSignalsConfiguration.isPressed ? 0.7 : 1)
    }
}

struct MorsePathLearnSignalsEmptyStateView: View {
    let MorsePathLearnSignalsIcon: String
    let MorsePathLearnSignalsTitle: String
    let MorsePathLearnSignalsMessage: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: MorsePathLearnSignalsIcon)
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsTitle)
                .foregroundStyle(MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText)
            Text(MorsePathLearnSignalsTitle)
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsHeadline)
            Text(MorsePathLearnSignalsMessage)
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsMedium(15))
                .foregroundStyle(MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 130)
    }
}

struct MorsePathLearnSignalsEditorView: View {
    let MorsePathLearnSignalsPlaceholder: String
    @Binding var MorsePathLearnSignalsText: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if MorsePathLearnSignalsText.isEmpty {
                Text(MorsePathLearnSignalsPlaceholder)
                    .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody)
                    .foregroundStyle(MorsePathLearnSignalsTheme.MorsePathLearnSignalsSecondaryText)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
            }
            TextEditor(text: $MorsePathLearnSignalsText)
                .font(MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody)
                .frame(minHeight: 112)
        }
        .padding(14)
        .background(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCard)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(MorsePathLearnSignalsTheme.MorsePathLearnSignalsCardBorder, lineWidth: 1)
        }
    }
}
