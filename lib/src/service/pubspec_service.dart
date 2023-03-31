import 'dart:io';

import 'package:cider/src/cider.dart';
import 'package:cider/src/cider_command.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:rfc_6901/rfc_6901.dart';
import 'package:version_manipulation/mutations.dart';
import 'package:yaml/yaml.dart';

class PubspecService {
  PubspecService(Directory root)
      : _file = File(join(root.path, 'pubspec.yaml'));

  static final _bumpCommands = <String, VersionMutation>{
    'breaking': BumpBreaking(),
    'build': BumpBuild(),
    'major': BumpMajor(),
    'minor': BumpMinor(),
    'patch': BumpPatch(),
    'pre': BumpPreRelease(),
    'release': Release(),
  };

  /// Publishes the [PubspecService] and installs commands (`version`, `bump`)
  static void install(Cider cider) {
    cider.provide((get) => PubspecService(get<Directory>('root')));

    cider.addCommand(_VersionCommand(), (args, get) {
      if (args.rest.isNotEmpty) {
        final version = Version.parse(args.rest.first);
        get<PubspecService>().writeVersion(version);
      }
      get<Stdout>().writeln(get<PubspecService>().readVersion());
      return 0;
    });

    cider.addCommand(_BumpCommand(_bumpCommands.keys), (args, get) {
      final pubspec = get<PubspecService>();
      final part = args.command?.name;
      if (part == null) throw 'Version part must be specified';

      final result = pubspec.bump(part,
          keepBuild: args['keep-build'],
          bumpBuild: args['bump-build'],
          build: args['build'],
          pre: args['pre']);
      get<Stdout>().writeln(result);
      return 0;
    });
  }

  final File _file;

  Pubspec read() => Pubspec.parse(_readAsString());

  /// Reads a value referenced by JSON [pointer] pubspec.yaml.
  /// If the reference does not exist, returns the result of [orElse] or throws
  /// [BadRoute].
  Object? readValue(String pointer, {Object? Function()? orElse}) =>
      JsonPointer(pointer).read(loadYaml(_readAsString()), orElse: orElse);

  Map readMap() => loadYaml(_readAsString()) as Map;

  Version? readVersion() => read().version;

  /// Bumps the given version [part]
  Version bump(String part,
      {bool keepBuild = false,
      bool bumpBuild = false,
      String build = '',
      String pre = ''}) {
    var mutation = _bumpCommands[part.toLowerCase()] ??
        (throw ArgumentError('Invalid version part'));
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
    final current = readVersion()!;
    final next = mutation(current);
    if (next <= current) throw 'The next version must be higher than current';
    writeVersion(next);
    return next;
  }

  /// Sets the project version in pubspec.yaml
  void writeVersion(Version version) {
    final current = read().version.toString();
    final regex = RegExp(r'^version:\s+(\d+\.\d+\.\d+.*)$', multiLine: true);
    final content = _readAsString();
    var processed = false;
    final updated = content.replaceAllMapped(regex, (match) {
      if (processed) throw 'Duplicate version pattern';
      if (match.group(1) == current) {
        processed = true;
        return 'version: $version';
      }
      return match.group(0)!;
    });
    if (!processed) throw 'Failed to replace version';
    _file.writeAsStringSync(updated);
  }

  String _readAsString() => _file.readAsStringSync();
}

class _VersionCommand extends CiderCommand {
  _VersionCommand() : super('version', 'Reads/writes project version');
}

class _BumpCommand extends CiderCommand {
  _BumpCommand(Iterable<String> commands)
      : super('bump', 'Bump project version') {
    for (final command in commands) {
      argParser.addCommand(command);
    }
    argParser
      ..addFlag('keep-build', help: 'Keep the existing build')
      ..addFlag('bump-build', help: 'Also bump the build')
      ..addOption('build',
          help: 'Sets the build to the given value', defaultsTo: '')
      ..addOption('pre',
          help: 'Sets the pre-release to the given value', defaultsTo: '');
  }
}
