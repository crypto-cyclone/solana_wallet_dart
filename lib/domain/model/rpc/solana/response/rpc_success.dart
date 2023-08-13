import 'context.dart';

abstract class RPCSuccess {
  final Context context;
  final dynamic value;

  RPCSuccess({
    required this.context,
    required this.value
  });

  String toResult() {
    throw UnimplementedError("toResult() is not implemented");
  }
}