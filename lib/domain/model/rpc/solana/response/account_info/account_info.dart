class AccountInfo {
  final bool? executable;
  final String? owner;
  final int? lamports;
  final List<String>? data;
  final int? rentEpoch;
  final int? space;

  AccountInfo({
    this.executable,
    this.owner,
    this.lamports,
    this.data,
    this.rentEpoch,
    this.space
  });

  String toJson() {
    return """
      {
        "executable": $executable,
        "owner": "$owner",
        "lamports": $lamports,
        "data": $data,
        "rentEpoch": $rentEpoch,
        "space": $space
      }
    """;
  }

  static AccountInfo fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      executable: json['executable'] as bool?,
      owner: json['owner'] as String?,
      lamports: json['lamports'] as int?,
      data: (json['data'] as List<dynamic>?)?.map((item) => item as String).toList(),
      rentEpoch: json['rentEpoch'] as int?,
      space: json['space'] as int?,
    );
  }
}