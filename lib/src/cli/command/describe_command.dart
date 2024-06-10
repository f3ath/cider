import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/project.dart';

class DescribeCommand extends CiderCommand {
  DescribeCommand(super.console) {
    argParser.addFlag(onlyBody,
        abbr: 'b',
        help: 'Print only the section body (no header, no link).',
        defaultsTo: false,
        negatable: false);
  }

  static const onlyBody = 'only-body';

  @override
  final name = 'describe';
  @override
  final description = 'Print the version description';

  @override
  Future<int> exec(Project project) async {
    final version = argResults!.rest.isEmpty ? null : argResults!.rest.first;
    console.out.writeln(
        await project.describe(version, onlyBody: argResults![onlyBody]));
    return 0;
  }
}
