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

                MorsePathLearnSignalsQuizView()
                    .tabItem {
                        Label("Quiz", systemImage: "brain.head.profile")
                    }

                MorseJourneyLearnDailyTranslateView()
                    .tabItem {
                        Label("Translate", systemImage: "character.bubble.fill")
                    }

                MorsePathLearnSignalsSignalView()
                    .tabItem {
                        Label("Signal", systemImage: "flashlight.on.fill")
                    }

                MorseJourneyLearnDailyExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "lightbulb.fill")
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
