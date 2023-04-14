@testable import SwiftGenStringsCore
import XCTest

final class LocalizedStringTests: XCTestCase {

    func testLocalizedStringWithPercent() {
        let string = LocalizedString(key: "", value: "100% Swift", comments: [])
        XCTAssertEqual("100% Swift", string.valueWithIndexedPlaceholders)
    }

    func testLocalizedStringWithTwoPercents() {
        let string = LocalizedString(key: "", value: "0% Obj-C - 100% Swift", comments: [])
        XCTAssertEqual("0% Obj-C - 100% Swift", string.valueWithIndexedPlaceholders)
    }

    func testLocalizedStringWith1Placeholder() {
        let string = LocalizedString(key: "", value: "%@ something", comments: [])
        XCTAssertEqual("%@ something", string.valueWithIndexedPlaceholders)
    }

    func testLocalizedStringWith2Placeholders() {
        let string = LocalizedString(key: "", value: "%@ at %@", comments: [])
        XCTAssertEqual("%1$@ at %2$@", string.valueWithIndexedPlaceholders)
    }

    func testLocalizedStringWith2FloatingPointPlaceholders() {
        let string = LocalizedString(key: "", value: "%2f at %.3f", comments: [])
        XCTAssertEqual("%1$2f at %2$.3f", string.valueWithIndexedPlaceholders)
    }

    func testLocalizedStringWithDoublePercent() {
        let string = LocalizedString(key: "", value: "%d%% Confidence", comments: [])
        XCTAssertEqual("%d%% Confidence", string.valueWithIndexedPlaceholders)
    }

}
