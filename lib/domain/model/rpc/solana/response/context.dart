class Context {
  final String? apiVersion;
  final int? slot;

  Context({
    required this.apiVersion,
    required this.slot
  });

  static Context fromJson(Map<String, dynamic> json) {
    return Context(
      apiVersion: json['apiVersion'] as String?,
      slot: json['slot'] as int?,
    );
  }
}