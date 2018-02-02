import Foundation

protocol StandardErrorOutput {

    func write(_ string: String)

}

extension StandardErrorOutput {

    func write(_ string: String) {
        let line = "\(string)\n"
        guard let data = line.data(using: .utf8) else {
            assertionFailure("Failed to convert \(line) to Data")
            return
        }
        FileHandle.standardError.write(data)
    }

}
