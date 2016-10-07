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

class LocalizedString {

    var key: String
    var value: String
    var comments: [String]

    init(key: String, value: String, comments: [String]) {
        self.key = key
        self.value = value
        self.comments = comments
    }

    var valueWithIndexedPlaceholders: String {
        let matches = formatSpecifierRegex.matchesInString(value, options:[], range: NSRange(location: 0, length: (value as NSString).length))
        if matches.count <= 1 {
            return value // Genstrings never adds placement indexes when 0-1 placeholders are present
        }

        var result = value as NSString

        for i in (matches.count - 1).stride(through: 0, by: -1) {
            result = result.stringByReplacingCharactersInRange(NSRange(location: matches[i].range.location, length: 1), withString:"%\(i + 1)$")
        }

        return result as String
    }

    var formatted: String {
        return "/* \(formattedComments) */\n" +
            "\"\(key)\" = \"\(valueWithIndexedPlaceholders)\";"
    }

    private var formattedComments: String {
        return Array(Set(comments)).sort().joinWithSeparator("\n   ")
    }

}
