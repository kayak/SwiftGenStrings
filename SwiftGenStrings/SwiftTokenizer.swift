import Foundation

class SwiftTokenizer {

    func tokenizeSwiftString(_ string: String) -> [SwiftLanguageToken] {
        let iterator = CharacterIterator(string: string)
        var tokens: [SwiftLanguageToken] = []
        while let character = iterator.next {
            switch character {
            case " ":
            break // skip whitespace
            case ":":
                tokens.append(.colon)
            case "(":
                tokens.append(.parenthesisOpen)
            case ")":
                tokens.append(.parenthesisClose)
            case "{":
                tokens.append(.braceOpen)
            case "}":
                tokens.append(.braceClose)
            case "[":
                tokens.append(.bracketOpen)
            case "]":
                tokens.append(.bracketClose)
            case "<":
                tokens.append(.chevronOpen)
            case ">":
                tokens.append(.chevronClose)
            case "\"":
                var text = ""
                while let current = iterator.current, let next = iterator.next {
                    if current != "\\" && next == "\"" {
                        break
                    }
                    text = text + String(next)
                }
                tokens.append(.text(text: text))

            case "/" where iterator.peekNext == "/":
                _ = iterator.next
                var comment = "//"
                while let next = iterator.next, next != "\n" {
                    comment = comment + String(next)
                }
                tokens.append(.comment(comment: comment))

            case _ where isIdentifierCharacter(character):
                var identifier = String(character)
                while let peek = iterator.peekNext, isIdentifierCharacter(peek) {
                    identifier = identifier + String(peek)
                    _ = iterator.next
                }
                tokens.append(.identifier(identifier: identifier))

            default:
                tokens.append(.identifier(identifier: String(character)))
            }
        }
        return tokens
    }

    private let alphaNumericCharacterSet = CharacterSet.alphanumerics
    private let optionalCharacterSet = CharacterSet(charactersIn: "?!")

    private func isIdentifierCharacter(_ character: Character) -> Bool {
        for unichar in String(character).utf16 {
            if !alphaNumericCharacterSet.contains(UnicodeScalar(unichar)!) && !optionalCharacterSet.contains(UnicodeScalar(unichar)!) {
                return false
            }
        }
        return true
    }

}
