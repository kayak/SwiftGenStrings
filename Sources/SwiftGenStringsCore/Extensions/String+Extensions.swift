import Foundation

public extension String {

    func ky_write(to url: URL, atomically: Bool, encoding: Encoding = .utf8) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try write(to: url, atomically: atomically, encoding: .utf8)
    }
    
}
