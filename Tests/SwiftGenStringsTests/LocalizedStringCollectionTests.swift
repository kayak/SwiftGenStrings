@testable import SwiftGenStringsCore
import XCTest

final class LocalizedStringCollectionTests: XCTestCase {

    private var differentValuesReported: [String] = []

    func testFormattedContentIncludingComments() {
        let collection = LocalizedStringCollection(strings: [LocalizedString(key: "KEY", value: "VALUE", comments: ["Comment"])], errorOutput: self)
        let output = collection.formattedContent(includeComments: true)
        XCTAssertEqual(output, "/* Comment */\n\"KEY\" = \"VALUE\";\n\n")
    }

    func testFormattedContentExcludingComments() {
        let collection = LocalizedStringCollection(strings: [LocalizedString(key: "KEY", value: "VALUE", comments: ["Comment will be ignored"])], errorOutput: self)
        let output = collection.formattedContent(includeComments: false)
        XCTAssertEqual(output, "\"KEY\" = \"VALUE\";\n\n")
    }

    func testMergeWithEmptyStrings() {
        let collection = LocalizedStringCollection(strings: [], errorOutput: self)
        collection.merge(with: collection)
        XCTAssertEqual([], differentValuesReported)
    }

    func testMergeWithSameStrings() {
        let collection = LocalizedStringCollection(strings: [LocalizedString(key: "KEY", value: "VALUE", comments: [])], errorOutput: self)
        collection.merge(with: collection)
        XCTAssertEqual([], differentValuesReported)
    }

    func testMergeWithSameKeyDifferentValue() {
        let collection1 = LocalizedStringCollection(strings: [LocalizedString(key: "KEY", value: "VALUE1", comments: [])], errorOutput: self)
        let collection2 = LocalizedStringCollection(strings: [LocalizedString(key: "KEY", value: "VALUE2", comments: [])], errorOutput: self)
        collection1.merge(with: collection2)
        XCTAssertEqual(["KEY", "VALUE1", "VALUE2"], differentValuesReported)
    }

}

extension LocalizedStringCollectionTests: LocalizedStringCollectionErrorOutput {

    func differentValues(forKey key: String, value1: String, value2: String) {
        differentValuesReported = [key, value1, value2]
    }

}
