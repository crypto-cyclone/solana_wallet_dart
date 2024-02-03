import 'package:solana_wallet/util/string.dart';

const String HalfTab = "  ";

const String Tab = "    ";

const String TabPlusHalf = "      ";

const String DoubleTab = "        ";

const String DoublePlusHalfTab = "          ";

const String TripleTab = "            ";

String AnchorIDLClassName() {
  return "AnchorIDL";
}

String AnchorMetadataClassName() {
  return "AnchorMetadata";
}

String AnchorInstructionClassName() {
  return "AnchorInstruction";
}

String AnchorAccountClassName() {
  return "AnchorAccount";
}

String AnchorFieldClassName() {
  return "AnchorField";
}

String AnchorInstructionAccountClassName() {
  return "AnchorInstructionAccount";
}

String AnchorStructClassName() {
  return "AnchorStruct";
}

String AnchorErrorClassName() {
  return "AnchorError";
}

String ExtendedAnchorIDLClassName(String idlName) {
  return toPascalCase("$idlName${AnchorIDLClassName()}");
}

String ExtendedAnchorInstructionClassName(String instructionName) {
  return toPascalCase("$instructionName${AnchorInstructionClassName()}");
}

String ExtendedAnchorErrorClassName(String errorName) {
  return toPascalCase("$errorName${AnchorErrorClassName()}");
}

