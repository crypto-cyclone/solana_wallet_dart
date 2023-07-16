import 'dart:typed_data';

class Header {
  int noSigs;
  int noSignedReadOnlyAccounts;
  int noUnsignedReadOnlyAccounts;

  Header(
      {required this.noSigs,
        required this.noSignedReadOnlyAccounts,
        required this.noUnsignedReadOnlyAccounts});

  Uint8List serialize() {
    return Uint8List.fromList([
      noSigs,
      noSignedReadOnlyAccounts,
      noUnsignedReadOnlyAccounts
    ]);
  }
}
