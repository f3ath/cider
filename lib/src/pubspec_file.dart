import 'dart:io';

import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

class PubspecFile {
  PubspecFile(this._dir);

  static final name = 'pubspec.yaml';

  final String _dir;

  /// Reads the project version from pubspec.yaml
  Version readVersion() =>
      _read().version.map((_) => Version.parse(_)).valueOr(() => Version.none);

  /// Writes the project version to pubspec.yaml
  void writeVersion(Version version) => update((pubspec) => pubspec.copyWith(
      version: pubspec.version.map((_) => version.toString())));

  /// Updated pubspec.yaml in-place.
  void update(PubspecYaml Function(PubspecYaml pubspec) mutate) =>
      _write(mutate(_read()));

  void _write(PubspecYaml pubspecYaml) =>
      _file.writeAsStringSync(pubspecYaml.toYamlString());

  PubspecYaml _read() => _file.readAsStringSync().toPubspecYaml();

  File get _file => File(join(_dir, name));
}