String ExtendedAnchorFieldClassName(
    String idlName, 
    dynamic type,
    List<dynamic> types) {
  if (type is String) {
    switch (type) {
      case 'string':
        return '${AnchorFieldClassName()}String';
      case 'u64':
        return '${AnchorFieldClassName()}U64';
      case 'u32':
        return '${AnchorFieldClassName()}U32';
      case 'u16':
        return '${AnchorFieldClassName()}U16';
      case 'u8':
        return '${AnchorFieldClassName()}U8';
      case 'i64':
        return '${AnchorFieldClassName()}I64';
      case 'bytes':
        return '${AnchorFieldClassName()}Bytes';
      case 'publicKey':
        return '${AnchorFieldClassName()}PublicKey';
      default:
        var custom = types.firstWhere((e) => e['name'] == type);

        if (custom == null) {
          throw ArgumentError('Unknown type structure: $type');
        } else {
          return "${type}${toPascalCase(custom['type']['kind'])}";
        }
    }
  }
  else if (type is Map) {
    if (type['option'] != null) {
      return ExtendedAnchorFieldClassName(idlName, type['option'], types)
          .replaceAll("AnchorField", "AnchorFieldNullable");
    }
    else if (type['vec'] != null) {
      return "AnchorFieldVector<${ExtendedAnchorFieldClassName(idlName, type['vec'], types)}>";
    }
    else if (type['array'] != null) {
      return "AnchorFieldArray<${ExtendedAnchorFieldClassName(idlName, type['array'][0], types)}>";
    }
    else if (type['defined'] != null) {
      var custom = types.firstWhere((e) => e['name'] == type['defined']);

      if (custom == null) {
        throw ArgumentError('Unknown type structure: $type');
      }

      if (custom['type']['kind'] == "struct") {
        return "AnchorFieldStruct<${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'], types)}>";
      }
      else if (custom['type']['kind'] == "enum") {
        return "AnchorFieldEnum<${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'], types)}>";
      }

      throw ArgumentError('Unknown type structure: $type');
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String ExtendedInstructionClassName(String prefix, String instructionName) {
  return "${toPascalCase(prefix)}${toPascalCase(instructionName)}Instruction";
}

String ExtendedAccountClassName(String prefix, String accountName) {
  return "${toPascalCase(prefix)}${toPascalCase(accountName)}Account";
}

String ExtendedEnumName(String idlName, String name) {
  return "${toPascalCase(idlName)}${toPascalCase(name)}Enum";
}

String ExtendedStructClassName(String idlName, String name) {
  return "${toPascalCase(idlName)}${toPascalCase(name)}Struct";
}

String ExtendedErrorClassName(String prefix, String errorName) {
  return "${toPascalCase(prefix)}${toPascalCase(errorName)}Error";
}

String AnchorFieldDefaultValue(
    String idlName,
    dynamic type,
    List<dynamic> types) {
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
      case 'i64':
        return '0';
      case 'bytes':
        return 'Uint8List(0)';
      case 'publicKey':
        return 'Uint8List(0)';
      default:
        return 'null';
    }
  }
  else if (type is Map) {
    if (type['option'] != null) {
      return 'null';
    }
    else if (type['vec'] != null) {
      return '[]';
    }
    else if (type['array'] != null) {
      return "[]";
    }
    else if (type['defined'] != null) {
      var custom = types.firstWhere((e) => e['name'] == type['defined']);

      if (custom == null) {
        throw ArgumentError('Unknown type structure: $type');
      }

      if (custom['type']['kind'] == "struct") {
        return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'], types)}.factory()";
      }
      else if (custom['type']['kind'] == "enum") {
        return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'], types)}.values.first";
      }

      throw ArgumentError('Unknown type structure: $type');
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String AnchorFieldDartType(
    String idlName,
    dynamic type,
    List<dynamic> types) {
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
      case 'i64':
        return 'int';
      case 'bytes':
        return 'Uint8List';
      case 'publicKey':
        return 'Uint8List';
      default:
        return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type, types)}";
    }
  }
  else if (type is Map) {
    if (type['option'] != null) {
      return '${AnchorFieldDartType(idlName, type['option'], types)}?';
    }
    else if (type['vec'] != null) {
      return 'List<${AnchorFieldDartType(idlName, type['vec'], types)}>';
    }
    else if (type['array'] != null) {
      return 'List<${AnchorFieldDartType(idlName, type['array'][0], types)}>';
    }
    else if (type['defined'] != null) {
      return AnchorFieldDartType(idlName, type['defined'], types);
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String AnchorFieldDartInitializerType(
    String idlName,
    dynamic type,
    List<dynamic> types) {
  if (type is String) {
    switch (type) {
      case 'string':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'u64':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'u32':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'u16':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'u8':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'i64':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'bytes':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      case 'publicKey':
        return '${ExtendedAnchorFieldClassName(idlName, type, types)}(value: e)';
      default:
        return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type, types)}";
    }
  }
  else if (type is Map) {
    if (type['array'] != null) {
      return '.map((e) => ${AnchorFieldDartInitializerType(idlName, type['array'][0], types)}).toList()';
    }

    return '';
  }

  throw ArgumentError('Unknown type structure: $type');
}

String AnchorFieldArrayTypeCaster(
    String idlName,
    dynamic type,
    List<dynamic> types) {
  if (type is String) {
    switch (type) {
      case 'string':
        return ' as String';
      case 'u64':
        return ' as int';
      case 'u32':
        return ' as int';
      case 'u16':
        return ' as int';
      case 'u8':
        return ' as int';
      case 'i64':
        return ' as int';
      case 'bytes':
        return ' as Uint8List';
      case 'publicKey':
        return ' as Uint8List';
      default:
        return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type, types)}";
    }
  }
  else if (type is Map) {
    if (type['array'] != null) {
      return '.map((e) => e${AnchorFieldArrayTypeCaster(idlName, type['array'][0], types)}).toList()';
    }

    return '';
  }

  throw ArgumentError('Unknown type structure: $type');
}

String stripOuterClassName(String typeString) {
  RegExp pattern = RegExp(r'^[^<]*<(.*)>$');

  Match? match = pattern.firstMatch(typeString);

  if (match != null && match.group(1) != typeString) {
    return match.group(1)!;
  } else {
    return '';
  }
}

String stripInnerClassName(String typeString) {
  RegExp pattern = RegExp(r'^([^<]*)<.*>$');

  Match? match = pattern.firstMatch(typeString);

  if (match != null && match.group(1)!.isNotEmpty) {
    return match.group(1)!;
  } else {
    return '';
  }
}
