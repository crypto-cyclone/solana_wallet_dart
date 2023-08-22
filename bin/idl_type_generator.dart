import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorIDlTypeGenerator {
  String generate(idl) {
    var idlName = idl['name'];
    var types = idl['types']
      .map((e) {
        if (e['type']['kind'] == 'struct') {
          return _generateStructClass(idlName, e);
        } else if (e['type']['kind'] == 'enum') {
          return _generateEnumClass(idlName, e);
        }

        throw ArgumentError('Unknown type structure');
      })
      .join('\n');


    return types;
  }

  String _generateStructClass(String idlName, object) {
    var name = object['name'];

    var className = ExtendedStructClassName(idlName, name);
    var fieldDeclarations = object['type']['fields']
        .map((e) => _generateStructFieldDeclaration(idlName, e))
        .join('\n$HalfTab');

    var defaultConstructor = _generateStructDefaultConstructor(idlName, object);

    return '''
class $className extends ${AnchorStructClassName()} {
  $fieldDeclarations
  
  $defaultConstructor
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

  String _generateStructFieldDeclaration(String idlName, field) {
    var name = field['name'];
    var type = field['type'];

    return "final ${ExtendedAnchorFieldClassName(idlName, type)} ${name}Field;";
  }

  String _generateStructDefaultConstructor(String idlName, object) {
    var name = object['name'];
    var className = ExtendedStructClassName(idlName, name);

    var fieldInitializations = object['type']['fields']
        .asMap()
        .entries
        .map((e) {
          var index = e.key;
          var object = e.value;
          return _generateStructArgumentFieldDefaultInitialization(idlName, object, index);
        })
        .join(',\n$TabPlusHalf');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$name');";

    return '''
$className()
    : $fieldInitializations,
      $superInitialization
''';
  }

  String _generateStructArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'])}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateEnumOptions(object) {
    return object['type']['variants']
        .map((e) => e['name'].toUpperCase())
        .join(',\n$HalfTab');
  }
}