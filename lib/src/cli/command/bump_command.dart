import 'package:args/command_runner.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/bump_sub_command.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:version_manipulation/mutations.dart';

enum BumpType {
  breaking,
  major,
  minor,
  patch,
  build,
  pre,
  release,
}

class BumpCommand extends CiderCommand {
  BumpCommand(super.printer) {
    for (final type in BumpType.values) {
      addSubcommand(BumpSubCommand(
        type.name,
        description: _subcommandDescriptions[type]!,
        mutation: _mutations[type]!,
        printer: printer,
      ));
    }
  }

  static const _mutations = <BumpType, VersionMutation>{
    BumpType.breaking: BumpBreaking(),
    BumpType.major: BumpMajor(),
    BumpType.minor: BumpMinor(),
    BumpType.patch: BumpPatch(),
    BumpType.build: BumpBuild(),
    BumpType.pre: BumpPreRelease(),
    BumpType.release: Release(),
  };

  static const _subcommandDescriptions = <BumpType, String>{
    BumpType.breaking: 'Bump the breaking version',
    BumpType.major: 'Bump the major version',
    BumpType.minor: 'Bump the minor version',
    BumpType.patch: 'Bump the patch version',
    BumpType.build: 'Bump the build version',
    BumpType.pre: 'Bump the pre-release version',
    BumpType.release: 'Bump the release version',
  };

  @override
  final name = 'bump';
  @override
  final description = 'Bump project version';

  @override
  Future<int> exec(Project project) async {
    throw UsageException(
        'Bump command can only be used with subcommands', usage);
  }
}
