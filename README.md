Crypto Cyclone Solana Wallet Library
This Dart library provides a convenient way for developers to work with Solana Wallet, especially for key derivation tasks. The library encapsulates key derivation and handling functionalities within the DerivationService class.

Class Documentation
DerivationService
This class provides methods for deriving keys for Solana Wallet.

deriveSeed(List<String> phrase, [String passphrase = ""])
This method generates a seed from a mnemonic phrase and an optional passphrase. The mnemonic phrase should be passed as a list of words.

phrase: A list of words representing the mnemonic phrase.
passphrase: An optional passphrase string. Defaults to an empty string if not provided.
This method returns a 64-byte Uint8List representing the derived seed.

deriveMasterExtendSecretKey(Uint8List seed)
This method derives a master extended secret key from a seed.

seed: A 64-byte Uint8List representing the seed from which the master key is derived.
This method returns a SolanaExtendedSecretKey object representing the derived master extended secret key.

deriveExtendedSecretKeyForPath(SolanaExtendedSecretKey masterKey, SolanaDerivationPath path)
This method derives an extended secret key for a specific path from a master extended secret key.

masterKey: A SolanaExtendedSecretKey object representing the master extended secret key.
path: A SolanaDerivationPath object representing the path for which the extended secret key should be derived.
This method returns a SolanaExtendedSecretKey object representing the derived extended secret key for the specified path.

Usage
The library is designed to be simple to use. You just need to create an instance of the DerivationService class, and then you can call the methods on that instance.

DerivationService derivationService = DerivationService();

Uint8List seed = derivationService.deriveSeed(mnemonicPhrase);
SolanaExtendedSecretKey masterKey = derivationService.deriveMasterExtendSecretKey(seed);
SolanaExtendedSecretKey extendedKey = derivationService.deriveExtendedSecretKeyForPath(masterKey, path);

TransactionService
The TransactionService class provides methods for creating and signing Solana transactions.

createSolTokenTransferTransaction(String fromAddress, String toAddress, String blockhash, BigInt lamports)
This method creates a new Solana token transfer transaction.

fromAddress: A string representing the sender's address.
toAddress: A string representing the recipient's address.
blockhash: A string representing the current block hash.
lamports: A BigInt representing the amount of lamports to be transferred.
This method returns a Transaction object representing the created transaction.

signTransaction(Transaction transaction, List<SolanaKeyPair> keyPairs)
This method signs a transaction with a list of Solana key pairs.

transaction: A Transaction object representing the transaction to be signed.
keyPairs: A list of SolanaKeyPair objects representing the key pairs to be used for signing.
This method returns a Future that completes with a Transaction object representing the signed transaction.

Usage
To use this class, create a new instance of TransactionService and call the methods on that instance.

TransactionService transactionService = TransactionService();

Transaction transaction = transactionService.createSolTokenTransferTransaction(
fromAddress,
toAddress,
blockhash,
lamports,
);

transaction = await transactionService.signTransaction(transaction, keyPairs);
This will create a Solana token transfer transaction and sign it with the provided key pairs. The signed transaction is ready to be sent to the Solana network.

MnemonicService
The MnemonicService class provides methods for encoding and decoding mnemonic phrases.

encodeMnemonic(Uint8List entropy)
This method generates a list of mnemonic words from a provided entropy value.

entropy: A Uint8List representing the entropy value.
The method returns a list of strings (List<String>) representing the mnemonic words.

decodeMnemonic(List<String> mnemonic)
This method decodes a list of mnemonic words back into an entropy value.

mnemonic: A list of strings (List<String>) representing the mnemonic words.
The method returns a Uint8List representing the entropy value. If the mnemonic words are invalid or the checksum is incorrect, the method throws an exception.

Usage
To use this class, create a new instance of MnemonicService and call the methods on that instance.

MnemonicService mnemonicService = MnemonicService();

List<String> mnemonicWords = mnemonicService.encodeMnemonic(entropy);
Uint8List decodedEntropy = mnemonicService.decodeMnemonic(mnemonicWords);
This will generate a list of mnemonic words from the entropy, and then decode those words back into the original entropy value.

License
This library is licensed under the MIT License.