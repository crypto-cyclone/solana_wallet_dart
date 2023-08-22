import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorIDLGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    var className = ExtendedAnchorIDLClassName(idlName);
    var classFieldDeclarations = _generateFieldDeclarations(idl);
    var defaultConstructor = _generateDefaultConstructor(idl);

    return '''
class $className extends ${AnchorIDLClassName()} {
  $classFieldDeclarations
  
  $defaultConstructor
}
''';
  }

  String _generateFieldDeclarations(idl) {
    var idlName = idl['name'];

    var instructionDeclarations = idl['instructions']
        .map((instruction) => _generateInstructionFieldDeclaration(idlName, instruction));

    var accountFields = idl['accounts']
        .map((instruction) => _generateAccountFieldDeclaration(idlName, instruction));

    return [...instructionDeclarations, ...accountFields]
        .join('\n$HalfTab');
  }

  String _generateDefaultConstructor(idl) {
    var idlName = idl['name'];
    var version = idl['version'];
    var metadata = idl['metadata'];

    var className = ExtendedAnchorIDLClassName(idlName);

    var instructionFieldInitializations = idl['instructions']
        .map((e) => _generateInstructionFieldInitialization(idlName, e));

    var accountFieldInitializations = idl['accounts']
        .map((e) => _generateAccountFieldInitialization(e));

    var fieldInitializations = [...instructionFieldInitializations, ...accountFieldInitializations]
        .join(',\n$TabPlusHalf');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "version: '$version',\n$DoublePlusHalfTab" +
        "name: '$idlName',\n$DoublePlusHalfTab" +
        "metadata: ${AnchorMetadataClassName()}(address: '${metadata['address']}'));";

    return '''
$className()
    : $fieldInitializations,
      $superInitialization
''';
  }

  String _generateInstructionFieldDeclaration(String idlName, Map<String, dynamic> instruction) {
    var name = instruction['name'];
    return "final ${ExtendedInstructionClassName(idlName, name)} ${toCamelCase(name)}Instruction;";
  }

  String _generateInstructionFieldInitialization(String idlName, Map<String, dynamic> instruction) {
    var name = instruction['name'];
    return "${toCamelCase(name)}Instruction = ${ExtendedInstructionClassName(idlName, name)}()";
  }

  String _generateAccountFieldDeclaration(String idlName, Map<String, dynamic> account) {
    var name = account['name'];
    return "final ${AnchorAccountClassName()} ${toCamelCase(name)}Account;";
  }

  String _generateAccountFieldInitialization(Map<String, dynamic> account) {
    var name = account['name'];
    return "${toCamelCase(name)}Account = ${AnchorAccountClassName()}(name: '$name')";
  }
}