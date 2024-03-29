import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorInstructionGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    return idl['instructions']
        .map((instruction) {

          var instructionName = instruction['name'];
          var className = ExtendedInstructionClassName(idlName, instructionName);
          var classFieldDeclarations = _generateFieldDeclarations(idlName, instruction, idl['types']);
          var defaultConstructor = _generateDefaultConstructor(idlName, instruction, idl['types']);
          var withArgsConstructor = _generateWithArgsConstructor(idlName, instruction, idl['types']);
          var withAllConstructor = _generateWithAllConstructor(idlName, instruction, idl['types']);
          var withAccountsConstructor = _generateWithAccountsConstructor(idlName, instruction, idl['types']);

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

  String _generateFieldDeclarations(String idlName, instruction, List<dynamic> types) {
    var argumentDeclarations = instruction['args']
        .map((e) => _generateArgumentFieldDeclaration(idlName, e, types));

    var accountDeclarations = instruction['accounts']
        .map((e) => _generateAccountFieldDeclaration(e));

    return [...argumentDeclarations, ...accountDeclarations]
        .join('\n$HalfTab');
  }

  String _generateDefaultConstructor(String idlName, instruction, List<dynamic> types) {
    var instructionName = instruction['name'];
    var className = ExtendedInstructionClassName(idlName, instructionName);

    var argumentInitializations = instruction['args']
        .asMap()
        .entries
        .map((e) {
      var index = e.key;
      var arg = e.value;

      return _generateArgumentFieldDefaultInitialization(idlName, arg, index, types);
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

      return _generateArgumentFieldMapParameterDefaultInitialization(idlName, arg, index, types);
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

  String _generateWithArgsConstructor(String idlName, instruction, List<dynamic> types) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var argsParameters = instruction['args']
        .map((arg) => "${AnchorFieldDartType(idlName, arg['type'], types)} ${arg['name']}")
        .join(', ');

    var argsValues = instruction['args']
        .map((arg) => arg['name'])
        .join(', ');

    if (argsValues.toString().trim().isNotEmpty) {
      argsValues += ',';
    } else {
      argsValues = "";
    }

    var accountValues = instruction['accounts']
        .map((account) => "${toCamelCase(account['name'])}Account.address")
        .join(', ');

    if (accountValues.toString().trim().isNotEmpty) {
      accountValues += ',';
    } else {
      accountValues = "";
    }

    return '''
  $className withArgs($argsParameters) {
      return $className._withAll(
        $argsValues
        $accountValues
        true,
        accountsSet
      );
    }''';
  }

  String _generateWithAccountsConstructor(String idlName, instruction, List<dynamic> types) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var accountsParameters = instruction['accounts']
        .map((account) => "String ${account['name']}")
        .join(', ');

    var argsValues = instruction['args']
        .map((arg) {
          var extendedAnchorFieldClassName = ExtendedAnchorFieldClassName(idlName, arg['type'], types);

          if (extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldArray' || extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldNullableArray') {
            return "${toCamelCase(arg['name'])}Field.dartValue()${AnchorFieldArrayTypeCaster(idlName, arg['type'], types)}";
          }

          return "${toCamelCase(arg['name'])}Field.dartValue()";
        })
        .join(', ');

    if (argsValues.toString().trim().isNotEmpty) {
      argsValues += ',';
    } else {
      argsValues = "";
    }

    var accountValues = instruction['accounts']
        .map((account) => account['name'])
        .join(', ');

    if (accountValues.toString().trim().isNotEmpty) {
      accountValues += ',';
    } else {
      accountValues = "";
    }

    return '''
  $className withAccounts($accountsParameters) {
      return $className._withAll(
        $argsValues
        $accountValues
        argsSet,
        true
      );
    }''';
  }

  String _generateWithAllConstructor(String idlName, instruction, List<dynamic> types) {
    var instructionName = instruction['name'];

    var className = ExtendedInstructionClassName(idlName, instructionName);

    var withAllArgParameters = instruction['args']
        .map((arg) => "${AnchorFieldDartType(idlName, arg['type'], types)} ${arg['name']}");

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

      return _generateArgumentFieldInitialization(idlName, arg, index, types);
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

      return _generateArgumentFieldMapParameterInitialization(idlName, arg, index, types);
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
        "accounts: {\n$TripleTab$accountMapFieldInitializations},\n$DoublePlusHalfTab" +
        "argsSet: argsSet,\n$DoublePlusHalfTab" +
        "accountsSet: accountsSet);";

    return '''
  $className._withAll($withAllParameters)
      : $classFieldInitializations,
        $superInitialization
  ''';
  }

  String _generateArgumentFieldDeclaration(String idlName, Map<String, dynamic> arg, List<dynamic> types) {
    return "final ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)} ${toCamelCase(arg['name'])}Field;";
  }

  String _generateArgumentFieldDefaultInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "${toCamelCase(arg['name'])}Field = ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(value: ${AnchorFieldDefaultValue(idlName, arg['type'], types)})";
  }

  String _generateArgumentFieldInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    var extendedAnchorFieldClassName = ExtendedAnchorFieldClassName(idlName, arg['type'], types);

    if (extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldArray' || extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldNullableArray') {
      return "${toCamelCase(arg['name'])}Field = ${extendedAnchorFieldClassName}(value: ${arg['name']}${AnchorFieldDartInitializerType(idlName, arg['type'], types)})";
    } else {
      return "${toCamelCase(arg['name'])}Field = ${extendedAnchorFieldClassName}(value: ${arg['name']})";
    }
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

  String _generateArgumentFieldMapParameterDefaultInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(value: ${AnchorFieldDefaultValue(idlName, arg['type'], types)})";
  }

  String _generateAccountFieldMapParameterDefaultInitialization(Map<String, dynamic> account, int index) {
    return "'${toCamelCase(account['name'])}': ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: '', index: $index)";
  }

  String _generateArgumentFieldMapParameterInitialization(String idlName, Map<String, dynamic> arg, int index, List<dynamic> types) {
    var extendedAnchorFieldClassName = ExtendedAnchorFieldClassName(idlName, arg['type'], types);

    if (extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldArray' || extendedAnchorFieldClassName.split('<')[0] == 'AnchorFieldNullableArray') {
      return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(value: ${arg['name']}${AnchorFieldDartInitializerType(idlName, arg['type'], types)})";
    } else {
      return "'${toCamelCase(arg['name'])}': ${ExtendedAnchorFieldClassName(idlName, arg['type'], types)}(value: ${arg['name']})";
    }
  }

  String _generateAccountFieldMapParameterInitialization(Map<String, dynamic> account, int index) {
    return "'${toCamelCase(account['name'])}': ${AnchorInstructionAccountClassName()}(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: ${account['name']}, index: $index)";
  }
}