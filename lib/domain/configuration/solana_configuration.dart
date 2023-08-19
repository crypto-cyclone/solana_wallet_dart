class SolanaConfiguration {
  final SolanaNetwork? network;
  final String? customUrl;

  SolanaConfiguration.network(this.network) : customUrl = null;
  SolanaConfiguration.custom(this.customUrl) : network = null;

  String get url => customUrl ?? network?.url ?? '';
}

enum SolanaNetwork { devnet, testnet, mainnet_beta }

extension SolanaNetworkExtension on SolanaNetwork {
  String get url {
    switch (this) {
      case SolanaNetwork.devnet:
        return "api.devnet.solana.com";
      case SolanaNetwork.testnet:
        return "api.testnet.solana.com";
      case SolanaNetwork.mainnet_beta:
        return "api.mainnet-beta.solana.com";
    }
  }
}