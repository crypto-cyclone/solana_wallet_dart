class SolanaDerivationPath {
  int? account;
  int? change;
  int? addressIndex;
  final int purpose = 44;
  final int coinType = 501;

  SolanaDerivationPath({
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

    assert(pathParts.length >= 0 && pathParts.length <= 3, "Invalid derivation path: $path");

    return SolanaDerivationPath(
      account: pathParts.isNotEmpty ? pathParts[0] : null,
      change: pathParts.length > 1 ? pathParts[1] : null,
      addressIndex: pathParts.length > 2 ? pathParts[2] : null,
    );
  }

  List<int> toList() {
    return [purpose, coinType, account, change, addressIndex].whereType<int>().toList();
  }
}
