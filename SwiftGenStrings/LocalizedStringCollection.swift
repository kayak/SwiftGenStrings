import Foundation

class LocalizedStringCollection {

    private var strings: [LocalizedString]
    private var byKey: [String: LocalizedString]

    init(strings: [LocalizedString]) {
        self.strings = strings
        self.byKey = strings.reduce([:], combine: { result, string in
            var result = result
            result[string.key] = string
            return result
        })
    }

    func mergeWithCollection(collection: LocalizedStringCollection) {
        for string in collection.strings {
            if let existing = byKey[string.key] {
                existing.comments.appendContentsOf(string.comments)
            } else {
                byKey[string.key] = string
                strings.append(string)
            }
        }
    }

    var formattedContent: String {
        return strings
            .sort({$0.key < $1.key })
            .reduce("", combine: { result, string in
                return result + string.formatted + "\n\n"
            })
    }

}
