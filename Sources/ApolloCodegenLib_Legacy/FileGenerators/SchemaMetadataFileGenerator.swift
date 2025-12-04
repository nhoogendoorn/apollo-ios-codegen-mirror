import Foundation
import IR_Legacy
import OrderedCollections

/// Generates a file containing schema metadata used by the GraphQL executor at runtime.
struct SchemaMetadataFileGenerator: FileGenerator {
  /// Source IR schema.
  let schema: IR_Legacy.Schema
  /// Shared codegen configuration
  let config: ApolloCodegen.ConfigurationContext

  var template: any TemplateRenderer { SchemaMetadataTemplate(schema: schema, config: config) }
  var target: FileTarget { .schema }
  var fileName: String { "SchemaMetadata" }
}
