import 'package:cider/src/cli/command/cider_command.dart';

class DescribeCommand extends CiderCommand {
  DescribeCommand(super.cider, super.printer);

  @override
  final name = 'describe';
  @override
  final description = 'Print the version description';

  @override
  Future<int> run() async {
    final version = argResults!.rest.isEmpty ? null : argResults!.rest.first;
    printer.out.writeln(await cider.describe(context, version));
    return 0;
  }
}
