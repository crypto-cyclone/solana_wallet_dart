class AccountInfo {
  final bool? executable;
  final String? owner;
  final BigInt? lamports;
  final List<String>? data;
  final BigInt? rentEpoch;
  final BigInt? space;

  AccountInfo({
    this.executable,
    this.owner,
    this.lamports,
    this.data,
    this.rentEpoch,
    this.space
  });

  String toJson() {
    return """{
        "executable": $executable,
        "owner": "$owner",
        "lamports": $lamports,
        ${data != null ? "data: ${[...data!.map((e) => "\"$e\"")]}," : ""}
        "rentEpoch": $rentEpoch,
        "space": $space
      }
    """;
  }

  static AccountInfo fromJson(Map<String, dynamic> json) {
    var jsonData = json['data'];
    List<String>? data;

    if (jsonData is List) {
      data = jsonData.map((item) => item.toString()).toList();
    } else if (jsonData is String) {
      data = [jsonData];
    }

    return AccountInfo(
      executable: json['executable'] as bool?,
      owner: json['owner'] as String?,
      lamports: json['lamports'] as BigInt?,
      data: data,
      rentEpoch: json['rentEpoch'] as BigInt?,
      space: json['space'] as BigInt?,
    );
  }
}