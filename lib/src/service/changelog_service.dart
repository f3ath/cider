import 'dart:io';

import 'package:change/change.dart';
import 'package:cider/src/cider.dart';
import 'package:cider/src/cider_command.dart';
import 'package:cider/src/service/pubspec_service.dart';
import 'package:markdown/markdown.dart';
import 'package:path/path.dart';

/// Change log manipulation service
class ChangelogService {
  ChangelogService(Directory root, this.pubspec)
      : _file = File(join(root.path, 'CHANGELOG.md'));

  /// Installs the service
  static void install(Cider cider) {
    cider.provide((get) =>
        ChangelogService(get<Directory>('root'), get<PubspecService>()));

    cider.addCommand(_LogCommand(), (args, get) {
      get<ChangelogService>().addUnreleased(args.rest.first, args.rest[1]);
      return null;
    });

    cider.addCommand(_DescribeCommand(), (args, get) {
      final version = args.rest.isEmpty ? null : args.rest.first;
      final section = get<ChangelogService>().describe(version);
      get<Stdout>().writeln(section);
      return null;
    });

    cider.addCommand(_ReleaseCommand(), (args, get) {
      final date = args['date'];
      final parsedDate =
          date == 'today' ? DateTime.now() : DateTime.parse(date);
      final release = get<ChangelogService>().release(parsedDate);
      get<Stdout>().writeln(release);
      return null;
    });
  }

  final File _file;
  final PubspecService pubspec;

  /// Adds a new entry to the `Unreleased` section.
  /// Type is one of `a`, `c`, `d`, `f`, `r`, `s`.
  void addUnreleased(String type, String description) {
    final map = <String, String>{
      'a': 'Added',
      'c': 'Changed',
      'd': 'Deprecated',
      'f': 'Fixed',
      'r': 'Removed',
      's': 'Security',
    };
    type = map[type.substring(0, 1)]!;
    final log = read() ?? Changelog();
    final markdown = Document().parseInline(description);
    final change = Change(type.capitalized, markdown);
    log.unreleased.add(change);
    final diffTemplate =
        pubspec.readValue('/cider/link_template/diff', orElse: () => null);
    if (diffTemplate is String) {
      final releases = log.history().toList();
      if (releases.isNotEmpty) {
        final last = releases.last;
        log.unreleased.link = diffTemplate
            .replaceAll('%from%', last.version.toString())
            .replaceAll('%to%', 'HEAD');
      }
    }
    write(log);
  }

  /// (Re)writes the changelog
  void write(Changelog changelog, {bool keepEmptyUnreleased = false}) {
    _file.createSync(recursive: true);
    _file.writeAsStringSync(
        printChangelog(changelog, keepEmptyUnreleased: keepEmptyUnreleased));
  }

  /// Reads the project changelog
  Changelog? read() {
    if (_file.existsSync()) return parseChangelog(_file.readAsStringSync());
    return null;
  }

  /// Returns a markdown description of the given [version] or the `Unreleased`
  /// section.
  String describe([String? version]) {
    final log = read() ?? Changelog();
    if (version == null) return printUnreleased(log.unreleased);
    return printRelease(log.get(version));
  }

  /// Releases the `Unreleased` section.
  /// Returns the description of the created release.
  String release(DateTime date) {
    final log = read() ?? Changelog();
    final version = pubspec.readVersion()!;
    final release = Release(version, date);
    release.addAll(log.unreleased.changes());
    final parent = log.preceding(release.version);
    final diffTemplate =
        pubspec.readValue('/cider/link_template/diff', orElse: () => null);
    final tagTemplate =
        pubspec.readValue('/cider/link_template/tag', orElse: () => null);
    if (parent != null && diffTemplate is String) {
      release.link = diffTemplate.map({
        '%from%': parent.version.toString(),
        '%to%': version.toString(),
      });
    } else if (tagTemplate is String) {
      release.link = tagTemplate.replaceAll('%tag%', version.toString());
    }
    log.add(release);
    log.unreleased.clear();
    write(log);
    return describe(release.version.toString());
  }
}

class _LogCommand extends CiderCommand {
  _LogCommand() : super('log', 'Add a new entry to the changelog');
}

class _DescribeCommand extends CiderCommand {
  _DescribeCommand() : super('describe', 'Print the version description');
}

class _ReleaseCommand extends CiderCommand {
  _ReleaseCommand() : super('release', 'Release the unreleased changes') {
    argParser.addOption('date', help: 'Release date', defaultsTo: 'today');
  }
}

extension _String on String {
  String get capitalized =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();

  String map(Map<String, String> replacements) =>
      replacements.entries.fold(this, (s, e) => s.replaceAll(e.key, e.value));
}
