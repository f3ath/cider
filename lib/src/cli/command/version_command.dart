import 'package:cider/src/cli/command/cider_command.dart';

class VersionCommand extends CiderCommand {
  VersionCommand(super.cider, super.printer);

  @override
  final name = 'version';
  @override
  final description = 'Reads/writes project version';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      await cider.setVersion(context, argResults!.rest.first);
    }
    printer.out.writeln(await cider.getVersion(context));
    return 0;
  }
}
