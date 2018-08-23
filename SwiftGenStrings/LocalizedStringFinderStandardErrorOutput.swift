import Foundation

final class LocalizedStringFinderStandardErrorOutput: StandardErrorOutput {

    let filename: String
    
    init(filename: String) {
        self.filename = filename
        super.init()
    }

}

extension LocalizedStringFinderStandardErrorOutput: LocalizedStringFinderErrorOutput {

    func invalidIdentifier(_ identifier: String) {
        write("\(filename): Invalid identifier '\(identifier)'")
    }

    func invalidUnicodeCodePoint(_ unicodeCharacter: String) {
        write("\(filename): Invalid unicode character '\(unicodeCharacter)', please use \\\\U123 format, which is accepted by .strings file")
    }
    
}
