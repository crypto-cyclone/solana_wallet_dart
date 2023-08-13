class RPCError {
  final int code;
  final String message;
  final dynamic data;

  RPCError({
    required this.code,
    required this.message,
    required this.data
  });
}