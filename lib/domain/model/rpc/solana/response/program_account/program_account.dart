import 'dart:convert';

import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/account_info.dart';

class ProgramAccount {
  final AccountInfo? account;
  final String? pubkey;

  ProgramAccount({
    required this.account,
    required this.pubkey
  });

  String toJson() {
    return jsonEncode({
      'account': account?.toJson(),
      'pubkey': pubkey,
    });
  }

  static ProgramAccount fromJson(Map<String, dynamic> json) {
    return ProgramAccount(
      account: AccountInfo.fromJson(json['account']),
      pubkey: json['pubkey'] as String?,
    );
  }
}