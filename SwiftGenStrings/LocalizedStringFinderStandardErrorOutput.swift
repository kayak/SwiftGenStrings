import Foundation

struct LocalizedStringFinderStandardErrorOutput: LocalizedStringFinderErrorOutput {

    let filename: String

    // MARK: - LocalizedStringFinderErrorOutput

    func invalidIdentifier(_ identifier: String) {
        write("Invalid identifier '\(identifier)'")
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
