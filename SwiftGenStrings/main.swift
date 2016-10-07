import Foundation

let usage = "Please specify file to be processed, usage:" +
    "swift-genstrings [-o output_folder] input_filenames ..."

let args = CommandLineArguments.standardArgumentsFromProcess()

if args.showUsageAndExit {
    print(usage)
    exit(0)
}

let finalStrings = LocalizedStringCollection(strings: [])

for filename in args.filenames {
    var contents: String! // Can't do this in one line
    try! contents = String(contentsOfFile: filename)
    let tokens = SwiftTokenizer().tokenizeSwiftString(contents)
    let strings = StringFinder(routine: args.routine).findLocalizedStrings(tokens)
    let collection = LocalizedStringCollection(strings: strings)
    finalStrings.mergeWithCollection(collection)
}

let output = finalStrings.formattedContent

if let outputFilename = args.outputFilename {
    try! output.writeToFile(outputFilename, atomically: false, encoding: NSUTF8StringEncoding)
} else {
    print(output, terminator: "") // No newline at the end
}
