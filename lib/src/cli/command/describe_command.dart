import 'package:cider/src/cli/command/cider_command.dart';

class DescribeCommand extends CiderCommand {
  DescribeCommand(super.cider, super.printer) {
    argParser.addFlag(onlyBody,
        abbr: 'b',
        help: 'Print only the section body (no header)',
        defaultsTo: false,
        hide: true,
        // TODO: remove when implemented
        negatable: false);
  }

  static const onlyBody = 'only-body';

  @override
  final name = 'describe';
  @override
  final description = 'Print the version description';

  @override
  Future<int> run() async {
    final version = argResults!.rest.isEmpty ? null : argResults!.rest.first;
    printer.out.writeln(await cider.describe(context, version,
        onlyBody: argResults![onlyBody]));
    return 0;
  }
}
