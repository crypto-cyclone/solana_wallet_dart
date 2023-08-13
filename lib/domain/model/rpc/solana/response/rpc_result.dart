import 'context.dart';

class RPCResult {
  final Context context;
  final dynamic value;

  RPCResult({
    required this.context,
    required this.value
  });

  static RPCResult fromJson(Map<String, dynamic> json) {
    final contextJson = json['context'] as Map<String, dynamic>;
    final context = Context.fromJson(contextJson);
    final value = json['value'];

    return RPCResult(
      context: context,
      value: value,
    );
  }
}