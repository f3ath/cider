import 'dart:io';

import 'package:cider/src/replace_version.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:rfc_6901/rfc_6901.dart';
import 'package:version_manipulation/mutations.dart';
import 'package:yaml/yaml.dart';

/// Manipulates the pubspec.yaml.
class PubspecService {
  PubspecService(String projectRoot)
      : _file = File(join(projectRoot, fileName));
  static const fileName = 'pubspec.yaml';
  final File _file;

  Future<Version> getVersion() async =>
      (await _readPubspec()).version ?? (throw StateError('Version not found'));

  /// Writes the project version to pubspec.yaml.
  Future<void> setVersion(Version version) async {
    await _writeString(replaceVersion(await _readString(),
        (await getVersion()).toString(), version.toString()));
  }

  Future<Version> mutateVersion(VersionMutation mutation,
      {bool keepBuild = false,
      bool bumpBuild = false,
      String build = '',
      String pre = ''}) async {
    if (keepBuild) {
      mutation = KeepBuild(mutation);
    }
    if (bumpBuild) {
      mutation = Sequence([KeepBuild(mutation), BumpBuild()]);
    }
    if (build.isNotEmpty) {
      mutation = Sequence([mutation, SetBuild(build)]);
    }
    if (pre.isNotEmpty) {
      mutation = Sequence([mutation, SetPreRelease(pre)]);
    }
    final current = await getVersion();
    final next = mutation(current);
    if (next <= current) {
      throw ArgumentError(
          'The next version must be higher than the current one.');
    }
    await setVersion(next);
    return next;
  }

  /// Reads a value referenced by JSON [pointer] pubspec.yaml.
  /// If the reference does not exist, returns the result of [orElse] or throws
  /// [BadRoute].
  Future<Object?> getValue(String pointer,
          {Object? Function()? orElse}) async =>
      JsonPointer(pointer).read(await _readYaml(), orElse: orElse);

  Future<Pubspec> _readPubspec() async => Pubspec.parse(await _readString());

  Future<String> _readString() => _file.readAsString();

  Future<YamlMap> _readYaml() async => loadYaml(await _file.readAsString());

  Future<void> _writeString(String contents) =>
      _file.writeAsString(contents, flush: true);
}
