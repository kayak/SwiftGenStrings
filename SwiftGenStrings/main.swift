import Foundation

let usage = "Please specify file to be processed, usage:" +
    "swift-genstrings [-o output_folder] input_filenames ..."

let args = CommandLineArguments.standardArgumentsFromProcess()

if args.showUsageAndExit {
    print(usage)
    exit(0)
}

let collectionErrorOutput = LocalizedStringCollectionStandardErrorOutput()
let finalStrings = LocalizedStringCollection(strings: [], errorOutput: collectionErrorOutput)

for filename in args.filenames {
    let contents = try! String(contentsOfFile: filename)
    let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
    let errorOutput = LocalizedStringFinderStandardErrorOutput(filename: filename)
    let finder = LocalizedStringFinder(routine: args.routine, errorOutput: errorOutput)
    let strings = finder.findLocalizedStrings(tokens)
    let collection = LocalizedStringCollection(strings: strings, errorOutput: collectionErrorOutput)
    finalStrings.merge(with: collection)
}

let output = finalStrings.formattedContent

if let outputFilename = args.outputFilename {
    try! output.write(toFile: outputFilename, atomically: false, encoding: String.Encoding.utf8)
} else {
    print(output, terminator: "") // No newline at the end
}
