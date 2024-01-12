class MemCmp {
  final int offset;
  final String bytes;

  MemCmp({
    required this.offset,
    required this.bytes
  });

  String toJson() {
    return '{"offset":$offset,"bytes":"$bytes"}';
  }
}