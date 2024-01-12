import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/memcmp.dart';

class Filter {
  final MemCmp memcmp;

  Filter({
    required this.memcmp
  });

  String toJson() {
    return '{"memcmp":${memcmp.toJson()}}';
  }
}