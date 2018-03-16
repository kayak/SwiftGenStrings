import Foundation

protocol LocalizedStringFinderErrorOutput {
    func invalidIdentifier(_ identifier: String)
    func invalidUnicodeCodePoint(_ unicodeCharacter: String)
}

private let verifyUnicodeRegex = try! NSRegularExpression(pattern: "\\\\[uU]\\{[a-fA-F0-9]+\\}", options: [])

class LocalizedStringFinder {

    private let routine: String
    private let errorOutput: LocalizedStringFinderErrorOutput?

    private var parsingLocalizedString = false
    private var invalidLocalizedString = false
    private var argument: Argument = .key
    private var openedParenthesis = 0

    private var key = ""
    private var value = ""
    private var comment = ""

    private var result: [LocalizedString] = []

    init(routine: String = "NSLocalizedString", errorOutput: LocalizedStringFinderErrorOutput? = nil) {
        self.routine = routine
        self.errorOutput = errorOutput
    }

    func findLocalizedStrings(_ tokens: [SwiftLanguageToken]) -> [LocalizedString] {
        for token in tokens {
            switch token {
            case .identifier(let identifier):
                processIdentifier(identifier)
            case .text(let text):
                processText(text)
            case .parenthesisOpen:
                openedParenthesis += 1
            case .parenthesisClose:
                openedParenthesis -= 1
                processEnd()
            default:
                break
            }
        }
        return result
    }

    private func processIdentifier(_ identifier: String) {
        switch identifier {
        case routine:
            parsingLocalizedString = true
            invalidLocalizedString = false
            argument = .key
            openedParenthesis = 0
            key = ""
            value = ""
            comment = ""
        case "tableName":
            argument = .tableName
        case "bundle":
            argument = .bundle
        case "value":
            argument = .value
        case "comment":
            argument = .comment
        default:
            if parsingLocalizedString && argument.isTextOnly && !invalidLocalizedString {
                invalidLocalizedString = true
                errorOutput?.invalidIdentifier(identifier)
            }
        }
    }

    private func processText(_ text: String) {
        switch argument {
        case .key:
            key += text
        case .tableName:
            break // Ignored
        case .bundle:
            break // Ignored
        case .value:
            value += text
        case .comment:
            comment += text
        }
    }

    private func processEnd() {
        guard parsingLocalizedString && openedParenthesis == 0 else {
            return
        }
        guard !invalidLocalizedString else {
            parsingLocalizedString = false
            return
        }
        if value == "" {
            value = key
        }

        key = unescapeUnicodePoints(in: key)
        value = unescapeUnicodePoints(in: value)

        guard validateUnicodeCodePoints(in: key) && validateUnicodeCodePoints(in: value) else {
            parsingLocalizedString = false
            return
        }

        result.append(LocalizedString(key: key, value: value, comments: [comment]))
        parsingLocalizedString = false
    }

    /// Unicode points are defined as \\U123 in swift, but .strings file require them to be \U123.
    private func unescapeUnicodePoints(in string: String) -> String {
        return string.replacingOccurrences(of: "\\\\U", with: "\\U")
    }

    /// Strings files accept \U123, but don't accept \u{123} or \U{123} code points.
    private func validateUnicodeCodePoints(in string: String) -> Bool {
        let nsString = string as NSString
        let matches = verifyUnicodeRegex.matches(in: string, options: [], range: NSMakeRange(0, nsString.length))
        let invalidUnicodeCodePoints = matches.map { nsString.substring(with: $0.range) }

        invalidUnicodeCodePoints.forEach { errorOutput?.invalidUnicodeCodePoint($0) }

        return invalidUnicodeCodePoints.isEmpty
    }

    private enum Argument {
        case key
        case tableName
        case bundle
        case value
        case comment

        var isTextOnly: Bool {
            switch self {
            case .key, .value, .comment:
                return true
            case .tableName, .bundle:
                return false
            }
        }
    }

}
