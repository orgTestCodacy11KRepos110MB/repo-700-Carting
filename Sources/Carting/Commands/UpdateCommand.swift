//
//  Copyright © 2019 Artem Novichkov. All rights reserved.
//

import SPMUtility
import CartingCore

final class UpdateCommand: Command {

    var command = "update"
    var overview = "Adds a new script with input/output file paths or updates the script named `Carthage`."

    private let name: OptionArgument<String>
    private let projectPath: OptionArgument<String>
    private let format: OptionArgument<Format>
    private let targetName: OptionArgument<String>

    private lazy var frameworkInformationService: FrameworkInformationService = .init()

    required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        name = subparser.add(option: "--script",
                             shortName: "-s",
                             usage: "The name of Carthage script.")
        projectPath = subparser.add(option: "--path",
                             shortName: "-p",
                             usage: "The project directory path.",
                             completion: .filename)
        format = subparser.add(option: "--format",
                               shortName: "-f",
                               usage: "Format of input/output file paths: file - using simple paths, list - using xcfilelists",
                               completion: Format.completion)
        targetName = subparser.add(option: "--target",
                                   shortName: "-t",
                                   usage: "The name of target.")
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let name = arguments.get(self.name) ?? "Carthage"
        let projectPath = arguments.get(self.projectPath)
        let format = arguments.get(self.format) ?? .list
        let targetName = arguments.get(self.targetName)
        frameworkInformationService.projectPath = projectPath
        try frameworkInformationService.updateScript(withName: name,
                                                     format: format,
                                                     targetName: targetName)
    }
}