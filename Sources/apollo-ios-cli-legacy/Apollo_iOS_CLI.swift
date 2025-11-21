import Foundation
import ArgumentParser
import CodegenCLI_Legacy

@main
struct Apollo_iOS_CLI: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "apollo-ios-cli",
    abstract: "A command line utility for Apollo iOS code generation.",
    version: CodegenCLI_Legacy.Constants.CLIVersion,
    subcommands: [
        CodegenCLI_Legacy.Initialize.self,
        CodegenCLI_Legacy.Generate.self,
        CodegenCLI_Legacy.FetchSchema.self,
        CodegenCLI_Legacy.GenerateOperationManifest.self
    ]
  )
}
