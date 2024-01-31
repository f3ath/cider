import 'package:args/command_runner.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/cli/command/log_sub_command.dart';
import 'package:cider/src/project.dart';

enum LogType {
  fix('Add a new bug fix to the changelog'),
  add('Add a new feature to the changelog'),
  change('Add a new change to the changelog'),
  deprecate('Add a new deprecation to the changelog'),
  remove('Add a new removal to the changelog'),
  security('Add a new security fix to the changelog');

  const LogType(this.description);

  final String description;
}

class LogCommand extends CiderCommand {
  LogCommand(super.console) {
    for (final type in LogType.values) {
      addSubcommand(
        LogSubCommand(type.name, type.description, type, console),
      );
    }
  }

  @override
  final name = 'log';
  @override
  final description =
      'Add a new entry to the "Unreleased" section of the changelog';

  @override
  Future<int> exec(Project project) async {
    throw UsageException(
        'Log command can only be used with subcommands', usage);
  }
}
