import 'helper.dart';

class AnchorIDLErrorGenerator {
  String generate(idl) {
    var idlName = idl['name'];

    return idl['errors'].map((error) {

      var errorName = error['name'];
      var className = ExtendedErrorClassName(idlName, errorName);
      var defaultConstructor = _generateDefaultConstructor(idlName, error);

      return '''
class $className extends ${AnchorErrorClassName()} {
$defaultConstructor
}
''';
    })
        .join('\n');
  }
}

String _generateDefaultConstructor(String idlName, error) {
  var errorName = error['name'];
  var className = ExtendedErrorClassName(idlName, errorName);

  var name = error['name'];
  var code = error['code'];
  var msg = error['msg'];

  return '''
  $className()
    : super(code: $code, name: '$name', msg: '$msg');
''';
}