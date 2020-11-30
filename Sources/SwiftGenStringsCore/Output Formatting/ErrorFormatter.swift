import Foundation

public struct ErrorFormatter {

    public init() {}

    public func writeFormattedError(_ error: Error) {
        let formattedError = "[ERROR] \(error.localizedDescription)\n".formattedStringWithColor(.red)
        guard let data = formattedError.data(using: .utf8) else {
            assertionFailure("Failed to convert \"\(formattedError)\" to data")
            return
        }
        FileHandle.standardError.write(data)
    }

}
