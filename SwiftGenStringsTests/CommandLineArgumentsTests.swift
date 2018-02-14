import XCTest

class CommandLineArgumentsTests: XCTestCase {

    func testEmptyArgs() {
        let args = try! CommandLineArguments(arguments: ["script_name"])
        XCTAssertTrue(args.showUsageAndExit)
    }

    func testHelpArg() {
        let args = try! CommandLineArguments(arguments: ["script_name", "--help"])
        XCTAssertTrue(args.showUsageAndExit)
    }

    func testShortHelpArg() {
        let args = try! CommandLineArguments(arguments: ["script_name", "-h"])
        XCTAssertTrue(args.showUsageAndExit)
    }

    func testSingleFilenameArg() {
        let args = try! CommandLineArguments(arguments: ["script_name", "Foo.swift"])
        XCTAssertFalse(args.showUsageAndExit)
        XCTAssertEqual(["Foo.swift"], args.filenames)
    }

    func testRoutineAndFilenamesArgs() {
        let args = try! CommandLineArguments(arguments: ["script_name", "-s", "XYLocalizedString", "file1", "file2", "file3"])
        XCTAssertEqual("XYLocalizedString", args.routine)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

    func testMissingRoutineArgError() {
        do {
            _ = try CommandLineArguments(arguments: ["script_name", "-s"])
            XCTFail("Initializer should have thrown an error")
        } catch let error as CommandLineArgumentError {
            XCTAssert(error == .missingRoutine)
        } catch {
            XCTFail("Invalid error type: \(error)")
        }
    }

    func testOutputDirAndFilenamesArgs() {
        let args = try! CommandLineArguments(arguments: ["script_name", "-o", "dir", "file1", "file2", "file3"])
        XCTAssertEqual("dir", args.outputDirectory)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

    func testMissingOutputDirArgError() {
        do {
            _ = try CommandLineArguments(arguments: ["script_name", "-o"])
            XCTFail("Initializer should have thrown an error")
        } catch let error as CommandLineArgumentError {
            XCTAssert(error == .missingOutputDirectory)
        } catch {
            XCTFail("Invalid error type: \(error)")
        }
    }

    func testRoutineOutputDirAndFilenamesArgs() {
        let args = try! CommandLineArguments(arguments: ["script_name", "-s", "XYLocalizedString", "-o", "dir", "file1", "file2", "file3"])
        XCTAssertEqual("XYLocalizedString", args.routine)
        XCTAssertEqual("dir", args.outputDirectory)
        XCTAssertEqual(["file1", "file2", "file3"], args.filenames)
    }

}
