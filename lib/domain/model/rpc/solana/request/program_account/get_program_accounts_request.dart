import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/filter.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';

class GetProgramAccountsRequest extends RPCRequest {
  final String pubkey;
  final String commitment;
  final String encoding;
  final List<Filter>? filters;
  int? minContextSlot;

  GetProgramAccountsRequest({
    required this.pubkey,
    this.commitment = "processed",
    this.encoding = 'base64',
    this.minContextSlot = null,
    this.filters = null,
    super.jsonrpc = "2.0",
    super.id = RPCRequest.getProgramAccountsId,
    super.method = RPCRequest.getProgramAccountsRPCMethod,
  });

  @override
  String toJson() {
    return '{"jsonrpc":"$jsonrpc","id":$id,"method":"$method","params":["$pubkey",{' +
        '"commitment":"$commitment",' +
        (minContextSlot != null ? '"minContextSlot":$minContextSlot,' : '') +
        '"encoding":"$encoding"' +
        (filters != null && filters!.isNotEmpty
            ? ',"filters":[' + filters!.map((f) => f.toJson()).join(',') + ']'
            : '') +
        '}]}';
  }

}