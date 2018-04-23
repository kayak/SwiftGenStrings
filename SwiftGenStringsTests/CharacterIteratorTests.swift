import XCTest

class CharacterIteratorTests: XCTestCase {

    // MARK: - Iteration tests
    
    func testIteration() {
        let iterator = CharacterIterator(string: "Hello")
        XCTAssertEqual(iterator.current, nil)
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

    // MARK: - Advancing tests
    
    func testAdvance() {
        let iterator = CharacterIterator(string: "ABCD")
        iterator.advance(3)
        XCTAssertEqual(iterator.current, "C")
    }
    
    func testAdvanceWithNegative() {
        let iterator = CharacterIterator(string: "ABCD")
        _ = iterator.next
        _ = iterator.next
        iterator.advance(-1)
        XCTAssertEqual(iterator.current, "A")
    }
    
    func testCanNotAdvanceBeforeBeginning() {
        let iterator = CharacterIterator(string: "ABCD")
        _ = iterator.next
        iterator.advance(-1)
        XCTAssertEqual(iterator.current, "A")
    }
    
    func testCanNotAdvancePastEnd() {
        let iterator = CharacterIterator(string: "ABCD")
        iterator.advance(6)
        XCTAssertEqual(iterator.current, "D")
    }
    
    // MARK: - Whitespaces and newlines skipping tests
    
    func testSkipWhitespacesAndNewlines() {
        let iterator = CharacterIterator(string: "   \t\nABCD")
        _ = iterator.next
        iterator.skipWhitespacesAndNewlines()
        XCTAssertEqual(iterator.current, "A")
    }
    
    func testSkipWhitespacesAndNewlinesDoesNotSkip() {
        let iterator = CharacterIterator(string: "12345   \t\nABCD")
        _ = iterator.next
        iterator.skipWhitespacesAndNewlines()
        XCTAssertEqual(iterator.current, "1")
    }
    
    // MARK: - Starts with tests
    
    func testStartsWith() {
        let iterator = CharacterIterator(string: "ABCDEFG")
        _ = iterator.next
        _ = iterator.next
        XCTAssertTrue(iterator.startsWith("BCD"))
    }
    
    func testStartsWithFalseForIteratorWithNegativeIndex() {
        let iterator = CharacterIterator(string: "ABCDEFG")
        XCTAssertFalse(iterator.startsWith("ABCD"))
    }
    
    func testDoesNotStartsWith() {
        let iterator = CharacterIterator(string: "ABCDEFG")
        _ = iterator.next
        XCTAssertFalse(iterator.startsWith("1234"))
    }
    
}
