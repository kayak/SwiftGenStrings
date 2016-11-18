import Foundation

class LocalizedStringCollection {

    private var byKey: [String: LocalizedString] = [:]
    private var strings: [LocalizedString] {
        return Array(byKey.values)
    }

    init(strings: [LocalizedString]) {
        merge(with: strings)
    }

    func merge(with collection: LocalizedStringCollection) {
        merge(with: collection.strings)
    }

    private func merge(with strings: [LocalizedString]) {
        for string in strings {
            if let existing = byKey[string.key] {
                let comments = existing.comments + string.comments
                let merged = LocalizedString(key: string.key, value: string.value, comments: comments)
                byKey[merged.key] = merged
            } else {
                byKey[string.key] = string
            }
        }
    }

    var formattedContent: String {
        return strings
            .sorted(by: {$0.key < $1.key })
            .reduce("", { result, string in
                return result + string.formatted + "\n\n"
            })
    }

}
