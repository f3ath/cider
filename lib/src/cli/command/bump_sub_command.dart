import 'package:cider/src/cli/console.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:version_manipulation/mutations.dart';

class BumpSubCommand extends CiderCommand {
  BumpSubCommand(this.name, this.description, this.mutation, Console console)
      : super(console) {
    argParser
      ..addFlag('keep-build', help: 'Keep the existing build')
      ..addFlag('bump-build', help: 'Also bump the build')
      ..addOption('build',
          help: 'Sets the build to the given value', defaultsTo: '')
      ..addOption('pre',
          help: 'Sets the pre-release to the given value', defaultsTo: '');
  }

  @override
  final String name;

  @override
  final String description;

  final VersionMutation mutation;

  @override
  Future<int> exec(Project project) async {
    final result = await project.bumpVersion(mutation,
        keepBuild: argResults!['keep-build'],
        bumpBuild: argResults!['bump-build'],
        build: argResults!['build'],
        pre: argResults!['pre']);
    console.out.writeln(result);

    return 0;
  }
}
