import ArgumentParser
import Foundation
import SwiftGenStringsCore

struct SwiftGenStrings: ParsableCommand {

    private static var abstract = """
    SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard genstrings command for Swift sources.
    The latter only supports the short form of the NSLocalizedString function but breaks as soon as you use any parameters other than key and comment as in
    """

    static let configuration = CommandConfiguration(
        commandName: "SwiftGenStrings",
        abstract: SwiftGenStrings.abstract,
        version: "0.0.2",
        helpNames: .shortAndLong
    )

    @Argument(help: "List of files, that are used as source of Localizable.strings generation.")
    var files: [URL]

    @Option(name: .short, help: "(Optional) Substitute for NSLocalizedString, useful when different macro is used.")
    var substitute: String?

    @Option(name: .short, help: "(Optional) Specifies what directory Localizable.strings table is created in. Not specifying output directory will print script output content to standard output (console).")
    var outputDirectory: URL?

    func run() throws {
        do {
            try ky_run()
        } catch let error as NSError {
            ErrorFormatter().writeFormattedError(error.localizedDescription)
            Darwin.exit(Int32(error.code))
        }
    }

    private func ky_run() throws {
        let collectionErrorOutput = LocalizedStringCollectionStandardErrorOutput()
        let finalStrings = LocalizedStringCollection(strings: [], errorOutput: collectionErrorOutput)

        let tokenizer = SwiftTokenizer()

        var numberOfWrittenErrors = 0
        for file in files {
            let contents = try String(contentsOf: file)
            let tokens = tokenizer.tokenizeSwiftString(contents)
            let errorOutput = LocalizedStringFinderStandardErrorOutput(fileURL: file)
            let finder = LocalizedStringFinder(routine: substitute ?? "NSLocalizedString", errorOutput: errorOutput)
            let strings = finder.findLocalizedStrings(tokens)
            let collection = LocalizedStringCollection(strings: strings, errorOutput: collectionErrorOutput)
            finalStrings.merge(with: collection)
            numberOfWrittenErrors += errorOutput.numberOfWrittenErrors + collectionErrorOutput.numberOfWrittenErrors
        }

        guard numberOfWrittenErrors == 0 else {
            let errorMessage = numberOfWrittenErrors == 1 ? "1 error was written" : "\(numberOfWrittenErrors) errors were written"
            throw NSError(description: errorMessage)
        }

        let output = finalStrings.formattedContent

        if let outputDirectory = outputDirectory {
            let outputFileURL = outputDirectory.appendingPathComponent("Localizable.strings")
            try output.ky_write(to: outputFileURL, atomically: false, encoding: .utf8)
        } else {
            print(output, terminator: "") // No newline at the end
        }
    }

}

SwiftGenStrings.main()
