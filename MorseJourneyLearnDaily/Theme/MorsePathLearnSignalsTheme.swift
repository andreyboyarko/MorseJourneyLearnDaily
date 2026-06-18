import SwiftUI
import UIKit

enum MorsePathLearnSignalsTheme {
    static let MorsePathLearnSignalsPrimary = Color("MorsePathLearnSignalsPrimary")
    static let MorsePathLearnSignalsSecondary = Color("MorsePathLearnSignalsSecondary")
    static let MorsePathLearnSignalsBackgroundTop = Color("MorsePathLearnSignalsBackgroundTop")
    static let MorsePathLearnSignalsBackgroundBottom = Color("MorsePathLearnSignalsBackgroundBottom")
    static let MorsePathLearnSignalsCard = Color("MorsePathLearnSignalsCard")
    static let MorsePathLearnSignalsCardBorder = Color("MorsePathLearnSignalsCardBorder")
    static let MorsePathLearnSignalsPrimaryText = Color("MorsePathLearnSignalsPrimaryText")
    static let MorsePathLearnSignalsSecondaryText = Color("MorsePathLearnSignalsSecondaryText")
    static let MorsePathLearnSignalsSplashTop = Color("MorsePathLearnSignalsSplashTop")
    static let MorsePathLearnSignalsSplashBottom = Color("MorsePathLearnSignalsSplashBottom")

    static var MorsePathLearnSignalsBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                MorsePathLearnSignalsBackgroundTop,
                MorsePathLearnSignalsBackgroundBottom
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var MorsePathLearnSignalsButtonGradient: LinearGradient {
        LinearGradient(
            colors: [
                MorsePathLearnSignalsPrimary,
                MorsePathLearnSignalsSecondary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var MorsePathLearnSignalsSplashGradient: LinearGradient {
        LinearGradient(
            colors: [
                MorsePathLearnSignalsSplashTop,
                MorsePathLearnSignalsSplashBottom
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static func MorsePathLearnSignalsConfigureNavigationAppearance() {
        let MorsePathLearnSignalsNavigationFont =
            UIFont(name: "AvenirNext-DemiBold", size: 17)
            ?? UIFont.boldSystemFont(ofSize: 17)
        let MorsePathLearnSignalsLargeNavigationFont =
            UIFont(name: "AvenirNext-DemiBold", size: 32)
            ?? UIFont.boldSystemFont(ofSize: 32)
        let MorsePathLearnSignalsAppearance = UINavigationBarAppearance()
        MorsePathLearnSignalsAppearance.configureWithTransparentBackground()
        MorsePathLearnSignalsAppearance.backgroundColor = UIColor.clear
        MorsePathLearnSignalsAppearance.shadowColor = UIColor.clear
        MorsePathLearnSignalsAppearance.titleTextAttributes = [
            .font: MorsePathLearnSignalsNavigationFont,
            .foregroundColor: UIColor(named: "MorsePathLearnSignalsPrimaryText") as Any
        ]
        MorsePathLearnSignalsAppearance.largeTitleTextAttributes = [
            .font: MorsePathLearnSignalsLargeNavigationFont,
            .foregroundColor: UIColor(named: "MorsePathLearnSignalsPrimaryText") as Any
        ]

        UINavigationBar.appearance().standardAppearance = MorsePathLearnSignalsAppearance
        UINavigationBar.appearance().compactAppearance = MorsePathLearnSignalsAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = MorsePathLearnSignalsAppearance
        UINavigationBar.appearance().tintColor = UIColor(
            named: "MorsePathLearnSignalsPrimary"
        )

        let MorsePathLearnSignalsTabAppearance = UITabBarAppearance()
        MorsePathLearnSignalsTabAppearance.configureWithDefaultBackground()
        let MorsePathLearnSignalsTabFont =
            UIFont(name: "AvenirNext-Medium", size: 11)
            ?? UIFont.systemFont(ofSize: 11)
        [
            MorsePathLearnSignalsTabAppearance.stackedLayoutAppearance,
            MorsePathLearnSignalsTabAppearance.inlineLayoutAppearance,
            MorsePathLearnSignalsTabAppearance.compactInlineLayoutAppearance
        ].forEach { MorsePathLearnSignalsItemAppearance in
            MorsePathLearnSignalsItemAppearance.normal.titleTextAttributes = [
                .font: MorsePathLearnSignalsTabFont
            ]
            MorsePathLearnSignalsItemAppearance.selected.titleTextAttributes = [
                .font: MorsePathLearnSignalsTabFont
            ]
        }
        UITabBar.appearance().standardAppearance = MorsePathLearnSignalsTabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = MorsePathLearnSignalsTabAppearance
        }

        let MorsePathLearnSignalsSegmentedFont =
            UIFont(name: "AvenirNext-Medium", size: 13)
            ?? UIFont.systemFont(ofSize: 13)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font: MorsePathLearnSignalsSegmentedFont],
            for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font: MorsePathLearnSignalsSegmentedFont],
            for: .selected
        )
    }
}

enum MorsePathLearnSignalsTypography {
    static func MorsePathLearnSignalsRegular(_ MorsePathLearnSignalsSize: CGFloat) -> Font {
        .custom("AvenirNext-Regular", size: MorsePathLearnSignalsSize, relativeTo: .body)
    }

    static func MorsePathLearnSignalsMedium(_ MorsePathLearnSignalsSize: CGFloat) -> Font {
        .custom("AvenirNext-Medium", size: MorsePathLearnSignalsSize, relativeTo: .body)
    }

    static func MorsePathLearnSignalsDemiBold(_ MorsePathLearnSignalsSize: CGFloat) -> Font {
        .custom("AvenirNext-DemiBold", size: MorsePathLearnSignalsSize, relativeTo: .headline)
    }

    static let MorsePathLearnSignalsBody = MorsePathLearnSignalsRegular(16)
    static let MorsePathLearnSignalsCaption = MorsePathLearnSignalsMedium(13)
    static let MorsePathLearnSignalsHeadline = MorsePathLearnSignalsDemiBold(17)
    static let MorsePathLearnSignalsTitle = MorsePathLearnSignalsDemiBold(24)
}
