import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

final log = Logger('GenerateIDLBuilder');

Builder generateIDL(BuilderOptions options) => _IDLBuilder();

class _IDLBuilder implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    var projectRoot = Directory.current.path;
    var inputDir = join(projectRoot, 'test', 'idl');
    var outputDir = join(projectRoot, 'test', 'api', 'idl', 'mocks');
    var scriptPath = join(projectRoot, 'bin', 'cyclone-idl.dart');

    var result = await Process.run(
        'dart',
        [scriptPath, '--input-dir', inputDir, '--output-dir', outputDir]
    );

    if (result.exitCode != 0) {
      throw Exception('Error generating IDL files.');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.dart': ['.g.dart']
  };
}