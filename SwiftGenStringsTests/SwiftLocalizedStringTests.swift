import Foundation
import XCTest

// I wasn't able to get @testable import working, files are added to this target manually.

class SwiftLocalizedStringTests: XCTestCase {

    // MARK: - CharacterIterator

    func testCharacterIterator() {
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

    // MARK: - SwiftTokenizer

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

    // MARK: - StringFinder

    func testFindStringsWithTableNameAndBundle() {
        let finder = StringFinder(routine: "NSLocalizedString")
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

    // MARK: - CommandLineArguments

    func testEmptyArgs() {
        let args = CommandLineArguments(arguments: ["script_name"])
        XCTAssertTrue(args.showUsageAndExit)
    }

    func testSingleFilenameArg() {
        let args = CommandLineArguments(arguments: ["script_name", "Foo.swift"])
        XCTAssertFalse(args.showUsageAndExit)
        XCTAssertEqual(["Foo.swift"], args.filenames)
    }

    func testRoutineAndFilenamesArgs() {
        let args = CommandLineArguments(arguments: ["script_name", "-s", "XYLocalizedString", "file1", "file2", "file3"])
        XCTAssertEqual("XYLocalizedString", args.routine)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

    func testOutputDirAndFilenamesArgs() {
        let args = CommandLineArguments(arguments: ["script_name", "-o", "dir", "file1", "file2", "file3"])
        XCTAssertEqual("dir", args.outputDirectory)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

    func testRoutineOutputDirAndFilenamesArgs() {
        let args = CommandLineArguments(arguments: ["script_name", "-s", "XYLocalizedString", "-o", "dir", "file1", "file2", "file3"])
        XCTAssertEqual("XYLocalizedString", args.routine)
        XCTAssertEqual("dir", args.outputDirectory)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

    // MARK: - LocalizedString

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
