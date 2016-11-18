import XCTest

class SwiftTokenizerTests: XCTestCase {

    let tokenizer = SwiftTokenizer()

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

}
