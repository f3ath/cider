import 'package:cider/src/cli/command/cider_command.dart';
import 'package:version_manipulation/mutations.dart';

class BumpCommand extends CiderCommand {
  BumpCommand(super.cider, super.printer) {
    mutations.keys.forEach(argParser.addCommand);
    argParser
      ..addFlag('keep-build', help: 'Keep the existing build')
      ..addFlag('bump-build', help: 'Also bump the build')
      ..addOption('build',
          help: 'Sets the build to the given value', defaultsTo: '')
      ..addOption('pre',
          help: 'Sets the pre-release to the given value', defaultsTo: '');
  }

  static const mutations = <String, VersionMutation>{
    'breaking': BumpBreaking(),
    'build': BumpBuild(),
    'major': BumpMajor(),
    'minor': BumpMinor(),
    'patch': BumpPatch(),
    'pre': BumpPreRelease(),
    'release': Release(),
  };

  @override
  final name = 'bump';
  @override
  final description = 'Bump project version';

  @override
  Future<int> run() async {
    final part = argResults!.command?.name ??
        (throw ArgumentError('Version part must be specified'));

    final result = await cider.bumpVersion(context, mutations[part]!,
        keepBuild: argResults!['keep-build'],
        bumpBuild: argResults!['bump-build'],
        build: argResults!['build'],
        pre: argResults!['pre']);
    printer.out.writeln(result);
    return 0;
  }
}
