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

String ExtendedEnumName(String idlName, String name) {
  return "${toPascalCase(idlName)}${toPascalCase(name)}";
}

String ExtendedStructClassName(String idlName, String name) {
  return "${toPascalCase(idlName)}${toPascalCase(name)}";
}

String ExtendedAnchorIDLClassName(String idlName) {
  return toPascalCase("$idlName${AnchorIDLClassName()}");
}

String ExtendedAnchorInstructionClassName(String instructionName) {
  return toPascalCase("$instructionName${AnchorInstructionClassName()}");
}

String ExtendedAnchorFieldClassName(String idlName, dynamic type) {
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
        return type;
    }
  } else if (type is Map) {
    if (type['option'] != null) {
      return ExtendedAnchorFieldClassName(idlName, type['option'])
          .replaceAll("AnchorField", "AnchorFieldNullable");
    } else if (type['vec'] != null) {
      return "AnchorFieldVector<${ExtendedAnchorFieldClassName(idlName, type['vec'])}>";
    } else if (type['defined'] != null) {
      return "${toPascalCase(idlName)}${ExtendedAnchorFieldClassName(idlName, type['defined'])}";
    }
  }

  throw ArgumentError('Unknown type structure: $type');
}

String ExtendedInstructionClassName(String prefix, String instructionName) {
  return "${toPascalCase(prefix)}${toPascalCase(instructionName)}";
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