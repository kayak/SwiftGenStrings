import Foundation

public class StandardErrorOutput {

    private var writtenErrorMessages = [String]()
    private let formatter = ErrorFormatter()

    public var numberOfWrittenErrors: Int {
        writtenErrorMessages.count
    }

    public var hasWrittenError: Bool {
        !writtenErrorMessages.isEmpty
    }

    public init() {}
    
    public func write(_ string: String) {
        writtenErrorMessages.append(string)
        formatter.writeFormattedError(string)
    }

}
