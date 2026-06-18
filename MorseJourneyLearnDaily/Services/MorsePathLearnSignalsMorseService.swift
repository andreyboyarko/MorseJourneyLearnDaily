import Foundation

struct MorsePathLearnSignalsMorseService {
    private let MorsePathLearnSignalsReverseDictionary: [String: String] =
        Dictionary(
            uniqueKeysWithValues: MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsAll.map {
                ($0.value, $0.key)
            }
        )

    func MorsePathLearnSignalsTextToMorse(_ MorsePathLearnSignalsText: String) -> String {
        MorsePathLearnSignalsText
            .uppercased()
            .split(separator: " ", omittingEmptySubsequences: true)
            .map { MorsePathLearnSignalsWord in
                MorsePathLearnSignalsWord.compactMap { MorsePathLearnSignalsCharacter in
                    MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsAll[
                        String(MorsePathLearnSignalsCharacter)
                    ] ?? MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsSymbols["?"]
                }
                .joined(separator: " ")
            }
            .joined(separator: " / ")
    }

    func MorsePathLearnSignalsMorseToText(_ MorsePathLearnSignalsMorse: String) -> String {
        MorsePathLearnSignalsMorse
            .components(separatedBy: "/")
            .map { MorsePathLearnSignalsWord in
                MorsePathLearnSignalsWord
                    .split(whereSeparator: \.isWhitespace)
                    .map { MorsePathLearnSignalsToken in
                        MorsePathLearnSignalsReverseDictionary[String(MorsePathLearnSignalsToken)] ?? "?"
                    }
                    .joined()
            }
            .joined(separator: " ")
    }

    func MorsePathLearnSignalsSymbolForMorse(_ MorsePathLearnSignalsMorse: String) -> String? {
        MorsePathLearnSignalsReverseDictionary[MorsePathLearnSignalsMorse]
    }

    func MorsePathLearnSignalsMorseForSymbol(_ MorsePathLearnSignalsSymbol: String) -> String? {
        MorsePathLearnSignalsMorseDictionary.MorsePathLearnSignalsAll[
            MorsePathLearnSignalsSymbol.uppercased()
        ]
    }
}
