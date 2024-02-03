import 'package:solana_wallet/util/string.dart';

import 'helper.dart';

class AnchorIDLGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    var className = ExtendedAnchorIDLClassName(idlName);
    var classFieldDeclarations = _generateFieldDeclarations(idl);
    var defaultConstructor = _generateDefaultConstructor(idl);
    var initializeFunction = _initializeFunctionGenerator(idl);

    return '''
class $className extends ${AnchorIDLClassName()} {
  $classFieldDeclarations
  
  $defaultConstructor
  $initializeFunction
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
        .map((e) => _generateAccountFieldInitialization(idlName, e));

    var fieldInitializations = [...instructionFieldInitializations, ...accountFieldInitializations]
        .join(',\n$TabPlusHalf');

    var superInitialization = "super(\n$DoublePlusHalfTab" +
        "version: '$version',\n$DoublePlusHalfTab" +
        "name: '$idlName',\n$DoublePlusHalfTab" +
        "metadata: ${AnchorMetadataClassName()}(address: '${metadata['address']}'))";

    return '''
$className()
    : $fieldInitializations,
      $superInitialization {
        initialize();
      }
''';
  }

  String _initializeFunctionGenerator(idl) {
    var idlName = idl['name'];

    List<dynamic> instructionArgs = idl['instructions']
        .expand((e) => e['args'] as Iterable)
        .map((e) => _generateInstructionArgRegistration(idlName, e, idl['types']))
        .toList();

    instructionArgs = instructionArgs.expand((e) => e).toList();

    List<dynamic> accountArgs = idl['accounts']
        .expand((e) => e['type']['fields'] as Iterable? ?? [])
        .map((e) {
          if (e == null) {
            return "";
          }
          return _generateInstructionArgRegistration(idlName, e, idl['types']);
        }).toList();

    accountArgs = accountArgs.expand((e) => e).toList();

    var types = idl['types']
        .map((e) {
          if (e['type']['kind'] == 'struct') {
            return _generateStructRegistration(idlName, e);
          } else if (e['type']['kind'] == 'enum') {
            return _generateEnumRegistration(idlName, e);
          }

          return "";;
    });

    List<dynamic> typesArgs = idl['types']
        .expand((e) => e['type']['fields'] as Iterable? ?? [])
        .map((e) {
      if (e == null) {
        return "";
      }
      return _generateInstructionArgRegistration(idlName, e, idl['types']);
    }).toList();

    typesArgs = typesArgs.expand((e) => e).toList();

    var args = [...instructionArgs, ...accountArgs, ...types, ...typesArgs]
        .where((e) => e != "")
        .toSet()
        .join('\n$TabPlusHalf');

    return '''
void initialize() {
$TabPlusHalf$args
$HalfTab}
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
    return "final ${ExtendedAccountClassName(idlName, name)} ${toCamelCase(name)}Account;";
  }

  String _generateAccountFieldInitialization(String idlName, Map<String, dynamic> account) {
    var name = account['name'];
    return "${toCamelCase(name)}Account = ${ExtendedAccountClassName(idlName, name)}()";
  }

  String _generateStructRegistration(String idlName, struct) {
    var name = struct['name'];
    var className = ExtendedStructClassName(idlName, name);

    return "serializationRegistry.register<$className>(() => $className());";
  }

  String _generateEnumRegistration(String idlName, enumerator) {
    var name = enumerator['name'];
    var className = ExtendedEnumName(idlName, name);

    return "serializationRegistry.register<$className>(() => $className.values.first);";
  }

  List<String> _generateInstructionArgRegistration(String idlName, arg, List<dynamic> types) {
    var className = ExtendedAnchorFieldClassName(idlName, arg['type'], types);

    if (className.contains("AnchorFieldVector")) {
      var typeClass = className;
      var typeClassT = stripInnerClassName(className);
      var typeT = stripOuterClassName(className);

      List<String> initializers = ["serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());"];

      typeClass = stripOuterClassName(typeClass);
      typeClassT = stripInnerClassName(typeClass);
      typeT = stripOuterClassName(typeT);

      while (typeClass != "" && typeT != "") {
        initializers.add("serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());");

        typeClass = stripOuterClassName(typeClass);
        typeClassT = stripInnerClassName(typeClass);
        typeT = stripOuterClassName(typeT);
      }

      return initializers;
    }
    if (className.contains("AnchorFieldArray")) {
      var typeClass = className;
      var typeClassT = stripInnerClassName(className);
      var typeT = stripOuterClassName(className);
      var size = arg["type"]["array"][1];

      List<String> initializers = ["serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>($size));"];

      typeClass = stripOuterClassName(typeClass);
      typeClassT = stripInnerClassName(typeClass);
      typeT = stripOuterClassName(typeT);

      while (typeClass != "" && typeT != "") {
        initializers.add("serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());");

        typeClass = stripOuterClassName(typeClass);
        typeClassT = stripInnerClassName(typeClass);
        typeT = stripOuterClassName(typeT);
      }

      return initializers;
    }
    else if (className.contains("AnchorFieldNullableVector")) {
      var typeClass = className;
      var typeClassT = stripInnerClassName(className);
      var typeT = stripOuterClassName(className);

      List<String> initializers = ["serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());"];

      typeClass = stripOuterClassName(typeClass);
      typeClassT = stripInnerClassName(typeClass);
      typeT = stripOuterClassName(typeT);

      while (typeClass != "" && typeT != "") {
        initializers.add("serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());");

        typeClass = stripOuterClassName(typeClass);
        typeClassT = stripInnerClassName(typeClass);
        typeT = stripOuterClassName(typeT);
      }

      return initializers;
    }
    else if (className.contains("AnchorFieldStruct")) {
      var typeClass = className;
      var typeClassT = stripInnerClassName(className);
      var typeT = stripOuterClassName(className);

      List<String> initializers = ["serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());"];

      typeClass = stripOuterClassName(typeClass);
      typeClassT = stripInnerClassName(typeClass);
      typeT = stripOuterClassName(typeT);

      while (typeClass != "" && typeT != "") {
        initializers.add("serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());");

        typeClass = stripOuterClassName(typeClass);
        typeClassT = stripInnerClassName(typeClass);
        typeT = stripOuterClassName(typeT);
      }

      return initializers;
    }
    else if (className.contains("AnchorFieldEnum")) {
      var typeClass = className;
      var typeClassT = stripInnerClassName(className);
      var typeT = stripOuterClassName(className);

      List<String> initializers = ["serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());"];

      typeClass = stripOuterClassName(typeClass);
      typeClassT = stripInnerClassName(typeClass);
      typeT = stripOuterClassName(typeT);

      while (typeClass != "" && typeT != "") {
        initializers.add("serializationRegistry.register<$typeClass>(() => $typeClassT.factory<$typeT>());");

        typeClass = stripOuterClassName(typeClass);
        typeClassT = stripInnerClassName(typeClass);
        typeT = stripOuterClassName(typeT);
      }

      return initializers;
    }
    else {
      return ["serializationRegistry.register<$className>(() => $className.factory());"];
    }
  }
}