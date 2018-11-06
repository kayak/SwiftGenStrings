import XCTest

class LocalizedStringFinderTests: XCTestCase {

    func testFindStringsWithTableNameAndBundle() {
        let finder = LocalizedStringFinder()
        let tokens: [SwiftLanguageToken] = [
            .identifier("NSLocalizedString"),
            .parenthesisOpen,
            .text(text: "KEY"),
            .comma,
            .identifier("tableName"),
            .colon,
            .identifier("nil"),
            .comma,
            .identifier("bundle"),
            .colon,
            .identifier("NSBundle"),
            .dot,
            .identifier("mainBundle"),
            .parenthesisOpen,
            .parenthesisClose,
            .comma,
            .identifier("value"),
            .colon,
            .text(text: "VALUE"),
            .comma,
            .identifier("comment"),
            .colon,
            .text(text: "COMMENT"),
            .parenthesisClose
        ]

        let localizedStrings = finder.findLocalizedStrings(tokens)
        XCTAssertEqual(1, localizedStrings.count)

        let localizedString = localizedStrings.first!
        XCTAssertEqual("KEY", localizedString.key)
        XCTAssertEqual("VALUE", localizedString.value)
        XCTAssertEqual("COMMENT", localizedString.comments.first!)
    }

}
