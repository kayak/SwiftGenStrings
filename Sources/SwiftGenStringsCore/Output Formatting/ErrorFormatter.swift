import Foundation

public struct ErrorFormatter {

    public init() {}

    public func writeFormattedError(_ errorMessage: String) {
        let formattedError = "[ERROR] \(errorMessage)\n".formattedStringWithColor(.red)
        guard let data = formattedError.data(using: .utf8) else {
            assertionFailure("Failed to convert \"\(formattedError)\" to data")
            return
        }
        FileHandle.standardError.write(data)
    }

}
