import Foundation

class LocalizedStringCollection {

    private var strings: [LocalizedString]
    private var byKey: [String: LocalizedString]

    init(strings: [LocalizedString]) {
        self.strings = strings
        self.byKey = strings.reduce([:], { result, string in
            var result = result
            result[string.key] = string
            return result
        })
    }

    func merge(with collection: LocalizedStringCollection) {
        for string in collection.strings {
            if let existing = byKey[string.key] {
                existing.comments.append(contentsOf: string.comments)
            } else {
                byKey[string.key] = string
                strings.append(string)
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
