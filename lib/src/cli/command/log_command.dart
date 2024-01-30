import 'package:args/command_runner.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/cli/command/log_sub_command.dart';
import 'package:cider/src/project.dart';

enum LogType {
  add(description: 'Add a new feature to the changelog'),
  fix(description: 'Add a new bug fix to the changelog'),
  change(description: 'Add a new change to the changelog'),
  deprecate(description: 'Add a new deprecation to the changelog'),
  remove(description: 'Add a new removal to the changelog'),
  security(description: 'Add a new security fix to the changelog');

  const LogType({
    required this.description,
  });

  final String description;
}

class LogCommand extends CiderCommand {
  LogCommand(super.printer) {
    for (final type in LogType.values) {
      addSubcommand(LogSubCommand(
        type.name,
        type: type,
        description: type.description,
        printer: printer,
      ));
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
