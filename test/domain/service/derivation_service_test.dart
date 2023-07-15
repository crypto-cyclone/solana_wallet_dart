import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:cryptography/cryptography.dart';
import 'package:solana_wallet/domain/model/encryption/solana_derivation_path_model.dart';
import 'package:solana_wallet/domain/model/encryption/solana_extended_secret_key_model.dart';
import 'package:solana_wallet/domain/service/derivation_service.dart';
import 'package:test/test.dart';

void main() {
  group('DerivationService', () {
    late DerivationService derivationService;

    setUp(() {
      derivationService = DerivationService();
    });

    test('deriveSeed', () {
      var hexSeed = "5f0a5d2213ae6ca550494c9bb96e6711fe9dd722bb79293e3c700c309aaa11285176cedad042b80dc1db570c46e7a08bc5b378308349ae1aeb444cb610eec2fa";
      var expected = Uint8List.fromList(HEX.decode(hexSeed));

      var mnemonic = [
        "comic",
        "sphere",
        "unaware",
        "supreme",
        "level",
        "shadow",
        "finger",
        "aim",
        "chimney",
        "auction",
        "brave",
        "alter"
      ];

      var derivedSeed = derivationService.deriveSeed(mnemonic);

      expect(derivedSeed.lengthInBytes, 64);
      expect(derivedSeed.toList(), expected.toList());
    });

    test('deriveMasterExtendedSecretKey', () {
      var seed = "5f0a5d2213ae6ca550494c9bb96e6711fe9dd722bb79293e3c700c309aaa11285176cedad042b80dc1db570c46e7a08bc5b378308349ae1aeb444cb610eec2fa";
      var secretKey = "448d941059eaa2e6ea0cba639b1ae64df42757fa47777879280f0bcf24bda383";
      var chainCode = "1d4c20be1b0e62c2c279675f79969b6a1960d6cacd4c09a3b0b6e993124c424d";

      var masterExtendedKey = derivationService.deriveMasterExtendSecretKey(
          Uint8List.fromList(HEX.decode(seed))
      );

      expect(masterExtendedKey.secretKey.toList(), HEX.decode(secretKey));
      expect(masterExtendedKey.chainCode.toList(), HEX.decode(chainCode));
    });

    test('deriveExtendedSecretKeyForPath', () async {
      var expectedPublicKeys = [
        "86ad847f176d9f271f6e58ccf5017538b51849707ea4913ff0caaf895bae74d6",
        "db872d35996f363aea03dc077e886305c75a4121df94416547a87cb399818da0",
        "c1193bc909b438b4afb5ba1091dc9a987b0256dcd83b012640f6a3e82c291734",
        "c046ca4ce584f0ab583662abefebb2ac7d0ae9916fc769ed2d914d4c980764a4",
        "e5f15e2f7c0cbe1385aecd9d0fb366e0b5a453a50321f63fc448daceb130e2d5",
        "1d4f607f27828f02a4842cafff155cbf810fb9ccf42a51fcdf151a4ca514a52b",
        "5af919fff6f6c23ec72830de79f116507044d2495d4005f1d2a88bbbe11ceafd",
        "be80830cf057077cf92bc8c0f4096dd9996a7a0826150df85395cfd0f7e17a24",
        "c5320b2d1899910d8d833904b717060e2c2bffa539322d0005138038a2bcad79",
        "bedaf18c7f07d22d8784e7399ba8754515329ebc12092e23b485f920a9015566",
        "2dfdb51e3a1d16099807fce5008250e13e9e7fb7764e6ae6a7ef8dd2b6ad296c",
        "22f99325fad5ad30ad638278a4097088f9a8d3fa0de4cecdd0c31f66cfc5f0d4",
        "47456e7bf0cc9084d38b869854ed2c03d3891832df5669eacecde1fb13c50be",
        "671fa24ba1f7dffc6c3f2bdb33ae1821e354de847d4c445a8e967e069bee2601",
        "b574d56f9c2d2a6432c39be0d48376b440b1d797c6e7eedbd9557aa60bc2b97c",
        "c261ddf59847f5b0ada153ddea1d0cb232ed7393621917c7b2b873f3df44cbef",
        "3b143fdb5905afd85d51a7baab529cf37a5495bb03f32bcf1f74d30682abb3cb",
        "4f45cdc0da1f74211b374b98ff85036abc6ec2fcc03f1143d60a732a644aeb89",
        "35e4f6553dcee5a5ffcccd3b1940074c874e6c0f56e0aaf402720440756804bf",
        "7a54357487ea52944c83f2d6ab3855bb80fce3fad169ed7a28c9a6f79b02c5a3",
        "cce9391cb249dacb7def50cfce116c8f873e38b2d34e57e1381ff6389f08df91",
        "499545e66e9c5997d2af9e3b6b76417d89054bbf5355a0856f3fdf6e66f0dfca",
        "110dafcb120571888b689d46f46df804a3b864579c8518d0ac5f18af1bc6ce3b",
        "63648fc954aad5f3c65dde50fc4e8b1b45ac4810ab6192a232fa3e1aae486f61",
        "5cc68e0011bcc8cf082513afd253ffd846bb78fb598927b3ce5c25e0f41e4ab1",
        "7363606223fd8b522a9c5f4ea20be924084c2b901e007e70291f0a43d04c7963",
        "e710a9158e86dcf88a639835cad56e95b6ee8486a3777ceb93e2dd18d0abf07c",
        "cf2935c35400a549cf0fde9ce01327d8e868fea2b0be58553bdb3d86752d908e",
        "a3bfe048bd66796260bb0018eff7f53e8b2c3eaf85006bffa82d5ad653c9b1c",
        "5ed6ff690c0b928afe6c6b97004d1f5e97c8334a85293785a6c6749a7ffb7d00",
        "32db9ccba83f1cacb2f654268b7c8046372ee8c18059fd9142ea4b835fc8707d",
        "fb484cfda45ea997da0f40631a1e13effa940eeba6248c862b51e9bbd511c0fd",
        "a4dc972d363e09285c040e8bcd412bd4a2639532d1a424f6f9f606d00e578d3e",
        "5503dfd6711d902169d5ee21b0020b5f0cd702bd690dce15a4c0ec85f460f4d7",
        "86bf770b6cf20f89ce1f327874a0468c4834950388b0a442361fd3469661b862",
        "2d2e5eefbfaf3377d967d022acaf317fd8aac24f14c9e71037a0284f7d490758",
        "e2a7ada56cfeb40a309cd0ef66a095221e07ffe89f3d70289e55dab59c8a88e9",
        "1419e1d9c3180e779f2b95f8ede1ccc0fda30f0508e3501a037c45373bd44f1a",
        "81c739b474fc8ee5c4ac8196b44a11e0f8be07556bc8bfa1bfec05167c2c8ba6",
        "2b357063a44d7c6eebb423a603c93263f91ccd89ebf6abd455bbf2c12119b2ab",
        "8188ea978fd5c5fb8bb3df75410adfc58352016d4bee2e396a767aff7a5e1cc",
        "3e42865570de3f07c02e5c7c5ba0427f1ea7d98405d2dc8228713fbcbf5b0d01",
        "7029e07a4a2eda39dcf81c6a3a3c19f79f28eb4877cff2d9a5c714daff88f35d",
        "8cedd2a77d3fb7cbe2411835c56bf08b776ab0296935aaecbbf28ef9cb7aaeea",
        "15c94c6caf3dea65e2ff9a2aa1e5acae0575b4f7baeb835be16b420cb4e4bd0",
        "2b6bf6640d777bf4771e90eecabbc6a08151f9493e9147a5828fd6adde4a2832",
        "ebba16af45c67f07e416df251e4bb8e1c516d00688d1533958bb85ab943d2701",
        "9b352287130b6995978ec82e552ca4ab8dc79e6791de75573887811d894c6ea9",
        "2536f4930cd53beca0bc01b954692628cef60ba859390a0e401d10d099386cee",
        "62ac171f1d485a869022db33dbce2f0f3c00ab2e69033a7db0ddda6b4f1cbf58",
        "1588b88ba1038bdcdf87528c093ceda2dac53a10e17ed0261458201f9262e32b",
        "da9022675fbc01ef8bfa41fb73da3e2d68929527625b14110c4332afc9abdaf0",
        "57bbee6a36fde969e9add013047448159c972a0c5a50b01906170938aaffabb4",
        "959e4a7aba52f227535d034d637a3a4d54c17b4096a284865fc1961affb576c3",
        "44ca9938422225ca58955378b6fbce867bc25039d356fdd4a1ba51de990e9338",
        "64a89be666c1569c22ef3c4555777211e9b5a6178b67619a8796a20b8e619476",
        "fa84cf82f57fb3ed6d7d0917f0f01a8c85223c65a677b6f6b624ab3ce7f17e8c",
        "781bbee413c98102483d2386c37c32bbab7d6721864023c1f134f1b752901842",
        "568840beb8600f9c359abb2f60976330738262974c5085be444dfc9e301b6215",
        "aad66ed6a1032a5ceb12de6afc8b632976af123e0de30c30074ae17ef5f07f9a",
        "6d2e2ea594364e26bef5aed33bf96876586240355962b67ca2034c0a87a29dfb",
        "c8316c961bf95abcfd1aeb861d245bc1a84479d9ad0f5e980bf18326f5aa6d2a",
        "8719dd411f9cc963781d666f4b19bbdb0ca6ea99b26c0bd932081f51394f7186",
        "9ee83ce335b62bebe12d6dff76da1d3a87b2e720afbb659db8be7c4546d059a9"
      ];

      var masterExtendedSecretKey = SolanaExtendedSecretKey(
          secretKey: Uint8List.fromList(HEX.decode("448d941059eaa2e6ea0cba639b1ae64df42757fa47777879280f0bcf24bda383")),
          chainCode: Uint8List.fromList(HEX.decode("1d4c20be1b0e62c2c279675f79969b6a1960d6cacd4c09a3b0b6e993124c424d"))
      );

      for (var i = 0; i < 64; i++) {
        var extendedSecretKey = derivationService.deriveExtendedSecretKeyForPath(
            masterExtendedSecretKey,
            SolanaDerivationPath.fromPath("44'/501'/$i'")
        );

        final algorithm = Ed25519();
        SimpleKeyPair keyPair = await algorithm.newKeyPairFromSeed(extendedSecretKey.secretKey.toList());
        SimplePublicKey publicKey = await keyPair.extractPublicKey();

        expect(
            publicKey.bytes.toList(),
            HEX.decode(expectedPublicKeys[i])
        );
      }
    });
  });
}