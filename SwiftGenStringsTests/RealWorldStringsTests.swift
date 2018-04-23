import XCTest

class RealWorldStringsTests: XCTestCase {

    private let errorOutput = StubErrorOutput()

    // MARK: - Tests

    func testSimpleLocalizedStrings() {
        verify(foundLocalizedString: LocalizedString(key: "k", value: "k", comments: ["c"]), in: "NSLocalizedString(\"k\", comment: \"c\")")
        verify(foundLocalizedString: LocalizedString(key: "k", value: "v", comments: ["c"]), in: "NSLocalizedString(\"k\", value: \"v\", comment: \"c\")")
    }

    func testLocalizedStringWithNewlinesBetweenArguments() {
        verify(foundLocalizedString: LocalizedString(key: "k", value: "k", comments: ["c"]), in: "NSLocalizedString(\n\"k\", \ncomment: \"c\"\n)")
    }

    func testLocalizedStringWithIdentifierInsteadOfString() {
        verifyNoLocalizedString(in: "NSLocalizedString(dateFormatter.format(date) + \" k\", value: \"Hello world!\", comment: \"\")")
        XCTAssertEqual(["dateFormatter"], errorOutput.invalidIdentifiers)
    }

    func testUnescapesDoublyEscapedUnicodeCodePointsInValue() {
        let string = loadFileResource(named: "testUnescapesDoublyEscapedUnicodeCodePoints")
        let expected = LocalizedString(key: "Hello \\\\U123", value: "Hello \\U123", comments: [""])
        verify(foundLocalizedString: expected, in: string)
    }

    func testReportErrorOnSwiftUnicodeCodePoint() {
        let string = loadFileResource(named: "testReportErrorOnSwiftUnicodeCodePoint")
        verifyNoLocalizedString(in: string)
        XCTAssertEqual(["\\u{123}", "\\u{00A0}", "\\U{123}"], errorOutput.invalidUnicodeCodePoints)
    }

    func testMultilineStringLiteralConvertedToSingleLineStringLiteral() {
        verify(
            foundLocalizedString: LocalizedString(
                key: "Here is some multi-line text More text here",
                value: "Here is some multi-line text More text here",
                comments: ["c"]),
            in: "NSLocalizedString(\"\"\"\n\tHere is some multi-line text \\\n\tMore text here\n\t\"\"\", comment: \"c\")")
    }
    
    // MARK: - Helpers

    private func verify(foundLocalizedString expected: LocalizedString, in contents: String) {
        let strings = findLocalizedStrings(in: contents)
        XCTAssertEqual(1, strings.count)
        XCTAssert(expected == strings.first, "Expected \(expected), found \(strings.first?.description ?? "nil")")
    }

    private func verifyNoLocalizedString(in contents: String) {
        let strings = findLocalizedStrings(in: contents)
        XCTAssert(strings.isEmpty)
    }

    private func findLocalizedStrings(in contents: String) -> [LocalizedString] {
        let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
        return LocalizedStringFinder(errorOutput: errorOutput).findLocalizedStrings(tokens)
    }

    private func loadFileResource(named name: String) -> String {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: "txt")!
        return try! String(contentsOf: url, encoding: .utf8)
    }

}

private class StubErrorOutput: LocalizedStringFinderErrorOutput {
    var invalidIdentifiers: [String] = []
    var invalidUnicodeCodePoints: [String] = []

    func invalidIdentifier(_ identifier: String) {
        invalidIdentifiers.append(identifier)
    }

    func invalidUnicodeCodePoint(_ unicodeCharacter: String) {
        invalidUnicodeCodePoints.append(unicodeCharacter)
    }
}
