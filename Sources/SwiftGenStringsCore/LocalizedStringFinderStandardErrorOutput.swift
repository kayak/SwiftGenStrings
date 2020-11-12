import Foundation

public final class LocalizedStringFinderStandardErrorOutput: StandardErrorOutput {

	let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
        super.init()
    }

}

extension LocalizedStringFinderStandardErrorOutput: LocalizedStringFinderErrorOutput {

	public func invalidIdentifier(_ identifier: String) {
		write("\(fileURL.lastPathComponent): Invalid identifier '\(identifier)'")
    }

	public func invalidUnicodeCodePoint(_ unicodeCharacter: String) {
		write("\(fileURL.lastPathComponent): Invalid unicode character '\(unicodeCharacter)', please use \\\\U123 format, which is accepted by .strings file")
    }
    
}
