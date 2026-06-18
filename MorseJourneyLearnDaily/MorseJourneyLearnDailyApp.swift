//
//  MorseJourneyLearnDailyApp.swift
//  MorseJourneyLearnDaily
//
//  Created by Andrei  Boyarko on 18/06/2026.
//

import SwiftUI

@main
struct MorsePathLearnSignalsApp: App {
    init() {
        MorsePathLearnSignalsTheme.MorsePathLearnSignalsConfigureNavigationAppearance()
    }

    var body: some Scene {
        WindowGroup {
            MorsePathLearnSignalsRootView()
                .environment(
                    \.font,
                    MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody
                )
        }
    }
}
