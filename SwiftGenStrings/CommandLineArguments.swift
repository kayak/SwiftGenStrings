import Foundation

class CommandLineArguments {

    class func standardArgumentsFromProcess() -> CommandLineArguments {
        return CommandLineArguments(arguments: CommandLine.arguments)
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

    init(arguments: [String]) {
        if arguments.count < 2 {
            showUsageAndExit = true
            return
        }
        var consumables = Array(arguments[1..<arguments.count])
        while let flag = CommandLineArgument.consume(&consumables) {
            switch flag {
            case .routine(let routine):
                self.routine = routine
            case .outputDirectory(let outputDirectory):
                self.outputDirectory = outputDirectory
            }
        }
        self.filenames = consumables
    }

}

private enum CommandLineArgument {

    case routine(String)
    case outputDirectory(String)

    static func consume(_ arguments: inout [String]) -> CommandLineArgument? {
        if arguments.count < 2 {
            return nil
        }

        let argument: CommandLineArgument?
        switch arguments[0] {
        case "-s":
            argument = .routine(arguments[1])
        case "-o":
            argument = .outputDirectory(arguments[1])
        default:
            argument = nil
        }

        if argument != nil {
            arguments = Array(arguments[2..<arguments.count])
        }

        return argument
    }

}
