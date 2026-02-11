import 'dart:io';

import 'package:change/change.dart';
import 'package:cider/src/changelog_file.dart';
import 'package:cider/src/cli/config.dart';
import 'package:cider/src/pubspec_file.dart';
import 'package:cider/src/replace_version.dart';
import 'package:markdown/markdown.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:version_manipulation/mutations.dart' as m;

/// The project we're working with.
class Project {
  Project(String projectRoot, this._config)
      : _pubspec = pubspecFile(projectRoot),
        _changelog = changelogFile(projectRoot);

  final File _pubspec;
  final File _changelog;
  final Config _config;

  /// Reads the project version from the pubspec.yaml.
  Future<Version> getVersion() => _readPubspec().then((it) => it.version!);

  /// Writes the project version to pubspec.yaml.
  Future<void> setVersion(Version newVersion) async {
    final oldVersion = await getVersion();
    final pubspec = await _pubspec.readAsString();
    final updated = replaceVersion(pubspec, oldVersion, newVersion);
    await _writePubspecString(updated);
  }

  /// Bumps the project version.
  Future<Version> bumpVersion(m.VersionMutation mutation,
      {bool keepBuild = false,
      bool bumpBuild = false,
      String build = '',
      String pre = ''}) async {
    if (keepBuild) {
      mutation = m.KeepBuild(mutation);
    }
    if (bumpBuild) {
      mutation = m.Sequence([m.KeepBuild(mutation), m.BumpBuild()]);
    }
    if (build.isNotEmpty) {
      mutation = m.Sequence([mutation, m.SetBuild(build)]);
    }
    if (pre.isNotEmpty) {
      mutation = m.Sequence([mutation, m.SetPreRelease(pre)]);
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

  /// Adds a new paragraph to the preamble (the free text right after the header)
  /// of the `Unreleased` section.
  Future<void> addPreamble(String text) => _updateChangelog((it) {
        it.unreleased.preamble
            .add(Element('p', Document().parseInline(text.trim())));
      });

  /// Adds a new entry to the `Unreleased` section.
  /// Type is one of `a`, `c`, `d`, `f`, `r`, `s`.
  Future<void> addUnreleased(String type, String description) =>
      _updateChangelog((log) {
        const map = <String, String>{
          'a': 'Added',
          'c': 'Changed',
          'd': 'Deprecated',
          'f': 'Fixed',
          'r': 'Removed',
          's': 'Security',
        };
        final typeFull = map[type.substring(0, 1)]!;
        final change = Change(typeFull, Document().parseInline(description));
        log.unreleased.add(change);
        if (_config.diffTemplate.isNotEmpty) {
          final releases = log.history().toList();
          if (releases.isNotEmpty) {
            final lastVersionTag =
                _config.tagPrefix + releases.last.version.toString();
            log.unreleased.link =
                _config.diffTemplate.render(lastVersionTag, 'HEAD');
          }
        }
      });

  /// Returns a markdown description of the given [version] or the `Unreleased`
  /// section.
  Future<String> describe(String? version, {bool onlyBody = false}) async {
    final log = await _readChangelog();
    if (version == null) {
      final section = log.unreleased;
      if (onlyBody) {
        return printChanges(section);
      }
      return printUnreleased(section);
    }
    final section = log.get(version);
    if (onlyBody) {
      return printChanges(section);
    }
    return printRelease(section);
  }

  /// Releases the `Unreleased` section.
  /// Returns the description of the created release.
  Future<String> release(DateTime date, {Version? version}) async {
    version ??= await getVersion();
    await _updateChangelog((log) {
      final release = Release(version!, date);
      release.preamble.addAll(log.unreleased.preamble);
      release.addAll(log.unreleased.changes());
      final parent = log.preceding(release.version);
      final taggedVersion = _config.tagPrefix + release.version.toString();
      if (parent != null && _config.diffTemplate.isNotEmpty) {
        final parentTaggedVersion =
            _config.tagPrefix + parent.version.toString();
        release.link =
            _config.diffTemplate.render(parentTaggedVersion, taggedVersion);
      } else if (_config.tagTemplate.isNotEmpty) {
        release.link = _config.tagTemplate.render(taggedVersion);
      }
      log.add(release);
      log.unreleased.clear();
    });
    return describe(version.toString());
  }

  Future<String> setYanked(String version, bool yanked) async {
    await _updateChangelog((log) {
      log.get(version).isYanked = yanked;
    });
    return describe(version);
  }

  /// Lists all versions in the changelog.
  /// If [includeYanked] is true, yanked version will be included.
  /// if [includeUnreleased] is true and the "Unreleased" section is not empty,
  /// the "Unreleased" section will be prepended to the listing.
  Future<List<String>> getAllVersions(
      {bool includeYanked = false, bool includeUnreleased = false}) async {
    final changelog = await _readChangelog();
    final versions = changelog
        .history()
        .where((release) => !release.isYanked || includeYanked)
        .map((release) => release.version.toString())
        .toList()
        .reversed
        .toList();
    if (includeUnreleased && changelog.unreleased.isNotEmpty) {
      versions.insert(0, 'Unreleased');
    }
    return versions;
  }

  Future<Pubspec> _readPubspec() => _pubspec.readAsString().then(Pubspec.parse);

  Future<void> _writePubspecString(String contents) =>
      _pubspec.writeAsString(contents, flush: true);

  Future<Changelog> _updateChangelog(Function(Changelog changelog) f) async {
    final changelog = await _readChangelog();
    f(changelog);
    await _writeChangelog(changelog);
    return changelog;
  }

  /// Reads the project changelog
  Future<Changelog> _readChangelog() async {
    if (await _changelog.exists()) {
      return parseChangelog(await _changelog.readAsString());
    }
    return Changelog();
  }

  /// (Re)writes the changelog
  Future<void> _writeChangelog(Changelog changelog) async {
    await _changelog.create(recursive: true);
    final rendered = printChangelog(changelog,
        keepEmptyUnreleased: _config.keepEmptyUnreleased);
    await _changelog.writeAsString(
        rendered + (_config.changelogNewline ? '\n' : ''),
        flush: true);
  }
}
