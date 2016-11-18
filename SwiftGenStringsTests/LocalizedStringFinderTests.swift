import XCTest

class LocalizedStringFinderTests: XCTestCase {

    func testFindStringsWithTableNameAndBundle() {
        let finder = LocalizedStringFinder(routine: "NSLocalizedString")
        let tokens: [SwiftLanguageToken] = [
            .identifier(identifier: "NSLocalizedString"),
            .parenthesisOpen,
            .text(text: "KEY"),
            .identifier(identifier: ","),
            .identifier(identifier: "tableName"),
            .colon,
            .identifier(identifier: "nil"),
            .identifier(identifier: ","),
            .identifier(identifier: "bundle"),
            .colon,
            .identifier(identifier: "NSBundle"),
            .identifier(identifier: "."),
            .identifier(identifier: "mainBundle"),
            .parenthesisOpen,
            .parenthesisClose,
            .identifier(identifier: ","),
            .identifier(identifier: "value"),
            .colon,
            .text(text: "VALUE"),
            .identifier(identifier: ","),
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
