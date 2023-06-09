import 'dart:io';

import 'package:change/change.dart';
import 'package:markdown/markdown.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';

/// Changelog manipulation service
class ChangelogService {
  ChangelogService(String projectRoot,
      {this.diffTemplate = '',
      this.tagTemplate = '',
      this.keepEmptyUnreleased = false})
      : file = File(join(projectRoot, 'CHANGELOG.md'));

  final File file;
  final String diffTemplate;
  final String tagTemplate;
  final bool keepEmptyUnreleased;

  /// Adds a new entry to the `Unreleased` section.
  /// Type is one of `a`, `c`, `d`, `f`, `r`, `s`.
  Future<void> addUnreleased(String type, String description) async {
    final map = <String, String>{
      'a': 'Added',
      'c': 'Changed',
      'd': 'Deprecated',
      'f': 'Fixed',
      'r': 'Removed',
      's': 'Security',
    };
    final typeFull = map[type.substring(0, 1)]!;
    final log = await _read() ?? Changelog();
    final markdown = Document().parseInline(description);
    final change = Change(typeFull, markdown);
    log.unreleased.add(change);
    if (diffTemplate.isNotEmpty) {
      final releases = log.history().toList();
      if (releases.isNotEmpty) {
        final last = releases.last;
        log.unreleased.link = diffTemplate
            .replaceAll('%from%', last.version.toString())
            .replaceAll('%to%', 'HEAD');
      }
    }
    await _write(log);
  }

  Future<String> yank(String version) async {
    final log = await _read() ?? (throw StateError('No changelog found'));
    final release = log.get(version);
    release.isYanked = true;
    await _write(log);
    return printRelease(release);
  }

  Future<String> unyank(String version) async {
    final log = await _read() ?? (throw StateError('No changelog found'));
    final release = log.get(version);
    release.isYanked = false;
    await _write(log);
    return printRelease(release);
  }

  /// Returns a markdown description of the given [version] or the `Unreleased`
  /// section.
  Future<String> describe([String? version]) async {
    final log = await _read() ?? Changelog();
    if (version == null) return printUnreleased(log.unreleased);
    return printRelease(log.get(version));
  }

  /// Releases the `Unreleased` section.
  /// Returns the description of the created release.
  Future<String> release(DateTime date, Version version) async {
    final log = await _read() ?? Changelog();
    final release = Release(version, date);
    release.addAll(log.unreleased.changes());
    final parent = log.preceding(release.version);
    if (parent != null && diffTemplate.isNotEmpty) {
      release.link = diffTemplate.map({
        '%from%': parent.version.toString(),
        '%to%': version.toString(),
      });
    } else if (tagTemplate.isNotEmpty) {
      release.link = tagTemplate.replaceAll('%tag%', version.toString());
    }
    log.add(release);
    log.unreleased.clear();
    _write(log);
    return describe(release.version.toString());
  }

  /// Reads the project changelog
  Future<Changelog?> _read() async {
    if (await file.exists()) return parseChangelog(await file.readAsString());
    return null;
  }

  /// (Re)writes the changelog
  Future<void> _write(Changelog changelog) async {
    await file.create(recursive: true);
    await file.writeAsString(
        printChangelog(changelog, keepEmptyUnreleased: keepEmptyUnreleased));
  }
}

extension _String on String {
  String get capitalized =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();

  String map(Map<String, String> replacements) =>
      replacements.entries.fold(this, (s, e) => s.replaceAll(e.key, e.value));
}
