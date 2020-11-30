import Foundation

public struct SwiftTokenizer {

    public static func tokenizeSwiftString(_ string: String) -> [SwiftLanguageToken] {
        let iterator = CharacterIterator(string: string)
        var tokens: [SwiftLanguageToken] = []
        while let character = iterator.next {
            switch character {
            case " ", "\t", "\n":
                break // skip whitespace
            case ":":
                tokens.append(.colon)
            case ".":
                tokens.append(.dot)
            case "+":
                tokens.append(.plus)
            case ",":
                tokens.append(.comma)
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
            case "\"" where iterator.startsWith("\"\"\""):
                // Skip over opening quotes
                iterator.advance(3)
                iterator.skipWhitespacesAndNewlines()
                var text = ""
                while let current = iterator.current {
                    // Check for code formatting linebreak
                    if current == "\\" && iterator.startsWith("\\\n") {
                        iterator.advance(1)
                        iterator.skipWhitespacesAndNewlines()
                        // Check for closing quotes
                    } else if current == "\"" && iterator.startsWith("\"\"\"") {
                        iterator.advance(2)
                        // Remove last newline and trailing whitespace before closing quotes
                        if let lastIndex = text.range(of: "\\n", options: .backwards)?.lowerBound {
                            text.removeSubrange(lastIndex..<text.endIndex)
                        }
                        break
                    } else {
                        var current = String(current)
                        // Escape any newlines included
                        if current == "\n" {
                            current = "\\n"
                        }
                        text += current
                        _ = iterator.next
                    }
                }
                tokens.append(.text(text: text))
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
                tokens.append(.comment(comment))

            case _ where isIdentifierCharacter(character):
                var identifier = String(character)
                while let peek = iterator.peekNext, isIdentifierCharacter(peek) {
                    identifier = identifier + String(peek)
                    _ = iterator.next
                }
                tokens.append(.identifier(identifier))

            default:
                tokens.append(.identifier(String(character)))
            }
        }
        return tokens
    }

    private static let allowedIdentifierCharacterSet: CharacterSet = {
        let optionalCharacterSet = CharacterSet(charactersIn: "?!")
        let underscores = CharacterSet(charactersIn: "_")

        return CharacterSet.alphanumerics
            .union(.symbols)
            .union(optionalCharacterSet)
            .union(underscores)
    }()

    private static func isIdentifierCharacter(_ character: Character) -> Bool {
        for unicodeScalar in character.unicodeScalars {
            if !allowedIdentifierCharacterSet.contains(unicodeScalar) {
                return false
            }
        }
        return true
    }

}
