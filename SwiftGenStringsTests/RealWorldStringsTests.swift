import XCTest

class RealWorldStringsTests: XCTestCase {

    private let errorOutput = StubErrorOutput()

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

    func verify(foundLocalizedString expected: LocalizedString, in contents: String) {
        let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
        let strings = LocalizedStringFinder(errorOutput: errorOutput).findLocalizedStrings(tokens)
        XCTAssertEqual(1, strings.count)
        XCTAssert(expected == strings.first, "Expected \(expected), found \(strings.first?.description ?? "nil")")
    }

    func verifyNoLocalizedString(in contents: String) {
        let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
        let strings = LocalizedStringFinder(errorOutput: errorOutput).findLocalizedStrings(tokens)
        XCTAssert(strings.isEmpty)
    }

}

private class StubErrorOutput: LocalizedStringFinderErrorOutput {
    var invalidIdentifiers: [String] = []

    func invalidIdentifier(_ identifier: String) {
        invalidIdentifiers.append(identifier)
    }
}
