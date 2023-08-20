import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:solana_wallet/util/string.dart';

var idlName = "";

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    printHelp();
    return;
  }

  var inputDirPath = 'idl'; // Default input directory
  var outputDirPath = 'lib/generated'; // Default output directory

  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--input-dir' && i + 1 < args.length) {
      inputDirPath = args[i + 1];
    } else if (args[i] == '--output-dir' && i + 1 < args.length) {
      outputDirPath = args[i + 1];
    }
  }

  var inputDir = Directory(inputDirPath);
  if (!inputDir.existsSync()) {
    print('Input directory does not exist: $inputDirPath');
    exit(1);
  }

  var outputDir = Directory(outputDirPath);
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (var file in inputDir.listSync().where((f) => f is File && f.path.endsWith('.json'))) {
    var idlString = File(file.path).readAsStringSync();
    var idl = json.decode(idlString);

    var fileName = basenameWithoutExtension(file.path);

    var dartCode = generateIDL(idl);

    var outputPath = '$outputDirPath/${toSnakeCase(fileName)}.dart';
    File(outputPath).writeAsStringSync(dartCode.toString());

    print('Generated code for ${file.path} -> $outputPath');
  }
}

String generateIDL(Map<String, dynamic> idl) {
  idlName = idl['name'];

  var version = idl['version'];
  var metadata = idl['metadata'];

  var instructionFields = idl['instructions']
      .map((instruction) => generateInstructionFieldDeclaration(instruction))
      .join('\n  ');

  var instructionInitialization = idl['instructions']
      .map((instruction) => generateInstructionFieldInitialization(instruction))
      .join(',\n        ');

  var accountFields = idl['accounts']
      .map((instruction) => generateAccountFieldDeclaration(instruction))
      .join('\n  ');

  var accountInitialization = idl['accounts']
      .map((instruction) => generateAccountFieldInitialization(instruction))
      .join(',\n        ');

  var instructionClasses = idl['instructions']
      .map((instruction) => generateInstructionClass(instruction))
      .join('\n');

  var accountClasses = idl['accounts']
      .map((account) => generateAccountClass(account))
      .join('\n');

  var typeClasses = idl['types']
      .map((type) => generateTypeClass(type))
      .join('\n');

  var errorClasses = idl['errors']
    .map((error) => generateErrorClass(error))
    .join('\n');

  return '''
import 'dart:typed_data';
  
import 'package:solana_wallet/domain/model/anchor/anchor_idl.dart';

class ${toPascalCase(idlName)} extends AnchorIDL {
  $instructionFields
  $accountFields
  
  ${toPascalCase(idlName)}()
      : $instructionInitialization,
        $accountInitialization,
        super(version: '$version', name: '$idlName',metadata: AnchorMetadata(address: '${metadata['address']}'));
}

$instructionClasses
$accountClasses
$typeClasses
$errorClasses
''';
}

