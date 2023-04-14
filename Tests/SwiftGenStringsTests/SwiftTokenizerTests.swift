@testable import SwiftGenStringsCore
import XCTest

final class SwiftTokenizerTests: XCTestCase {

    private let tokenizer = SwiftTokenizer()

    func testTokenizer() {
        let string = "func something { return NSLocalizedString(\"KEY\", value: \"Quotes in \\\" the middle\", comment: \"COMMENT\") }"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(17, tokens.count)
    }

    func testTokenizerWithDesignedNSLocalizedStringInit() {
        let string = "NSLocalizedString(\"\", tableName: nil, bundle: NSBundle.mainBundle(), value: \"\", comment: \"\")"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(24, tokens.count)
    }

    func testTokenizerWithNumberedIdentifier() {
        let string = "var foo1 = 0"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(4, tokens.count)
    }

    func testTokenizerWithNonASCIIIdentifier() {
        let string = "var übergeek = true"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(4, tokens.count)
    }

    func testTokenizerWithOptionals() {
        let string = "var foo = bar?.foo!"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(6, tokens.count)
    }

    func testTokenizerWithUnderscore() {
        let string = "var _secret = \"123\""
        let tokens = tokenizer.tokenizeSwiftString(string)
        assertEqualTokens([.identifier("var"), .identifier("_secret"), .identifier("="), .text(text: "123")], tokens)
    }

    func testTokenizerWithEmojiInIdentifier() {
        let string = "var fontWeight📙: String"
        let tokens = tokenizer.tokenizeSwiftString(string)
        assertEqualTokens([.identifier("var"), .identifier("fontWeight📙"), .colon, .identifier("String")], tokens)
    }

    func testTokenizerWithComment() {
        let string = "// var foo = bar"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(1, tokens.count)
    }

    func testTokenizerWithCommentAndAssignment() {
        let string = "// var foo = bar\nlet a = 132"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(5, tokens.count)
    }

    func testTokenizerMultiLineStringLiteral() {
        let string = "NSLocalizedString(\n\t\"\"\"\n\tHere is some multi-line text \\\n\tMore text here\n\t\"\"\",\n\tcomment: \"bla bla\")"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(8, tokens.count)
        XCTAssertEqual(tokens[2], SwiftLanguageToken.text(text: "Here is some multi-line text More text here"))
    }
    
    func testTokenizerMultiLineStringLiteralEscapesNewline() {
        let string = "NSLocalizedString(\n\t\"\"\"\n\tHere is some multi-line text\nwith newline\n\"\"\",\n\tcomment: \"bla bla\")"
        let tokens = tokenizer.tokenizeSwiftString(string)
        XCTAssertEqual(8, tokens.count)
        XCTAssertEqual(tokens[2], SwiftLanguageToken.text(text: "Here is some multi-line text\\nwith newline"))
    }

    // MARK: - Helpers

    private func assertEqualTokens(_ expected: [SwiftLanguageToken], _ actual: [SwiftLanguageToken], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(expected.count, actual.count, file: file, line: line)

        for value in zip(expected, actual).enumerated() {
            XCTAssertEqual(value.element.0, value.element.1, "Expected same tokens at index \(value.offset)", file: file, line: line)
        }
    }
    
}
