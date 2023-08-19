import 'package:solana_wallet/domain/model/rpc/solana/request/get_account_info_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/get_account_info_response.dart';
import 'package:solana_wallet/domain/service/solana_rpc_service.dart';
import 'package:test/test.dart';

import '../../api/service/http_service_impl.dart';

void main() {
  group('SolanaRPCService', () {
    late SolanaRPCService solanaRPCService;
    late HttpServiceImpl httpsService;

    setUp(() {
      httpsService = HttpServiceImpl();
      solanaRPCService = SolanaRPCService(httpService: httpsService);
    });

    test('get account info is success', () async {
      httpsService.responseJson = '{"jsonrpc":"2.0","result":{"context":{"apiVersion":"1.16.6","slot":236581417},"value":{"data":["OZD4GarKfuP80i1oVZ+uPPsiSLQum2MYash6e/sezy6Lygg7qRgpImK0ZuDjFIiW7iDjlcjbXakQr+qSUgkkOgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","base64"],"executable":false,"lamports":2039280,"owner":"TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA","rentEpoch":0,"space":165}},"id":6}';
      var requestJson = '{"jsonrpc":"2.0","id":6,"method":"getAccountInfo","params":["E8qML25hDPZ1XWv9MP3pQ28dzY5oUmbbHUXVRoDuduUg",{"commitment":"finalized","encoding":"base64"}]}';

      var request = GetAccountInfoRequest(
          address: "E8qML25hDPZ1XWv9MP3pQ28dzY5oUmbbHUXVRoDuduUg"
      );

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.getAccountInfo(
          GetAccountInfoRequest(address: "E8qML25hDPZ1XWv9MP3pQ28dzY5oUmbbHUXVRoDuduUg")
      );

      expect(result is GetAccountInfoResponse, true);

      var accountInfoResponse = result as GetAccountInfoResponse;

      expect(accountInfoResponse.jsonrpc, "2.0");
      expect(accountInfoResponse.id, 6);
      expect(accountInfoResponse.method, null);
      expect(accountInfoResponse.accountInfo.executable, false);
      expect(accountInfoResponse.accountInfo.lamports, 2039280);
      expect(accountInfoResponse.accountInfo.owner, "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA");
      expect(accountInfoResponse.accountInfo.rentEpoch, 0);
      expect(accountInfoResponse.accountInfo.space, 165);
      expect(accountInfoResponse.accountInfo.data, ["OZD4GarKfuP80i1oVZ+uPPsiSLQum2MYash6e/sezy6Lygg7qRgpImK0ZuDjFIiW7iDjlcjbXakQr+qSUgkkOgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","base64"]);
    });
  });
}