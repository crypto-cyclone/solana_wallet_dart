import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorIDLAccountGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    return idl['accounts']
        .map((account) {

      var accountName = account['name'];
      var className = ExtendedAccountClassName(idlName, accountName);
      var classFieldDeclarations = _generateFieldDeclarations(idlName, account, idl['types']);
      var defaultConstructor = _generateDefaultConstructor(idlName, account, idl['types']);
      var withFieldsConstructor = _generateWithFieldsConstructor(idlName, account, idl['types']);
      var deserializeFunction = _generateDeserializeFunction(idlName, account, idl['types']);

      return '''
class $className extends ${AnchorAccountClassName()} {
  $classFieldDeclarations
  
  $defaultConstructor
  
  $withFieldsConstructor
  
  $deserializeFunction
}
''';
    })
        .join('\n');
  }

  String _generateFieldDeclarations(String idlName, account, List<dynamic> types) {
    var argumentDeclarations = account['type']['fields']
        .map((e) => _generateArgumentFieldDeclaration(idlName, e, types));

    return argumentDeclarations
        .join('\n$HalfTab');
  }

  String _generateArgumentFieldConstructorInitialization(String idlName, Map<String, dynamic> arg, List<dynamic> types) {
    return "required this.${toCamelCase(arg['name'])}Field";
  }

  String _generateArgumentFieldDeclaration(String idlName, Map<String, dynamic> arg, List<dynamic> types) {
    return "final ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)} ${toCamelCase(arg['name'])}Field;";
  }

  String _generateDefaultConstructor(String idlName, account, List<dynamic> types) {
    var accountName = account['name'];
    var className = ExtendedAccountClassName(idlName, accountName);

    var argumentInitializations = account['type']['fields']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldDefaultInitialization(idlName, arg, index, types);
    });

    var fieldsMapFieldInitializations = account['type']['fields']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldMapParameterInitialization(idlName, arg, index, types);
    })
        .join(',\n$TripleTab');

    var classFieldInitializations = argumentInitializations
        .join(',\n$DoubleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$accountName',\n$DoublePlusHalfTab" +
        "fields: {\n$TripleTab" +
        "$fieldsMapFieldInitializations" +
        "});";
    return '''
  $className()
      : $classFieldInitializations,
      $superInitialization''';
  }

  String _generateWithFieldsConstructor(String idlName, account, List<dynamic> types) {
    var accountName = account['name'];

    var className = ExtendedAccountClassName(idlName, accountName);

    var fieldParameters = account['type']['fields']
        .map((field) => _generateArgumentFieldConstructorInitialization(idlName, field, types))
        .join(',\n$DoubleTab');

    var fieldsMapFieldInitializations = account['type']['fields']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldMapParameterInitialization(idlName, arg, index, types);
    })
        .join(',\n$TripleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$accountName',\n$DoublePlusHalfTab" +
        "fields: {\n$TripleTab" +
        "$fieldsMapFieldInitializations" +
        "});";

    return '''
  $className.withFields({
    $Tab$fieldParameters}) : $superInitialization
    ''';
  }

  String _generateDeserializeFunction(String idlName, account, List<dynamic> types) {
    var accountName = account['name'];

    var className = ExtendedAccountClassName(idlName, accountName);

    var withFieldConstructorFieldInitializations = account['type']['fields']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateFromBytesFunctionArguments(idlName, arg, index, types);
    })
        .join(',\n$DoublePlusHalfTab');

    return '''
  @override
  $HalfTab$className deserialize(List<int> bytes) {
      consumeDiscriminator(bytes);
      
      var deserialized = Map.fromEntries(
          fields.entries.map((element) =>
              MapEntry(element.key, element.value.deserialize(bytes))));
      
      return ${className}.withFields(
        $HalfTab$withFieldConstructorFieldInitializations
      );
    }
    ''';
  }

  String _generateFromBytesFunctionArguments(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "${toCamelCase(arg['name'])}Field: deserialized['${toCamelCase(arg['name'])}'] as ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}";
  }

  String _generateArgumentFieldMapParameterInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }
}