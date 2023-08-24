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
      case 'bytes':
        return '${AnchorFieldClassName()}Bytes';
      case 'publicKey':
        return '${AnchorFieldClassName()}Bytes';
      default:
        var custom = types.firstWhere((e) => e['name'] == type);

        if (custom == null) {
          throw ArgumentError('Unknown type structure: $type');
        } else {
          return "${type}${toPascalCase(custom['type']['kind'])}";
        }
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return ExtendedAnchorFieldClassName(idlName, type['option'], types)
          .replaceAll("AnchorField", "AnchorFieldNullable");
    } else if (type['vec'] != null) {
      return "AnchorFieldVector<${ExtendedAnchorFieldClassName(idlName, type['vec'], types)}>";
    } else if (type['defined'] != null) {
      return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'], types)}";
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

String AnchorFieldDefaultValue(dynamic type) {
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
      return AnchorFieldDefaultValue(type['defined']);
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String AnchorFieldDartType(dynamic type) {
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
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return '${AnchorFieldDartType(type['option'])}?';
    } else if (type['vec'] != null) {
      return 'List<${AnchorFieldDartType(type['vec'])}>';
    } else if (type['defined'] != null) {
      return AnchorFieldDartType(type['defined']);
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}