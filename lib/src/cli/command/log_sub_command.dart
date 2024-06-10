import 'package:cider/src/cli/command/log_command.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/project.dart';
import 'package:cider/src/cli/command/cider_command.dart';

class LogSubCommand extends CiderCommand {
  LogSubCommand(this.name, this.description, this.type, Console console)
      : super(console) {
    // Allow any prefix to be used as an alias. e.g.:
    // cider log a "Changes added"
    // cider log fix "Bug fixed"
    // cider log sec "Security fix"
    for (int i = 1; i < name.length; i++) {
      aliases.add(name.substring(0, i));
    }
  }

  @override
  final aliases = <String>[];

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
