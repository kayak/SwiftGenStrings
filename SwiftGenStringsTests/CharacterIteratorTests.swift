import XCTest

class CharacterIteratorTests: XCTestCase {

    func testIteration() {
        let iterator = CharacterIterator(string: "Hello")
        XCTAssertEqual(iterator.next, "H")
        XCTAssertEqual(iterator.next, "e")
        XCTAssertEqual(iterator.next, "l")
        XCTAssertEqual(iterator.next, "l")
        XCTAssertEqual(iterator.next, "o")
        XCTAssertEqual(iterator.next, nil)
        XCTAssertEqual(iterator.previous, "l")
        XCTAssertEqual(iterator.previous, "l")
        XCTAssertEqual(iterator.previous, "e")
        XCTAssertEqual(iterator.previous, "H")
        XCTAssertEqual(iterator.previous, nil)
    }

}
