import 'dart:io';

import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';

class PubspecFile {
  PubspecFile(this._dir);

  static final name = 'pubspec.yaml';

  final String _dir;

  /// Reads the project version from pubspec.yaml
  Version readVersion() => Version.parse(_findVersion(_readLines()));

  /// Writes the project version to pubspec.yaml
  void writeVersion(Version version) => _file.writeAsStringSync(
      _setVersion(_readLines(), version.toString()).join('\n'));

  List<String> _readLines() => _file.readAsLinesSync();
  final regex = RegExp(
      r'''^(?<prefix>version\:\s+)(?<quote>['"]?)(?<version>[a-z-A-Z0-9\.+-]+)\2(?<suffix>.*)?$''');

  String _findVersion(List<String> lines) {
    final candidates = lines
        .map(regex.firstMatch)
        .where((match) => match != null)
        .map((match) => match.namedGroup('version'))
        .toList();
    if (candidates.length == 1) return candidates.single;
    throw Exception('Can not reliably determine the version');
  }

  List<String> _setVersion(List<String> lines, String version) {
    var isReplaced = false;
    final updated = lines.map((line) {
      final match = regex.firstMatch(line);
      if (match != null) {
        if (isReplaced) {
          throw Exception('Can not reliably update the version');
        }
        isReplaced = true;
        return [
          match.namedGroup('prefix'),
          match.namedGroup('quote') ?? '',
          version,
          match.namedGroup('quote') ?? '',
          match.namedGroup('suffix') ?? ''
        ].join();
      }
      return line;
    }).toList();
    if (isReplaced) return updated;
    throw Exception('Can not find the version');
  }

  File get _file => File(join(_dir, name));
}
