import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorInstructionGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    return idl['instructions']
        .map((instruction) {

          var instructionName = instruction['name'];
          var className = ExtendedInstructionClassName(idlName, instructionName);
          var classFieldDeclarations = _generateFieldDeclarations(idlName, instruction);
          var defaultConstructor = _generateDefaultConstructor(idlName, instruction);
          var withArgsConstructor = _generateWithArgsConstructor(idlName, instruction);
          var withAllConstructor = _generateWithAllConstructor(idlName, instruction);
          var withAccountsConstructor = _generateWithAccountsConstructor(idlName, instruction);

          return '''
class $className extends ${AnchorInstructionClassName()} {
  $classFieldDeclarations

  $defaultConstructor
  
  $withArgsConstructor
  
  $withAccountsConstructor
  
  $withAllConstructor
}
''';
        })
        .join('\n');
  }

  String _generateFieldDeclarations(String idlName, instruction) {
    var argumentDeclarations = instruction['args']
        .map((e) => _generateArgumentFieldDeclaration(idlName, e));

    var accountDeclarations = instruction['accounts']
        .map((e) => _generateAccountFieldDeclaration(e));

    return [...argumentDeclarations, ...accountDeclarations]
        .join('\n$HalfTab');
  }

  String _generateDefaultConstructor(String idlName, instruction) {
    var instructionName = instruction['name'];
    var className = ExtendedInstructionClassName(idlName, instructionName);

    var argumentInitializations = instruction['args']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldDefaultInitialization(idlName, arg, index);
    });

    var accountInitializations = instruction['accounts']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var account = e.value;

      return _generateAccountFieldDefaultInitialization(account, index);
    });

    var argsMapFieldInitializations = instruction['args']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldMapParameterDefaultInitialization(idlName, arg, index);
    })
        .join(',\n$TripleTab');

    var accountMapFieldInitializations = instruction['accounts']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var account = e.value;

      return _generateAccountFieldMapParameterDefaultInitialization(account, index);
    })
        .join(',\n$TripleTab');

    var classFieldInitializations = [...argumentInitializations, ...accountInitializations]
        .join(',\n$DoubleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$instructionName',\n$DoublePlusHalfTab" +
        "args: {\n$TripleTab$argsMapFieldInitializations},\n$DoublePlusHalfTab" +
        "accounts: {\n$TripleTab$accountMapFieldInitializations});";

    return '''
  $className()
      : $classFieldInitializations,
      $superInitialization''';
  }

  String _generateWithArgsConstructor(String idlName, instruction) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var argsParameters = instruction['args']
        .map((arg) => "${AnchorFieldDartType(arg['type'])} ${arg['name']}")
        .join(', ');

    var argsValues = instruction['args']
        .map((arg) => arg['name'])
        .join(', ');

    var accountValues = instruction['accounts']
        .map((account) => "${toCamelCase(account['name'])}Account.address")
        .join(', ');

    return '''
  $className withArgs($argsParameters) {
      return $className._withAll(
        $argsValues,
        $accountValues,
        true,
        accountsSet
      );
    }''';
  }

  String _generateWithAccountsConstructor(String idlName, instruction) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var accountsParameters = instruction['accounts']
        .map((account) => "String ${account['name']}")
        .join(', ');

    var argsValues = instruction['args']
        .map((arg) => "${toCamelCase(arg['name'])}Field.value")
        .join(', ');

    var accountValues = instruction['accounts']
        .map((account) => account['name'])
        .join(', ');

    return '''
  $className withAccounts($accountsParameters) {
      return $className._withAll(
        $argsValues,
        $accountValues,
        argsSet,
        true
      );
    }''';
  }

  String _generateWithAllConstructor(String idlName, instruction) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var withAllArgParameters = instruction['args']
        .map((arg) => "${AnchorFieldDartType(arg['type'])} ${arg['name']}");

    var withAllAccountParameters = instruction['accounts']
        .map((account) => "String ${account['name']}");

    var withAllDefaultParameters = ['bool argsSet', 'bool accountsSet'];

    var withAllParameters = [...withAllArgParameters, ...withAllAccountParameters, ...withAllDefaultParameters]
        .join(', ');

    var argumentInitializations = instruction['args']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldInitialization(idlName, arg, index);
    });

    var accountInitializations = instruction['accounts']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var account = e.value;

      return _generateAccountFieldInitialization(account, index);
    });

    var classFieldInitializations = [...argumentInitializations, ...accountInitializations]
        .join(',\n$DoubleTab');

    var argsMapFieldInitializations = instruction['args']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldMapParameterInitialization(idlName, arg, index);
    })
        .join(',\n$TripleTab');

    var accountMapFieldInitializations = instruction['accounts']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var account = e.value;

      return _generateAccountFieldMapParameterInitialization(account, index);
    })
        .join(',\n$TripleTab');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "name: '$instructionName',\n$DoublePlusHalfTab" +
        "args: {\n$TripleTab$argsMapFieldInitializations},\n$DoublePlusHalfTab" +
        "accounts: {\n$TripleTab$accountMapFieldInitializations});";

    return '''
  $className._withAll($withAllParameters)
      : $classFieldInitializations,
        $superInitialization
  ''';
  }

  String _generateArgumentFieldDeclaration(String idlName, Map<String, dynamic> arg) {
    return "final ${ExtendedAnchorFieldClassName(idlName, arg['type'])} ${toCamelCase(arg['name'])}Field;";
  }

  String _generateArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'])}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateArgumentFieldInitialization(String idlName, Map<String, dynamic> arg, int index) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'])}(name: '${arg['name']}', value: ${arg['name']}, index: $index)";
  }

  String _generateAccountFieldDeclaration(Map<String, dynamic> account) {
    return "final ${AnchorInstructionAccountClassName()} ${toCamelCase(account['name'])}Account;";
  }

  String _generateAccountFieldDefaultInitialization(Map<String, dynamic> account, int index) {
    return "${toCamelCase(account['name'])}Account = ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: '', index: $index)";
  }

  String _generateAccountFieldInitialization(Map<String, dynamic> account, int index) {
    return "${toCamelCase(account['name'])}Account = ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: ${account['name']}, index: $index)";
  }

  String _generateArgumentFieldMapParameterDefaultInitialization(String idlName, Map<String, dynamic> arg, int index) {
    return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'])}(name: '${arg['name']}', value: ${AnchorFieldDefaultValue(arg['type'])}, index: $index)";
  }

  String _generateAccountFieldMapParameterDefaultInitialization(Map<String, dynamic> account, int index) {
    return "'${toCamelCase(account['name'])}': ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: '', index: $index)";
  }

  String _generateArgumentFieldMapParameterInitialization(String idlName, Map<String, dynamic> arg, int index) {
    return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'])}(name: '${arg['name']}', value: ${arg['name']}, index: $index)";
  }

  String _generateAccountFieldMapParameterInitialization(Map<String, dynamic> account, int index) {
    return "'${toCamelCase(account['name'])}': ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: '${account['name']}', index: $index)";
  }
}