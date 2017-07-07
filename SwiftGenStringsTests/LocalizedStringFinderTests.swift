import XCTest

class LocalizedStringFinderTests: XCTestCase {

    func testFindStringsWithTableNameAndBundle() {
        let finder = LocalizedStringFinder()
        let tokens: [SwiftLanguageToken] = [
            .identifier(identifier: "NSLocalizedString"),
            .parenthesisOpen,
            .text(text: "KEY"),
            .comma,
            .identifier(identifier: "tableName"),
            .colon,
            .identifier(identifier: "nil"),
            .comma,
            .identifier(identifier: "bundle"),
            .colon,
            .identifier(identifier: "NSBundle"),
            .dot,
            .identifier(identifier: "mainBundle"),
            .parenthesisOpen,
            .parenthesisClose,
            .comma,
            .identifier(identifier: "value"),
            .colon,
            .text(text: "VALUE"),
            .comma,
            .identifier(identifier: "comment"),
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
