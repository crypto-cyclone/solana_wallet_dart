class Blockhash {
  final String? blockhash;
  final int? lastValidBlockHeight;

  Blockhash({
    this.blockhash,
    this.lastValidBlockHeight
  });

  String toJson() {
    return """
      {
        "blockhash": "$blockhash",
        "lastValidBlockHeight": $lastValidBlockHeight
      }
    """;
  }

  static Blockhash fromJson(Map<String, dynamic> json) {
    return Blockhash(
      blockhash: json['blockhash'] as String?,
      lastValidBlockHeight: json['lastValidBlockHeight'] as int?,
    );
  }
}