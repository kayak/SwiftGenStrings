import ArgumentParser
import Foundation

extension URL: ExpressibleByArgument {

    public init?(argument: String) {
        if argument.hasPrefix("~/") {
            let cleanedPath = String(argument.dropFirst())
            self.init(fileURLWithPath: cleanedPath, relativeTo: FileManager.default.homeDirectoryForCurrentUser)
        } else {
            self.init(fileURLWithPath: argument)
        }
    }

}
