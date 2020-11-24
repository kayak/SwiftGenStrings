import ArgumentParser
import Foundation
import SwiftGenStringsCore

extension URL: ExpressibleByArgument {

	public init?(argument: String) {
		if argument.hasPrefix("~/") {
			let cleanedPath = String(argument.dropFirst())
			self.init(fileURLWithPath: cleanedPath, relativeTo: FileManager.default.homeDirectoryForCurrentUser)
		} else {
			self.init(fileURLWithPath: argument)
		}
	}

}

struct SwiftGenStrings: ParsableCommand {

	private static var abstract = """
	SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard genstrings command for Swift sources.
	The latter only supports the short form of the NSLocalizedString function but breaks as soon as you use any parameters other than key and comment as in
	"""

	static var configuration: CommandConfiguration {
		CommandConfiguration(commandName: "SwiftGenStrings", abstract: SwiftGenStrings.abstract, version: "0.0.2", helpNames: .shortAndLong)
	}

    @Argument(help: "List of files, that are used as source of Localizable.strings generation.")
    var files: [URL]

	@Option(name: .short, help: "(Optional) Substitute for NSLocalizedString, useful when different macro is used.")
	var substitute: String?

	@Option(name: .short, help: "(Optional) Specifies what directory Localizable.strings table is created in. Not specifying output directory will print script output content to standard output (console).")
	var outputDirectory: URL?

	func run() throws {
		let collectionErrorOutput = LocalizedStringCollectionStandardErrorOutput()
		let finalStrings = LocalizedStringCollection(strings: [], errorOutput: collectionErrorOutput)

		var errorEncountered = false
		for file in files {
			let contents = try String(contentsOf: file)
			let tokens = SwiftTokenizer.tokenizeSwiftString(contents)
			let errorOutput = LocalizedStringFinderStandardErrorOutput(fileURL: file)
			let finder = LocalizedStringFinder(routine: substitute ?? "NSLocalizedString", errorOutput: errorOutput)
			let strings = finder.findLocalizedStrings(tokens)
			let collection = LocalizedStringCollection(strings: strings, errorOutput: collectionErrorOutput)
			finalStrings.merge(with: collection)
			errorEncountered = errorEncountered || errorOutput.hasWrittenError || collectionErrorOutput.hasWrittenError
		}

		if errorEncountered {
			throw NSError(description: "Error encountered")
		}

		let output = finalStrings.formattedContent

		if let outputDirectory = outputDirectory {
			try output.ky_write(to: outputDirectory, atomically: false, encoding: .utf8, createDirectoryIfNonExisting: true)
		} else {
			print(output, terminator: "") // No newline at the end
		}
	}

}

SwiftGenStrings.main()
