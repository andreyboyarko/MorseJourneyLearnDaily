//
//  MorseJourneyLearnDailyApp.swift
//  MorseJourneyLearnDaily
//
//  Created by Andrei  Boyarko on 18/06/2026.
//

import SwiftUI
import UIKit

@main
struct MorsePathLearnSignalsApp: App {
    init() {
        MorsePathLearnSignalsTheme.MorsePathLearnSignalsConfigureNavigationAppearance()
        UITextView.appearance().backgroundColor = .clear
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
