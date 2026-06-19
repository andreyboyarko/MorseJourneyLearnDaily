import SwiftUI

struct MorseJourneyLearnDailySettingsView: View {
    @Environment(\.dismiss) private var MorseJourneyLearnDailyDismiss
    @ObservedObject private var MorseJourneyLearnDailyProgressService =
        MorsePathLearnSignalsProgressService.MorsePathLearnSignalsShared
    @State private var MorseJourneyLearnDailyShowsResetConfirmation = false

    var body: some View {
        NavigationView {
            List {
                Section("Learning") {
                    NavigationLink(
                        destination: MorsePathLearnSignalsProgressView()
                    ) {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                }

                Section("About") {
                    MorseJourneyLearnDailySettingsValueRow(
                        MorseJourneyLearnDailyTitle: "App",
                        MorseJourneyLearnDailyValue:
                            Bundle.main.object(
                                forInfoDictionaryKey: "CFBundleDisplayName"
                            ) as? String ?? "Morse Journey: Learn Daily!"
                    )
                    MorseJourneyLearnDailySettingsValueRow(
                        MorseJourneyLearnDailyTitle: "Version",
                        MorseJourneyLearnDailyValue:
                            Bundle.main.object(
                                forInfoDictionaryKey: "CFBundleShortVersionString"
                            ) as? String ?? "1.0"
                    )
                }

                Section("Privacy") {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Works offline")
                            Text("No data is collected or shared.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "lock.shield.fill")
                            .foregroundStyle(.green)
                    }

                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Flashlight access")
                            Text(
                                "The camera is used only to control the flashlight. No photos or videos are captured."
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "flashlight.on.fill")
                            .foregroundStyle(.tint)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        MorseJourneyLearnDailyShowsResetConfirmation = true
                    } label: {
                        Label("Reset Progress", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        MorseJourneyLearnDailyDismiss()
                    }
                }
            }
            .confirmationDialog(
                "Reset all progress?",
                isPresented: $MorseJourneyLearnDailyShowsResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Progress", role: .destructive) {
                    MorseJourneyLearnDailyProgressService
                        .MorsePathLearnSignalsResetProgress()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    "Learned symbols, practice statistics, and quiz results will be permanently removed."
                )
            }
        }
    }
}

private struct MorseJourneyLearnDailySettingsValueRow: View {
    let MorseJourneyLearnDailyTitle: String
    let MorseJourneyLearnDailyValue: String

    var body: some View {
        HStack {
            Text(MorseJourneyLearnDailyTitle)
            Spacer()
            Text(MorseJourneyLearnDailyValue)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
