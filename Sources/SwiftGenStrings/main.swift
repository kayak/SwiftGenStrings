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

	static var configuration: CommandConfiguration {
		CommandConfiguration(commandName: "SwiftGenStrings", abstract: "TODO", version: "0.0.2", helpNames: .shortAndLong)
	}

	@Option(name: .shortAndLong, help: "Substitute for NSLocalizedString, useful when different macro is used.")
	var substitute: String?

	@Option(name: .shortAndLong, help: "Specifies what directory Localizable.strings table is created in. Not specifying output directory will print script output content to standard output (console).")
	var outputDirectory: URL?

	@Argument()
	var files: [URL]

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
			Darwin.exit(1)
		}

		let output = finalStrings.formattedContent

		if let outputDirectory = outputDirectory {
			try output.write(to: outputDirectory, atomically: false, encoding: .utf8)
		} else {
			print(output, terminator: "") // No newline at the end
		}
	}

}

SwiftGenStrings.main()
