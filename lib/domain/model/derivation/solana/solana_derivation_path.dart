class SolanaDerivationPath {
  int purpose = 44;
  int coinType = 501;
  int? account;
  int? change;
  int? addressIndex;

  SolanaDerivationPath({
    required this.purpose,
    required this.coinType,
    this.account,
    this.change,
    this.addressIndex,
  });

  static SolanaDerivationPath fromPath(String path) {
    final pathParts = path
        .replaceAll("'", "")
        .split("/")
        .map((part) => int.tryParse(part))
        .whereType<int>()
        .toList();

    assert(pathParts.isNotEmpty && pathParts.length <= 3, "Invalid derivation path: $path");

    return SolanaDerivationPath(
      purpose: pathParts.isNotEmpty ? pathParts[0] : 44,
      coinType: pathParts.length > 1 ? pathParts[1] : 501,
      account: pathParts.length > 2 ? pathParts[2] : null,
      change: pathParts.length > 3 ? pathParts[3] : null,
      addressIndex: pathParts.length > 4 ? pathParts[4] : null,
    );
  }

  List<int> toList() {
    return [purpose, coinType, account, change, addressIndex].whereType<int>().toList();
  }
}
