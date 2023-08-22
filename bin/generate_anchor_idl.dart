import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:solana_wallet/util/string.dart';

import 'idl_generator.dart';
import 'idl_instruction_generator.dart';
import 'idl_type_generator.dart';

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
  AnchorIDLGenerator idlGenerator = AnchorIDLGenerator();
  AnchorInstructionGenerator instructionGenerator = AnchorInstructionGenerator();
  AnchorIDlTypeGenerator typeGenerator = AnchorIDlTypeGenerator();

  return '''
import 'dart:typed_data';
 
import 'package:solana_wallet/api/idl/anchor_idl.dart';

${idlGenerator.generate(idl)}
${instructionGenerator.generate(idl)}
${typeGenerator.generate(idl)}
''';
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
