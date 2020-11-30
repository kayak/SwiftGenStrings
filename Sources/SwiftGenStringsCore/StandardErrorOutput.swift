import Foundation

public class StandardErrorOutput {

    private var writtenErrors = [Error]()
    private let formatter = ErrorFormatter()

    public var numberOfWrittenErrors: Int {
        writtenErrors.count
    }

    public var hasWrittenError: Bool {
        !writtenErrors.isEmpty
    }

    public init() {}
    
    public func write(_ string: String) {
        let error = NSError(description: string)
        formatter.writeFormattedError(error)
        writtenErrors.append(error)
    }

}
