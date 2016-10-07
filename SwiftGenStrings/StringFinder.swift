import Foundation

class StringFinder {

    private let routine: String

    private var parsingLocalizedString = false
    private var argument: Argument = .Key
    private var openedParenthesis = 0

    private var key = ""
    private var value = ""
    private var comment = ""

    private var result: [LocalizedString] = []

    init(routine: String) {
        self.routine = routine
    }

    func findLocalizedStrings(tokens: [SwiftLanguageToken]) -> [LocalizedString] {
        for token in tokens {
            switch token {
            case .Identifier(let identifier):
                processIdentifier(identifier)
            case .Text(let text):
                processText(text)
            case .ParenthesisOpen:
                openedParenthesis += 1
            case .ParenthesisClose:
                openedParenthesis -= 1
                processEnd()
            default:
                break
            }
        }
        return result
    }

    private func processIdentifier(identifier: String) {
        switch identifier {
        case routine:
            parsingLocalizedString = true
            argument = .Key
            openedParenthesis = 0
            key = ""
            value = ""
            comment = ""
        case "comment":
            argument = .Comment
        case "value":
            argument = .Value
        default:
            break
        }
    }

    private func processText(text: String) {
        switch argument {
        case .Key:
            key += text
        case .Value:
            value += text
        case .Comment:
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
        case Key
        case Value
        case Comment
    }

}
