import 'package:cider/src/cli/command/cider_command.dart';

class ListCommand extends CiderCommand {
  ListCommand(super.cider, super.printer) {
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
  Future<int> run() async {
    (await cider.getAllVersions(context,
            includeYanked: argResults![includeYanked],
            includeUnreleased: argResults![includeUnreleased]))
        .forEach(printer.out.writeln);
    return 0;
  }
}
