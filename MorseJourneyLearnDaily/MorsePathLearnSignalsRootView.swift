import SwiftUI

struct MorsePathLearnSignalsRootView: View {
    var body: some View {
        TabView {
            MorsePathLearnSignalsLearnView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }

            MorsePathLearnSignalsTapView()
                .tabItem {
                    Label("Tap", systemImage: "hand.tap.fill")
                }

            MorsePathLearnSignalsTranslateView()
                .tabItem {
                    Label("Translate", systemImage: "arrow.left.arrow.right")
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
        .tint(.accentColor)
    }
}
