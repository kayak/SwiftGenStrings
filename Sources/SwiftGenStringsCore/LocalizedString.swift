import Foundation

private let formatSpecifierRegex: NSRegularExpression = {
    let intPrecisionModifier = "\\d*"
    let intLengthModifier = "(?:h|hh|j|l|ll|q|t|z)?"
    let intType = "[dDiIuUxXoO]"
    let intPattern = String(format: "%@%@%@", intPrecisionModifier, intLengthModifier, intType)

    let floatPrecisionModifier = "(?:\\d*|\\.\\d+|\\d+\\.\\d+)"
    let floatLengthModifier = "L?"
    let floatType = "[aAeEfFgG]"
    let floatPattern = String(format: "%@%@%@", floatPrecisionModifier, floatLengthModifier, floatType)

    let otherPattern = "[@cCsSp]" // Exclude % since it doesn't capture an argument

    let pattern = String(format: "(?<!%%)%%(?:%@|%@|%@)", intPattern, floatPattern, otherPattern)

    return try! NSRegularExpression(pattern: pattern, options:[])
}()

public class LocalizedString: CustomStringConvertible, Equatable {

    let key: String
    let value: String
    let comments: [String]

    init(key: String, value: String, comments: [String]) {
        self.key = key
        self.value = value
        self.comments = comments
    }

    var valueWithIndexedPlaceholders: String {
        let matches = formatSpecifierRegex.matches(in: value, options:[], range: NSRange(location: 0, length: (value as NSString).length))
        if matches.count <= 1 {
            return value // Genstrings never adds placement indexes when 0-1 placeholders are present
        }

        var result = value as NSString

        for i in stride(from: (matches.count - 1), through: 0, by: -1) {
            result = result.replacingCharacters(in: NSRange(location: matches[i].range.location, length: 1), with: "%\(i + 1)$") as NSString
        }

        return result as String
    }

    var formatted: String {
        "/* \(formattedComments) */\n" +
            "\"\(key)\" = \"\(valueWithIndexedPlaceholders)\";"
    }

    private var formattedComments: String {
        Array(Set(comments)).sorted().joined(separator: "\n   ")
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        "LocalizedString(key: \(key), value: \(value), comments: \(comments))"
    }

    // MARK: - Equatable

    public static func ==(lhs: LocalizedString, rhs: LocalizedString) -> Bool {
        lhs.key == rhs.key && lhs.value == rhs.value && lhs.comments == rhs.comments
    }

}
