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

      return '''
class $className extends ${AnchorAccountClassName()} {
  $classFieldDeclarations
  
  $defaultConstructor
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

    var classFieldInitializations = argumentInitializations
        .join(',\n$DoubleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$accountName');";

    return '''
  $className()
      : $classFieldInitializations,
      $superInitialization''';
  }

  String _generateArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }
}