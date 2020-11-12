import Foundation

public final class LocalizedStringCollectionStandardErrorOutput: StandardErrorOutput {}

extension LocalizedStringCollectionStandardErrorOutput: LocalizedStringCollectionErrorOutput {

	public func differentValues(forKey key: String, value1: String, value2: String) {
        write("Found the same key '\(key)' with different values: '\(value1)' and '\(value2)'")
    }

}
