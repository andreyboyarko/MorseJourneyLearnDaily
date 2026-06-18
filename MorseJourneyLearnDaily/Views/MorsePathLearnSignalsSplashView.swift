import SwiftUI

struct MorsePathLearnSignalsSplashView: View {
    @ObservedObject var MorsePathLearnSignalsViewModel:
        MorsePathLearnSignalsSplashViewModel

    var body: some View {
        ZStack {
            MorsePathLearnSignalsTheme.MorsePathLearnSignalsSplashGradient
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.34), lineWidth: 3)
                        .frame(width: 286, height: 286)
                        .scaleEffect(
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                                ? 1.08
                                : 1
                        )
                        .opacity(
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                                ? 1
                                : 0.58
                        )

                    Circle()
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 252, height: 252)

                    Image("morzeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 218, height: 218)
                        .scaleEffect(
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                                ? 1.06
                                : 0.96
                        )
                        .opacity(
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                                ? 1
                                : 0.68
                        )
                }
                .shadow(
                    color: Color.white.opacity(
                        MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                            ? 0.5
                            : 0.12
                    ),
                    radius: MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                        ? 28
                        : 10
                )
                .animation(
                    .easeInOut(duration: 0.08),
                    value: MorsePathLearnSignalsViewModel.MorsePathLearnSignalsIsLogoLit
                )

                VStack(spacing: 10) {
                    Text("HELLO!")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(26)
                        )
                    MorsePathLearnSignalsMorseMessageView(
                        MorsePathLearnSignalsMessage:
                            MorsePathLearnSignalsViewModel.MorsePathLearnSignalsMessage,
                        MorsePathLearnSignalsActiveIndex:
                            MorsePathLearnSignalsViewModel
                                .MorsePathLearnSignalsActiveCharacterIndex
                    )
                }
                .foregroundStyle(.white)

                Spacer()

                HStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Loading")
                        .font(
                            MorsePathLearnSignalsTypography
                                .MorsePathLearnSignalsDemiBold(17)
                        )
                }
                .foregroundStyle(.white)
                .padding(.bottom, 34)
            }
            .padding(.horizontal, 24)
        }
        .transition(.opacity.combined(with: .scale(scale: 1.03)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading Morse Path. Transmitting Hello in Morse code.")
    }
}

private struct MorsePathLearnSignalsMorseMessageView: View {
    let MorsePathLearnSignalsMessage: String
    let MorsePathLearnSignalsActiveIndex: Int?

    var body: some View {
        HStack(spacing: 1) {
            ForEach(
                Array(MorsePathLearnSignalsMessage.enumerated()),
                id: \.offset
            ) { MorsePathLearnSignalsIndex, MorsePathLearnSignalsCharacter in
                Text(String(MorsePathLearnSignalsCharacter))
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundStyle(
                        MorsePathLearnSignalsActiveIndex == MorsePathLearnSignalsIndex
                            ? Color.yellow
                            : Color.white.opacity(0.72)
                    )
                    .scaleEffect(
                        MorsePathLearnSignalsActiveIndex == MorsePathLearnSignalsIndex
                            ? 1.28
                            : 1
                    )
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.72)
        .animation(.easeOut(duration: 0.08), value: MorsePathLearnSignalsActiveIndex)
    }
}
