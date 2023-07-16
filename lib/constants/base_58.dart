const String base58Alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
final List<int> base58AlphabetBytes = base58Alphabet
    .split('')
    .map((e) => e.codeUnitAt(0))
    .toList();