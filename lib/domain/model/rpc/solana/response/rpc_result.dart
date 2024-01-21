import 'context.dart';

class RPCResult {
  final Context? context;
  final dynamic value;

  RPCResult({
    this.context,
    required this.value
  });

  static RPCResult fromJsonObject(Map<String, dynamic> json) {
    final contextJson = json['context'] as Map<String, dynamic>;
    final context = Context.fromJson(contextJson);
    final value = json['value'];

    return RPCResult(
      context: context,
      value: value,
    );
  }

  static RPCResult fromJsonPrimitive(dynamic json) {
    return RPCResult(value: json);
  }

  static RPCResult fromJsonList(List<dynamic> json) {
    return RPCResult(value: json);
  }
}