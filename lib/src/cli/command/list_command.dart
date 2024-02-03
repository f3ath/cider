import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class ListCommand extends CiderCommand {
  ListCommand(super.console) {
    argParser.addFlag(includeYanked,
        abbr: 'y',
        help: 'Include yanked versions',
        defaultsTo: false,
        negatable: false);
    argParser.addFlag(includeUnreleased,
        abbr: 'u',
        help:
            'If the "Unreleased" section is not empty, it will be prepended to the list',
        defaultsTo: false,
        negatable: false);
  }

  static const includeYanked = 'include-yanked';
  static const includeUnreleased = 'include-unreleased';

  @override
  final name = 'list';
  @override
  final description = 'Lists all versions from the changelog';

  @override
  Future<int> exec(Project project) async {
    (await project.getAllVersions(
            includeYanked: argResults![includeYanked],
            includeUnreleased: argResults![includeUnreleased]))
        .forEach(console.out.writeln);
    return 0;
  }
}
