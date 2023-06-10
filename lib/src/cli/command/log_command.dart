import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/project.dart';

class LogCommand extends CiderCommand {
  LogCommand(super.printer);

  @override
  final name = 'log';
  @override
  final description =
      'Add a new entry to the "Unreleased" section of the changelog';

  @override
  Future<int> exec(Project project) async {
    await project.addUnreleased(argResults!.rest.first, argResults!.rest[1]);
    return 0;
  }
}
