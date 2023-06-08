import 'package:cider/src/cli/command/cider_command.dart';

class YankCommand extends CiderCommand {
  YankCommand(super.cider, super.printer);

  @override
  final name = 'yank';
  @override
  final description = 'Yank a version from the changelog';

  @override
  Future<int> run() async {
    final version = argResults!.rest.first;
    final release = await cider.yank(context, version);
    printer.out.writeln(release);
    return 0;
  }
}
