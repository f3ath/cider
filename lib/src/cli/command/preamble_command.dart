import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/project.dart';

class PreambleCommand extends CiderCommand {
  PreambleCommand(super.printer);

  @override
  final name = 'preamble';
  @override
  final description =
      'Add a new paragraph to the preamble of the "Unreleased" section of the changelog';

  @override
  Future<int> exec(Project project) async {
    await project.addPreamble(argResults!.rest.join(' '));
    return 0;
  }
}
