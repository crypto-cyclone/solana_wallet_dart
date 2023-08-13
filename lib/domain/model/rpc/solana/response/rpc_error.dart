class RPCError {
  final int code;
  final String message;
  final dynamic data;

  RPCError({
    required this.code,
    required this.message,
    required this.data
  });

  static RPCError fromJson(Map<String, dynamic> json) {
    return RPCError(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}