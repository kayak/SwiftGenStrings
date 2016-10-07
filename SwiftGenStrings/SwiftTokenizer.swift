import Foundation

class SwiftTokenizer {

    init() {}

    func tokenizeSwiftString(string: String) -> [SwiftLanguageToken] {
        let iterator = CharacterIterator(string: string)
        var tokens: [SwiftLanguageToken] = []
        while let character = iterator.next {
            switch character {
            case " ":
            break // skip whitespace
            case ":":
                tokens.append(.Colon)
            case "(":
                tokens.append(.ParenthesisOpen)
            case ")":
                tokens.append(.ParenthesisClose)
            case "{":
                tokens.append(.BraceOpen)
            case "}":
                tokens.append(.BraceClose)
            case "[":
                tokens.append(.BracketOpen)
            case "]":
                tokens.append(.BracketClose)
            case "<":
                tokens.append(.ChevronOpen)
            case ">":
                tokens.append(.ChevronClose)
            case "\"":
                var text = ""
                while let current = iterator.current, let next = iterator.next {
                    if current != "\\" && next == "\"" {
                        break
                    }
                    text = text + String(next)
                }
                tokens.append(.Text(text: text))

            case "/" where iterator.peekNext == "/":
                iterator.next
                var comment = "//"
                while let next = iterator.next where next != "\n" {
                    comment = comment + String(next)
                }
                tokens.append(.Comment(comment: comment))

            case _ where isIdentifierCharacter(character):
                var identifier = String(character)
                while let peek = iterator.peekNext where isIdentifierCharacter(peek) {
                    identifier = identifier + String(peek)
                    iterator.next
                }
                tokens.append(.Identifier(identifier: identifier))

            default:
                tokens.append(.Identifier(identifier: String(character)))
            }
        }
        return tokens
    }

    private let alphaNumericCharacterSet = NSCharacterSet.alphanumericCharacterSet()
    private let optionalCharacterSet = NSCharacterSet(charactersInString: "?!")

    private func isIdentifierCharacter(character: Character) -> Bool {
        for unichar in String(character).utf16 {
            if !alphaNumericCharacterSet.characterIsMember(unichar) && !optionalCharacterSet.characterIsMember(unichar) {
                return false
            }
        }
        return true
    }

}
