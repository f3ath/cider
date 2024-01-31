import 'package:cider/src/cli/command/log_command.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class LogSubCommand extends CiderCommand {
  LogSubCommand(
    this.name, {
    required this.description,
    required this.type,
    required Console printer,
  }) : super(printer);

  @override
  final String name;

  @override
  final String description;

  final LogType type;

  @override
  Future<int> exec(Project project) async {
    await project.addUnreleased(type.name, argResults!.rest.first);

    return 0;
  }
}
