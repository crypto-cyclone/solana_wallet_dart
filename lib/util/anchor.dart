import 'package:solana_wallet/api/idl/anchor_idl.dart';

int compareAccounts(AnchorInstructionAccount a, AnchorInstructionAccount b) {
  if (a.isSigner && !b.isSigner) return -1;
  if (!a.isSigner && b.isSigner) return 1;

  if (a.isSigner && b.isSigner) {
    if (a.isMut && !b.isMut) return -1;
    if (!a.isMut && b.isMut) return 1;
  }

  if (!a.isSigner && !b.isSigner) {
    if (a.isMut && !b.isMut) return -1;
    if (!a.isMut && b.isMut) return 1;
  }

  return 0;
}
