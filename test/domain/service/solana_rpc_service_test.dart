import 'package:solana_wallet/domain/configuration/solana_configuration.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/account_info/get_account_info_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/balance/get_balance_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/block_height/get_block_height_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/latest_blockhash/get_latest_blockhash_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/filter.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/get_program_accounts_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/program_account/memcmp.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/rpc_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/request/send_transaction/send_transaction_request.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/account_info/get_account_info_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/balance/get_balance_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/block_height/get_block_height_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/latest_blockhash/get_latest_blockhash_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/program_account/get_program_accounts_response.dart';
import 'package:solana_wallet/domain/model/rpc/solana/response/send_transaction/send_transaction_response.dart';
import 'package:solana_wallet/domain/service/solana_rpc_service.dart';
import 'package:solana_wallet/encoder/base58/base_58_encoder.dart';
import 'package:test/test.dart';

import '../../api/service/http_service_impl.dart';
import '../../responses/json.dart';

void main() {
  group('SolanaRPCService', () {
    late SolanaRPCService solanaRPCService;
    late HttpServiceImpl httpsService;
    late Base58Encoder base58encoder;

    setUp(() {
      httpsService = HttpServiceImpl();
      solanaRPCService = SolanaRPCService(
          httpService: httpsService,
          configuration: SolanaConfiguration.network(
            SolanaNetwork.devnet
          )
      );
      base58encoder = Base58Encoder();
    });

    test('get blockHeight is success', () async {
      httpsService.responseJson = '{"jsonrpc": "2.0","result": 1233,"id": ${RPCRequest.getBlockHeightMethodId}}';
      var requestJson = '{"jsonrpc":"2.0","id":${RPCRequest.getBlockHeightMethodId},"method":"getBlockHeight","params":[{"commitment":"processed"}]}';

      var request = GetBlockHeightRequest();

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.getBlockHeight(
          GetBlockHeightRequest()
      );

      expect(result is GetBlockHeightResponse, true);

      var blockHeightResponse = result as GetBlockHeightResponse;

      expect(blockHeightResponse.jsonrpc, "2.0");
      expect(blockHeightResponse.id, RPCRequest.getBlockHeightMethodId);
      expect(blockHeightResponse.method, null);
      expect(blockHeightResponse.blockheight, 1233);
    });

    test('get latest blockhash is success', () async {
      httpsService.responseJson = '{"jsonrpc": "2.0","result": {"context": {"slot": 2792},"value": {"blockhash": "EkSnNWid2cvwEVnVx9aBqawnmiCNiDgp3gUdkDPTKN1N","lastValidBlockHeight": 3090}},"id": 1}';
      var requestJson = '{"jsonrpc":"2.0","id":1,"method":"getLatestBlockhash","params":[{"commitment":"processed"}]}';

      var request = GetLatestBlockhashRequest();

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.getLatestBlockhash(
          GetLatestBlockhashRequest()
      );

      expect(result is GetLatestBlockhashResponse, true);

      var latestBlockhashResponse = result as GetLatestBlockhashResponse;

      expect(latestBlockhashResponse.jsonrpc, "2.0");
      expect(latestBlockhashResponse.id, 1);
      expect(latestBlockhashResponse.method, null);
      expect(latestBlockhashResponse.context?.slot, 2792);
      expect(latestBlockhashResponse.blockhash.blockhash, "EkSnNWid2cvwEVnVx9aBqawnmiCNiDgp3gUdkDPTKN1N");
      expect(latestBlockhashResponse.blockhash.lastValidBlockHeight, 3090);
    });

    test('get balance is success', () async {
      httpsService.responseJson = getBalanceResponse;
      var requestJson = '{"jsonrpc":"2.0","id":${RPCRequest.getBalanceMethodId},"method":"${RPCRequest.getBalanceRPCMethod}","params":["83astBRguLMdt2h5U1Tpdq5tjFoJ6noeGwaY3mDLVcri",{"commitment":"finalized"}]}';

      var request = GetBalanceRequest(
          address: "83astBRguLMdt2h5U1Tpdq5tjFoJ6noeGwaY3mDLVcri");

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.getBalance(
          request
      );

      expect(result is GetBalanceResponse, true);

      var balanceResponse = result as GetBalanceResponse;

      expect(balanceResponse.jsonrpc, "2.0");
      expect(balanceResponse.id, RPCRequest.getBalanceMethodId);
      expect(balanceResponse.method, null);
      expect(balanceResponse.context?.slot, 1);
      expect(balanceResponse.balance.compareTo(BigInt.zero), 0);
    });

    test('get account info is success', () async {
      httpsService.responseJson = '{"jsonrpc":"2.0","result":{"context":{"apiVersion":"1.16.6","slot":236581417},"value":{"data":["OZD4GarKfuP80i1oVZ+uPPsiSLQum2MYash6e/sezy6Lygg7qRgpImK0ZuDjFIiW7iDjlcjbXakQr+qSUgkkOgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","base64"],"executable":false,"lamports":2039280,"owner":"TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA","rentEpoch":0,"space":165}},"id":6}';
      var requestJson = '{"jsonrpc":"2.0","id":${RPCRequest.getAccountInfoMethodId},"method":"${RPCRequest.getAccountInfoRPCMethod}","params":["E8qML25hDPZ1XWv9MP3pQ28dzY5oUmbbHUXVRoDuduUg",{"commitment":"finalized","encoding":"base64"}]}';

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
      expect(accountInfoResponse.accountInfo.lamports?.compareTo(BigInt.parse("2039280")), 0);
      expect(accountInfoResponse.accountInfo.owner, "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA");
      expect(accountInfoResponse.accountInfo.rentEpoch?.compareTo(BigInt.parse("0")), 0);
      expect(accountInfoResponse.accountInfo.space?.compareTo(BigInt.parse("165")), 0);
      expect(accountInfoResponse.accountInfo.data, ["OZD4GarKfuP80i1oVZ+uPPsiSLQum2MYash6e/sezy6Lygg7qRgpImK0ZuDjFIiW7iDjlcjbXakQr+qSUgkkOgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","base64"]);
    });

    test('get program accounts is success', () async {
      httpsService.responseJson = getProgramAccountsResponse;
      var requestJson = '{"jsonrpc":"2.0","id":${RPCRequest.getProgramAccountsId},"method":"${RPCRequest.getProgramAccountsRPCMethod}","params":["D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6",{"commitment":"processed","encoding":"base64","filters":[{"memcmp":{"offset":0,"bytes":"bSBoKNsSHuj"}}]}]}';

      var request = GetProgramAccountsRequest(
          pubkey: "D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6",
          filters: [
            Filter(memcmp: MemCmp(offset: 0, bytes: "bSBoKNsSHuj"))
          ]
      );

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.getProgramAccounts(
        request
      );

      expect(result is GetProgramAccountsResponse, true);

      var response = result as GetProgramAccountsResponse;

      expect(response.jsonrpc, "2.0");
      expect(response.id, 7);
      expect(response.method, null);
      expect(response.programAccounts.length, 10);

      var accountInfo = response.programAccounts.first.account;

      expect(accountInfo?.executable, false);
      expect(accountInfo?.lamports?.compareTo(BigInt.parse("1334454400")), 0);
      expect(accountInfo?.owner, "D3Fmzy6k3JnHt6rxxrExxW9MnjdSCBF8A7PfFnyvxZY6");
      expect(accountInfo?.rentEpoch?.compareTo(BigInt.parse("18446744073709551615")), 0);
      expect(accountInfo?.space?.compareTo(BigInt.parse("512")), 0);
      expect(accountInfo?.data, ["zd5wB6Wbztp+1x62dX/MjbHPKwBX0mHxWh9b+W4FqcWBPjHUopL5a8CVqQUAAAAA+u7EoWUAAAAAAVhTbFko7eMGzhL5isyR3Z1va5hukh03z7CEFLcEtsCmAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=","base64"]);
    });

    test('send transaction is success', () async {
      httpsService.responseJson = '{"jsonrpc":"2.0","result":"test","id":3}';
      var requestJson = '{"jsonrpc":"2.0","id":3,"method":"sendTransaction","params":["test"]}';

      var request = SendTransactionRequest(
          transactions: ["test"]
      );

      expect(request.toJson(), requestJson);

      var result = await solanaRPCService.sendTransaction(
          request
      );

      expect(result is SendTransactionResponse, true);

      var sendTransactionResponse = result as SendTransactionResponse;

      expect(sendTransactionResponse.jsonrpc, "2.0");
      expect(sendTransactionResponse.id, 3);
      expect(sendTransactionResponse.method, null);
      expect(sendTransactionResponse.transactionHash, "test");
    });
  });
}