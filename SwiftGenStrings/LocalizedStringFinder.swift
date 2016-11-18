import Foundation

class LocalizedStringFinder {

    private let routine: String

    private var parsingLocalizedString = false
    private var argument: Argument = .key
    private var openedParenthesis = 0

    private var key = ""
    private var value = ""
    private var comment = ""

    private var result: [LocalizedString] = []

    init(routine: String) {
        self.routine = routine
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
            argument = .key
            openedParenthesis = 0
            key = ""
            value = ""
            comment = ""
        case "comment":
            argument = .comment
        case "value":
            argument = .value
        default:
            break
        }
    }

    private func processText(_ text: String) {
        switch argument {
        case .key:
            key += text
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
        if value == "" {
            value = key
        }
        result.append(LocalizedString(key: key, value: value, comments: [comment]))
        parsingLocalizedString = false
    }

    private enum Argument {
        case key
        case value
        case comment
    }

}
