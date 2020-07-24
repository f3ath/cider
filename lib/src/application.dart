import 'dart:io';

import 'package:change/model.dart';
import 'package:cider/src/application_exception.dart';
import 'package:cider/src/changelog_file.dart';
import 'package:cider/src/config.dart';
import 'package:cider/src/pubspec_file.dart';
import 'package:marker/flavors.dart' as flavors;
import 'package:marker/marker.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:path/path.dart';
import 'package:version_manipulation/mutations.dart';

class Application {
  Application({String projectRoot = '.'})
      : _pubspec = PubspecFile(projectRoot),
        _changelogFile = ChangelogFile(projectRoot),
        _config = Config.readFile(File(join(projectRoot, '.cider.yaml')));

  final PubspecFile _pubspec;
  final ChangelogFile _changelogFile;
  final Config _config;

  void logChange(ChangeType type, String text) =>
      _changelogFile.update((changelog) {
        changelog.unreleased.changes.addText(type, text);
        return changelog;
      });

  String bump(VersionMutation mutation) {
    final current = _pubspec.readVersion();
    final updated = mutation(current);
    _pubspec.writeVersion(updated);
    return updated.toString();
  }

  void release(String date) {
    final version = _pubspec.readVersion().toString();
    _changelogFile.update((changelog) {
      if (changelog.releases.any((release) => release.version == version)) {
        throw ApplicationException('Release already exists');
      }
      changelog.release(version, date, link: _config.diffLinkTemplate.or(''));
      return changelog;
    });
  }

  /// Reads the current project version from pubspec.yaml
  String readVersion() => _pubspec.readVersion().toString();

  /// Reads the markdown description for the given release
  String describe([String version]) {
    final changelog = _changelogFile.read();
    if (changelog.releases.isEmpty) throw 'No releases found in CHANGELOG';
    final release = Maybe(version)
        .map((ver) => changelog.releases.firstWhere(
            (release) => release.version == ver,
            orElse: () => throw 'Version $ver not found'))
        .or(changelog.releases.last);
    return render(release.toMarkdown(), flavor: flavors.changelog);
  }
}
