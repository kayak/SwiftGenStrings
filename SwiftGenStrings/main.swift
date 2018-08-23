import Foundation

let version = "0.0.1"
let usage = """
SwiftGenStrings files
SwiftGenStrings [-s <routine>] [-o <outputDir>] files
SwiftGenStrings [-h|--help]

OPTIONS
-h|--help
    (Optional) Print help.
-v|--version
(Optional) Print version.
-s routine
    (Optional) Substitute routine for NSLocalizedString, useful when different macro is used.
-o outputDir
    (Optional) Specifies what directory Localizable.strings table is created in.
    Not specifying output directory will print script output content to standard output (console).
files
    List of files, that are used as source of Localizable.strings generation.
"""

let args: CommandLineArguments = {
    do {
        return try CommandLineArguments.standardArgumentsFromProcess()
    } catch let error as CommandLineArgumentError {
        print("Failed to parse command line arguments:")
        print("  \(error.message)")
        exit(1)
    } catch {
        print("Unexpected error:")
        print("  \(error)")
        exit(1)
    }
}()

if args.showUsageAndExit {
    print(usage)
    exit(0)
}

if args.showVersionAndExit {
    print(version)
    exit(0)
}

let collectionErrorOutput = LocalizedStringCollectionStandardErrorOutput()
let finalStrings = LocalizedStringCollection(strings: [], errorOutput: collectionErrorOutput)

var errorEncountered = false
   
for filename in args.filenames {
    let contents = try! String(contentsOfFile: filename)
    let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
    let errorOutput = LocalizedStringFinderStandardErrorOutput(filename: filename)
    let finder = LocalizedStringFinder(routine: args.routine, errorOutput: errorOutput)
    let strings = finder.findLocalizedStrings(tokens)
    let collection = LocalizedStringCollection(strings: strings, errorOutput: collectionErrorOutput)
    finalStrings.merge(with: collection)
    errorEncountered = errorEncountered || errorOutput.hasWrittenError || collectionErrorOutput.hasWrittenError
}

if errorEncountered {
    exit(1)
}

let output = finalStrings.formattedContent

if let outputFilename = args.outputFilename {
    try! output.write(toFile: outputFilename, atomically: false, encoding: String.Encoding.utf8)
} else {
    print(output, terminator: "") // No newline at the end
}
