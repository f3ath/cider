import 'package:cider/src/cli/command/cider_command.dart';

class LogCommand extends CiderCommand {
  LogCommand(super.cider, super.printer);

  @override
  final name = 'log';
  @override
  final description =
      'Add a new entry to the "Unreleased" section of the changelog';

  @override
  Future<int> run() async {
    await cider.addUnreleased(
        context, argResults!.rest.first, argResults!.rest[1]);
    return 0;
  }
}
