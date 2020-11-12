import Foundation

public enum SwiftLanguageToken: Equatable {
    case identifier(_ identifier: String) // import, var, ClassName, functionName
    case text(text: String) // "...."
    case comment(_ comment: String) // /* or //
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
