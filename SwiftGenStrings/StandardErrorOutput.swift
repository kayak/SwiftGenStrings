import Foundation

class StandardErrorOutput {

    private(set) var hasWrittenError = false
    
    func write(_ string: String) {
        let line = "\(string)\n"
        guard let data = line.data(using: .utf8) else {
            assertionFailure("Failed to convert \(line) to Data")
            return
        }
        hasWrittenError = true
        FileHandle.standardError.write(data)
    }

}
