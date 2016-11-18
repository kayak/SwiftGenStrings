import XCTest

class CommandLineArgumentsTests: XCTestCase {

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

}
