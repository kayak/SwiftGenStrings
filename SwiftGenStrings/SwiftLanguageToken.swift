import Foundation

enum SwiftLanguageToken: Equatable {
    case identifier(identifier: String) // import, var, ClassName, functionName
    case text(text: String) // "...."
    case comment(comment: String) // /* or //
    case braceOpen // {
    case braceClose // }
    case bracketOpen // [
    case bracketClose // ]
    case parenthesisOpen // (
    case parenthesisClose // )
    case chevronOpen // <
    case chevronClose // >
    case colon // :
    case dot // .
    case plus // +
    case comma // ,
}
