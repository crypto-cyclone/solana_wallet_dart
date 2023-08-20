String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String toPascalCase(String text) {
  text = text.replaceAllMapped(
      RegExp(r'([a-z])_([a-z])'), (Match m) => '${m[1]} ${m[2]}');

  return text
      .split(' ')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
      .join();
}

String toCamelCase(String text) {
  text = text.replaceAllMapped(
    RegExp(r'_([a-z])'),
        (Match m) => m[1]?.toUpperCase() ?? "",
  );
  return text[0].toLowerCase() + text.substring(1);
}

String toSnakeCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
        (Match m) => '${m[1]}_${m[2]}',
  ).toLowerCase();
}