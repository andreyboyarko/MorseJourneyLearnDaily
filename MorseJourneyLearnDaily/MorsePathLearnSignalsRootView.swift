import SwiftUI

struct MorsePathLearnSignalsRootView: View {
    @StateObject private var MorsePathLearnSignalsSplashViewModelInstance =
        MorsePathLearnSignalsSplashViewModel()

    var body: some View {
        ZStack {
            TabView {
                MorsePathLearnSignalsLearnView()
                    .tabItem {
                        Label("Learn", systemImage: "book.fill")
                    }

                MorsePathLearnSignalsPracticeView()
                    .tabItem {
                        Label("Practice", systemImage: "hand.tap.fill")
                    }

                MorsePathLearnSignalsSignalView()
                    .tabItem {
                        Label("Signal", systemImage: "flashlight.on.fill")
                    }

                MorsePathLearnSignalsProgressView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
            }
            .tint(MorsePathLearnSignalsTheme.MorsePathLearnSignalsPrimary)

            if MorsePathLearnSignalsSplashViewModelInstance.MorsePathLearnSignalsIsVisible {
                MorsePathLearnSignalsSplashView(
                    MorsePathLearnSignalsViewModel:
                        MorsePathLearnSignalsSplashViewModelInstance
                )
                .zIndex(1)
            }
        }
        .onAppear {
            MorsePathLearnSignalsSplashViewModelInstance.MorsePathLearnSignalsStart()
        }
    }
}