String generateInstructionClass(Map<String, dynamic> instruction) {
  var name = instruction['name'];
  var pascalName = toPascalCase(name);
  var pascalIdlName = toPascalCase(idlName);

  var args = instruction['args']
      .map((arg) =>
  "final ${capitalize(className(arg['type']))} ${arg['name']}Arg;")
      .join('\n  ');

  var argsInitialization = instruction['args']
      .map((arg) =>
  "${arg['name']}Arg = ${capitalize(className(arg['type']))}(name: '${arg['name']}', value: ${defaultValue(arg['type'])}),")
      .join('\n        ');

  var accounts = instruction['accounts']
      .map((account) =>
  "final AnchorInstructionAccount ${account['name']};")
      .join('\n  ');

  var accountsInitialization = instruction['accounts']
      .map((account) =>
  "${account['name']} = AnchorInstructionAccount(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: ''),")
      .join('\n        ');

  var withArgsParameters = instruction['args']
      .map((arg) => "${dartType(arg['type'])} ${arg['name']}")
      .join(', ');

  var withArgsValues = instruction['args']
      .map((arg) => arg['name'])
      .join(', ');

  var withAccountsParameters = instruction['accounts']
      .map((account) => "String ${account['name']}")
      .join(', ');

  var withAccountsValues = instruction['accounts']
      .map((account) => account['name'])
      .join(', ');

  var withAccountArgsValues = instruction['args']
      .map((arg) => "${arg['name']}Arg.value")
      .join(', ');

  var withArgsAccountValues = instruction['accounts']
      .map((account) => "${account['name']}.address")
      .join(', ');

  var withAllParameters = instruction['args']
      .map((arg) => "${dartType(arg['type'])} ${arg['name']}")
      .join(', ') +
      ', ' +
      instruction['accounts']
          .map((account) => "String ${account['name']}")
          .join(', ') +
      ', bool argsSet, bool accountsSet';

  var withAllValues = instruction['args']
      .map((arg) => "${arg['name']}Arg = ${capitalize(className(arg['type']))}(name: '${arg['name']}', value: ${arg['name']})")
      .join(',\n        ') +
      ',\n        ' +
      instruction['accounts']
          .map((account) => "${account['name']} = AnchorInstructionAccount(name: '${account['name']}', isMut: ${account['isMut']}, isSigner: ${account['isSigner']}, address: ${account['name']})")
          .join(',\n        ') +
      ',\n        super(name: "$name", argsSet: argsSet, accountsSet: accountsSet);';

  return '''
class $pascalIdlName$pascalName extends AnchorInstruction {
  $args
  $accounts

  $pascalIdlName$pascalName()
      : $argsInitialization
        $accountsInitialization
        super(name: '$name');

  $pascalIdlName$pascalName withArgs($withArgsParameters) {
    return $pascalIdlName$pascalName._withAll(
        $withArgsValues,
        $withArgsAccountValues,
        true,
        accountsSet
    );
}

  $pascalIdlName$pascalName withAccounts($withAccountsParameters) {
    return $pascalIdlName$pascalName._withAll(
        $withAccountArgsValues,
        $withAccountsValues,
        argsSet,
        true
    );
  }

  $pascalIdlName$pascalName._withAll(
      $withAllParameters)
      : $withAllValues
}
''';
}

String generateInstructionFieldDeclaration(Map<String, dynamic> instruction) {
  var name = instruction['name'];
  var pascalName = toPascalCase(name);
  var camelName = toCamelCase(name);
  var pascalIdlName = toPascalCase(idlName);

  return "final $pascalIdlName$pascalName ${camelName}Instruction;";
}

String generateInstructionFieldInitialization(Map<String, dynamic> instruction) {
  var name = instruction['name'];
  var pascalName = toPascalCase(name);
  var camelName = toCamelCase(name);
  var pascalIdlName = toPascalCase(idlName);

  return "${camelName}Instruction = $pascalIdlName$pascalName()";
}

String generateAccountClass(Map<String, dynamic> account) {
  var name = account['name'];
  var pascalName = toPascalCase(name);
  var pascalIdlName = toPascalCase(idlName);

  var fields = account['type']['fields']
      .map((arg) =>
  "final ${capitalize(className(arg['type']))} ${arg['name']}Arg;")
      .join('\n  ');

  var fieldInitialization = account['type']['fields']
      .map((arg) =>
  "${arg['name']}Arg = ${capitalize(className(arg['type']))}(name: '${arg['name']}', value: ${defaultValue(arg['type'])}),")
      .join('\n        ');

  return '''
class $pascalIdlName$pascalName extends AnchorAccount {
  $fields

  $pascalIdlName$pascalName()
      : $fieldInitialization
        super(name: '$name');
}
''';
}

String generateAccountFieldDeclaration(Map<String, dynamic> instruction) {
  var name = instruction['name'];
  var pascalName = toPascalCase(name);
  var camelName = toCamelCase(name);
  var pascalIdlName = toPascalCase(idlName);

  return "final $pascalIdlName$pascalName ${camelName}Account;";
}

String generateAccountFieldInitialization(Map<String, dynamic> instruction) {
  var name = instruction['name'];
  var pascalName = toPascalCase(name);
  var camelName = toCamelCase(name);
  var pascalIdlName = toPascalCase(idlName);

  return "${camelName}Account = $pascalIdlName$pascalName()";
}

