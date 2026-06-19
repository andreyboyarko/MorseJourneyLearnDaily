import SwiftUI
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        MorsePathLearnSignalsTheme.MorsePathLearnSignalsConfigureNavigationAppearance()
        UITextView.appearance().backgroundColor = .clear

        let MorsePathLearnSignalsWindow = UIWindow(frame: UIScreen.main.bounds)
        MorsePathLearnSignalsWindow.rootViewController = UIHostingController(
            rootView: MorsePathLearnSignalsApp()
        )
        MorsePathLearnSignalsWindow.makeKeyAndVisible()
        window = MorsePathLearnSignalsWindow

        return true
    }
}
