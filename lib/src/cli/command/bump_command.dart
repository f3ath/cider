import 'package:args/command_runner.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/bump_sub_command.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:version_manipulation/mutations.dart';

enum BumpType {
  breaking(mutation: BumpBreaking(), description: 'Bump the breaking version'),
  major(mutation: BumpMajor(), description: 'Bump the major version'),
  minor(mutation: BumpMinor(), description: 'Bump the minor version'),
  patch(mutation: BumpPatch(), description: 'Bump the patch version'),
  build(mutation: BumpBuild(), description: 'Bump the build version'),
  pre(mutation: BumpPreRelease(), description: 'Bump the pre-release version'),
  release(mutation: Release(), description: 'Bump the release version');

  const BumpType({
    required this.mutation,
    required this.description,
  });

  final VersionMutation mutation;
  final String description;
}

class BumpCommand extends CiderCommand {
  BumpCommand(super.printer) {
    for (final type in BumpType.values) {
      addSubcommand(BumpSubCommand(
        type.name,
        description: type.description,
        mutation: type.mutation,
        printer: printer,
      ));
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