String generateTypeClass(Map<String, dynamic> type) {
  var name = type['name'];
  var pascalName = toPascalCase(name);
  var pascalIdlName = toPascalCase(idlName);

  var fieldDeclarations = "";
  var fields = "";

  if (type['type']['kind'] == "struct") {
    fieldDeclarations = type['type']['fields']
        .map((field) => generateFieldDeclaration(field))
        .join('\n  ');

    fields = type['type']['fields']
        .map((field) => generateFieldInitialisation(field))
        .join(',\n        ');

    return '''
class $pascalIdlName$pascalName extends AnchorStruct {
  $fieldDeclarations

  $pascalIdlName$pascalName():
        $fields,
        super(name: '$name');
}
''';
  } else if (type['type']['kind'] == "enum") {
    fieldDeclarations = type['type']['variants']
        .map((field) => field['name'])
        .join(',\n  ');

    return '''
enum $pascalIdlName$pascalName {
  $fieldDeclarations
}
''';
  }

  throw Exception("Unknown type kind: ${type['type']['kind']}");
}

String generateErrorClass(Map<String, dynamic> error) {
  var name = error['name'];
  var code = error['code'];
  var msg = error['msg'];

  var pascalName = toPascalCase(name);
  var pascalIdlName = toPascalCase(idlName);

    return '''
class $pascalIdlName$pascalName extends AnchorError {
  $pascalIdlName$pascalName():
        super(code: $code, name: '$name', msg: '$msg');
}
''';
}

String generateFieldDeclaration(Map<String, dynamic> field) {
  var name = field['name'];
  var fieldName = "${name}Field";
  var type = className(field['type']);

  return "final $type $fieldName;";
}

String generateFieldInitialisation(Map<String, dynamic> field) {
  var name = field['name'];
  var fieldName = "${name}Field";
  var type = className(field['type']);
  var value = defaultValue(field['type']);

  return "$fieldName = $type(name: '$name', value: $value)";
}

String className(dynamic type) {
  if (type is String) {
    switch (type) {
      case 'string':
        return 'AnchorFieldString';
      case 'u64':
        return 'AnchorFieldU64';
      case 'u32':
        return 'AnchorFieldU32';
      case 'u16':
        return 'AnchorFieldU16';
      case 'u8':
        return 'AnchorFieldU8';
      case 'bytes':
        return 'AnchorFieldBytes';
      case 'publicKey':
        return 'AnchorFieldBytes';
      default:
        return type;
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return className(type['option']).replaceAll("AnchorField", "AnchorFieldNullable");
    } else if (type['vec'] != null) {
      return "AnchorFieldVector<${className(type['vec'])}>";
    } else if (type['defined'] != null) {
      return "${toPascalCase(idlName)}${className(type['defined'])}";
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String defaultValue(dynamic type) {
  if (type is String) {
    switch (type) {
      case 'string':
        return '\'\'';
      case 'u64':
        return '0';
      case 'u32':
        return '0';
      case 'u16':
        return '0';
      case 'u8':
        return '0';
      case 'bytes':
        return 'Uint8List(0)';
      case 'publicKey':
        return 'Uint8List(0)';
      default:
        return 'null';
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return 'null';
    } else if (type['vec'] != null) {
      return '[]';
    } else if (type['defined'] != null) {
      return defaultValue(type['defined']);
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String dartType(dynamic type) {
  if (type is String) {
    switch (type) {
      case 'string':
        return 'String';
      case 'u64':
        return 'int';
      case 'u32':
        return 'int';
      case 'u16':
        return 'int';
      case 'u8':
        return 'int';
      case 'bytes':
        return 'Uint8List';
      case 'publicKey':
        return 'Uint8List';
      default:
        return type;
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return '${dartType(type['option'])}?';
    } else if (type['vec'] != null) {
      return 'List<${dartType(type['vec'])}>';
    } else if (type['defined'] != null) {
      return dartType(type['defined']);
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

void printHelp() {
  print('Usage:');
  print('  dart bin/your_script.dart [options]');
  print('');
  print('Options:');
  print('  --input-dir <directory>    Specify the input directory for IDL files.');
  print('  --output-dir <directory>   Specify the output directory for generated code.');
  print('  --help, -h                Show this help message.');
  print('');
  print('Example:');
  print('  dart bin/your_script.dart --input-dir idl --output-dir lib/generated');
}
