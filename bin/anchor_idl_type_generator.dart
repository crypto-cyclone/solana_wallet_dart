import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorIDlTypeGenerator {
  String generate(idl) {
    var idlName = idl['name'];
    var types = idl['types']
      .map((e) {
        if (e['type']['kind'] == 'struct') {
          return _generateStructClass(idlName, e, idl['types']);
        } else if (e['type']['kind'] == 'enum') {
          return _generateEnumClass(idlName, e);
        }

        throw ArgumentError('Unknown type structure');
      })
      .join('\n');


    return types;
  }

  String _generateStructClass(String idlName, object, List<dynamic> types) {
    var name = object['name'];

    var className = ExtendedStructClassName(idlName, name);
    var fieldDeclarations = object['type']['fields']
        .map((e) => _generateStructFieldDeclaration(idlName, e, types))
        .join('\n$HalfTab');

    var defaultConstructor = _generateStructDefaultConstructor(idlName, object, types);
    var withFieldsConstructor = _generateWithFieldsConstructor(idlName, object, types);

    return '''
class $className extends ${AnchorStructClassName()} {
  $fieldDeclarations
  
  $defaultConstructor
  
  $withFieldsConstructor
}
''';
  }

  String _generateEnumClass(String idlName, object) {
    var name = object['name'];

    var enumName = ExtendedEnumName(idlName, name);
    var enumOptions = _generateEnumOptions(object);

    return '''
enum $enumName {
  $enumOptions
}  
''';
  }

  String _generateStructFieldDeclaration(String idlName, field, List<dynamic> types) {
    var name = field['name'];
    var type = field['type'];

    return "final ${ExtendedAnchorFieldClassName(idlName, type, types)} ${name}Field;";
  }

  String _generateStructDefaultConstructor(String idlName, object, List<dynamic> types) {
    var name = object['name'];
    var className = ExtendedStructClassName(idlName, name);

    var fieldInitializations = object['type']['fields']
        .asMap()
        .entries
        .map((e) {
          var index = e.key;
          var object = e.value;
          return _generateStructArgumentFieldDefaultInitialization(idlName, object, index, types);
        })
        .join(',\n$TabPlusHalf');

    var fieldsMapFieldInitializations = object['type']['fields']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldMapParameterInitialization(idlName, arg, index, types);
    })
        .join(',\n$TripleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$name',\n$DoublePlusHalfTab" +
        "fields: {\n$TripleTab" +
        "$fieldsMapFieldInitializations" +
        "});";

    return '''
$className()
    : $fieldInitializations,
      $superInitialization
''';
  }

  String _generateWithFieldsConstructor(String idlName, object, List<dynamic> types) {
    var accountName = object['name'];

    var className = ExtendedStructClassName(idlName, accountName);

    var fieldParameters = object['type']['fields']
        .map((field) => _generateArgumentFieldConstructorInitialization(idlName, field, types))
        .join(',\n$DoubleTab');

    var fieldsMapFieldInitializations = object['type']['fields']
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

  String _generateArgumentFieldConstructorInitialization(String idlName, Map<String, dynamic> arg, List<dynamic> types) {
    return "required this.${toCamelCase(arg['name'])}Field";
  }

  String _generateStructArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateArgumentFieldMapParameterInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateEnumOptions(object) {
    return object['type']['variants']
        .map((e) => e['name'].toUpperCase())
        .join(',\n$HalfTab');
  }
}