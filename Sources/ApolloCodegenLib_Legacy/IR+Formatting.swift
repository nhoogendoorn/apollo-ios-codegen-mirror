import Foundation
import GraphQLCompiler_Legacy
import IR_Legacy

extension GraphQLCompiler_Legacy.GraphQLType {

  var isListType: Bool {
    switch self {
    case .list: return true
    case let .nonNull(innerType): return innerType.isListType
    case .entity, .enum, .inputObject, .scalar: return false
    }
  }
  
}

extension IR_Legacy.EntityField {

  /// Takes the associated `IR_Legacy.EntityField` and formats it into a selection set name
  func formattedSelectionSetName(
    with pluralizer: Pluralizer
  ) -> String {
    IR_Legacy.Entity.Location.FieldComponent(name: responseKey, type: type)
      .formattedSelectionSetName(with: pluralizer)
  }

}

extension IR_Legacy.Entity.Location.FieldComponent {

  /// Takes the associated `IR_Legacy.Entity.Location.FieldComponent` and formats it into a selection set name
  func formattedSelectionSetName(
    with pluralizer: Pluralizer
  ) -> String {
    var fieldName = name.firstUppercased
    if type.isListType {
      fieldName = pluralizer.singularize(fieldName)
    }
    return fieldName.asSelectionSetName
  }

}

extension IR_Legacy.Entity.Location.SourceDefinition {

  /// Takes the associated `IR_Legacy.Entity.Location.SourceDefinition` and formats it into a selection set name
  func formattedSelectionSetName() -> String {
    switch self {
    case .operation: return "Data"
    case let .namedFragment(fragment): return fragment.generatedDefinitionName
    }
  }

}
