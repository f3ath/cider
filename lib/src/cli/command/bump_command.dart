import 'package:args/command_runner.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/bump_sub_command.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:version_manipulation/mutations.dart';

enum BumpType {
  breaking(BumpBreaking(), 'Bump the breaking version'),
  major(BumpMajor(), 'Bump the major version'),
  minor(BumpMinor(), 'Bump the minor version'),
  patch(BumpPatch(), 'Bump the patch version'),
  build(BumpBuild(), 'Bump the build version'),
  pre(BumpPreRelease(), 'Bump the pre-release version'),
  release(Release(), 'Bump the release version');

  const BumpType(this.mutation, this.description);

  final VersionMutation mutation;
  final String description;
}

class BumpCommand extends CiderCommand {
  BumpCommand(super.console) {
    for (final type in BumpType.values) {
      addSubcommand(
        BumpSubCommand(type.name, type.description, type.mutation, console),
      );
    }
  }

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
