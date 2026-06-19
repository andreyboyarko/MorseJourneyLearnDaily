

import SwiftUI

struct MorsePathLearnSignalsApp: View {
    var body: some View {
        MorsePathLearnSignalsRootView()
            .environment(
                \.font,
                MorsePathLearnSignalsTypography.MorsePathLearnSignalsBody
            )
    }
}
