import TemplateString_Legacy

extension TemplateString.StringInterpolation {

  mutating func appendInterpolation(
    documentation: @autoclosure () -> String?,
    config: ApolloCodegen.ConfigurationContext
  ) {
    guard config.options.schemaDocumentation == .include else {
      removeLineIfEmpty()
      return
    }

    appendInterpolation(documentation: documentation())
  }

}
