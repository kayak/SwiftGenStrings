import Foundation

struct LocalizedStringFinderStandardErrorOutput: LocalizedStringFinderErrorOutput {

    let filename: String

    // MARK: - LocalizedStringFinderErrorOutput

    func invalidIdentifier(_ identifier: String) {
        write("Invalid identifier '\(identifier)'")
    }

    func invalidUnicodeCodePoint(_ unicodeCharacter: String) {
        write("Invalid unicode character '\(unicodeCharacter)', please use \\\\U123 format, which is accepted by .strings file")
    }

    // MARK: - Helpers

    private func write(_ string: String) {
        let line = "\(filename): \(string)\n"
        guard let data = line.data(using: .utf8) else {
            assertionFailure("Failed to convert \(line) to Data")
            return
        }
        FileHandle.standardError.write(data)
    }
    
}
