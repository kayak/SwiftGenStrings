import Foundation

public protocol LocalizedStringCollectionErrorOutput {
    func differentValues(forKey key: String, value1: String, value2: String)
}

public final class LocalizedStringCollection {

    private let errorOutput: LocalizedStringCollectionErrorOutput?

    private var byKey: [String: LocalizedString] = [:]

    private var strings: [LocalizedString] {
        Array(byKey.values)
    }

    public init(strings: [LocalizedString], errorOutput: LocalizedStringCollectionErrorOutput?) {
        self.errorOutput = errorOutput
        merge(with: strings)
    }

    public func formattedContent(includeComments: Bool) -> String {
        strings
            .sorted(by: {$0.key < $1.key })
            .reduce("") { result, string in
                result + string.formatted(includeComments: includeComments) + "\n\n"
            }
    }

    public func merge(with collection: LocalizedStringCollection) {
        merge(with: collection.strings)
    }

    private func merge(with strings: [LocalizedString]) {
        for string in strings {
            if let existing = byKey[string.key] {
                guard existing.value == string.value else {
                    errorOutput?.differentValues(forKey: existing.key, value1: existing.value, value2: string.value)
                    continue
                }
                let comments = existing.comments + string.comments
                let merged = LocalizedString(key: string.key, value: string.value, comments: comments)
                byKey[merged.key] = merged
            } else {
                byKey[string.key] = string
            }
        }
    }

}
