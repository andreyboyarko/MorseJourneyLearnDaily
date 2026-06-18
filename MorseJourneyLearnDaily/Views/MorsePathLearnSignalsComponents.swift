import SwiftUI

struct MorsePathLearnSignalsScreenBackground<Content: View>: View {
    private let MorsePathLearnSignalsContent: Content

    init(@ViewBuilder MorsePathLearnSignalsContent: () -> Content) {
        self.MorsePathLearnSignalsContent = MorsePathLearnSignalsContent()
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            MorsePathLearnSignalsContent
        }
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
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct MorsePathLearnSignalsPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration MorsePathLearnSignalsConfiguration: Configuration) -> some View {
        MorsePathLearnSignalsConfiguration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.accentColor.opacity(MorsePathLearnSignalsConfiguration.isPressed ? 0.75 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(MorsePathLearnSignalsConfiguration.isPressed ? 0.98 : 1)
    }
}

struct MorsePathLearnSignalsSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration MorsePathLearnSignalsConfiguration: Configuration) -> some View {
        MorsePathLearnSignalsConfiguration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(MorsePathLearnSignalsTitle)
                .font(.headline)
            Text(MorsePathLearnSignalsMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
            }
            TextEditor(text: $MorsePathLearnSignalsText)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 112)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
