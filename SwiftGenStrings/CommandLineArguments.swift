import Foundation

class CommandLineArguments {

    class func standardArgumentsFromProcess() -> CommandLineArguments {
        return CommandLineArguments(arguments: Process.arguments)
    }

    private(set) var showUsageAndExit: Bool = false
    private(set) var routine: String = "NSLocalizedString"
    private(set) var outputDirectory: String? = nil // STDOUT
    private(set) var filenames: [String] = []

    var outputFilename: String? {
        guard let outputDirectory = outputDirectory else {
            return nil
        }
        // Harcoded Localizable.strings tableName
        return "\(outputDirectory)/Localizable.strings"
    }

    init(arguments: [String]) {
        if arguments.count < 2 {
            showUsageAndExit = true
            return
        }
        var consumables = Array(arguments[1..<arguments.count])
        while let flag = CommandLineArgument.consume(&consumables) {
            switch flag {
            case .Routine(let routine):
                self.routine = routine
            case .OutputDirectory(let outputDirectory):
                self.outputDirectory = outputDirectory
            }
        }
        self.filenames = consumables
    }

}

private enum CommandLineArgument {

    case Routine(String)
    case OutputDirectory(String)

    static func consume(inout arguments: [String]) -> CommandLineArgument? {
        if arguments.count < 2 {
            return nil
        }

        let argument: CommandLineArgument?
        switch arguments[0] {
        case "-s":
            argument = .Routine(arguments[1])
        case "-o":
            argument = .OutputDirectory(arguments[1])
        default:
            argument = nil
        }

        if argument != nil {
            arguments = Array(arguments[2..<arguments.count])
        }

        return argument
    }

}
