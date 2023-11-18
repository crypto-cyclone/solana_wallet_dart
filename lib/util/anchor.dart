import 'package:solana_wallet/api/idl/anchor_idl.dart';

int compareAccounts(AnchorInstructionAccount a, AnchorInstructionAccount b) {
  // Compare signers
  if (a.isSigner && !b.isSigner) return -1;
  if (!a.isSigner && b.isSigner) return 1;

  // Compare mutable
  if (a.isSigner && b.isSigner) {
    if (a.isMut && !b.isMut) return -1;
    if (!a.isMut && b.isMut) return 1;
  }

  // Compare addresses lexicographically if all other criteria are equal
  if (a.isSigner == b.isSigner && a.isMut == b.isMut) {
    return a.address.compareTo(b.address);
  }

  return 0; // All criteria are equal
}
