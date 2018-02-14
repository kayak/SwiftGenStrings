import Foundation

enum CommandLineArgumentError: Error {

    case missingRoutine
    case missingOutputDirectory

    /// Error message to be displayed to user.
    /// Note: Conforming to `LocalizedError` isn't an option, since CLI apps don't support bundles.
    var message: String {
        switch self {
        case .missingRoutine:
            return "Routine argument used, but routine name was not supplied"
        case .missingOutputDirectory:
            return "Output directory argument used, but directory was not supplied"
        }
    }

}

class CommandLineArguments {

    class func standardArgumentsFromProcess() throws -> CommandLineArguments {
        return try CommandLineArguments(arguments: CommandLine.arguments)
    }

    private(set) var showUsageAndExit: Bool = false
    private(set) var routine: String = "NSLocalizedString"
    private(set) var outputDirectory: String? // STDOUT
    private(set) var filenames: [String] = []

    private let tableName = "Localizable.strings"

    var outputFilename: String? {
        guard let outputDirectory = outputDirectory else {
            return nil
        }
        return "\(outputDirectory)/\(tableName)"
    }

    init(arguments: [String]) throws {
        if arguments.count < 2 {
            showUsageAndExit = true
            return
        }
        var consumables = Array(arguments[1..<arguments.count])
        while let flag = try CommandLineArgument.consume(&consumables) {
            switch flag {
            case .help:
                self.showUsageAndExit = true
            case .routine(let routine):
                self.routine = routine
            case .outputDirectory(let outputDirectory):
                self.outputDirectory = outputDirectory
            case .filenames(let filenames):
                self.filenames = filenames
            }
        }
    }

}

private enum CommandLineArgument {

    case help
    case routine(String)
    case outputDirectory(String)
    case filenames([String])

    static func consume(_ arguments: inout [String]) throws -> CommandLineArgument? {
        guard arguments.count >= 1 else {
            return nil
        }

        let argument: CommandLineArgument?
        switch arguments[0] {
        case  "-h", "--help":
            argument = .help
            arguments = []
        case "-s":
            guard arguments.count >= 2 else {
                throw CommandLineArgumentError.missingRoutine
            }
            argument = .routine(arguments[1])
            arguments = Array(arguments[2..<arguments.count])
        case "-o":
            guard arguments.count >= 2 else {
                throw CommandLineArgumentError.missingOutputDirectory
            }
            argument = .outputDirectory(arguments[1])
            arguments = Array(arguments[2..<arguments.count])
        default:
            argument = .filenames(arguments)
            arguments =  []
        }

        return argument
    }

}
