import Foundation

enum SwiftLanguageToken {
    case Identifier(identifier: String) // import, var, ClassName, functionName
    case Text(text: String) // "...."
    case Comment(comment: String) // /* or //
    case BraceOpen // {
    case BraceClose // }
    case BracketOpen // [
    case BracketClose // ]
    case ParenthesisOpen // (
    case ParenthesisClose // )
    case ChevronOpen // <
    case ChevronClose // >
    case Colon // :
}
