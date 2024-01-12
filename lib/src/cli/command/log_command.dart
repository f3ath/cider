import 'package:args/command_runner.dart';
import 'package:cider/src/cli/command/cider_command.dart';
import 'package:cider/src/cli/command/log_sub_command.dart';
import 'package:cider/src/project.dart';

enum LogType {
  add,
  fix,
  change,
  deprecate,
  remove,
  security,
}

class LogCommand extends CiderCommand {
  LogCommand(super.printer) {
    for (final type in LogType.values) {
      addSubcommand(LogSubCommand(
        type.name,
        type: type,
        description: _subcommandDescriptions[type]!,
        printer: printer,
      ));
    }
  }

  static const _subcommandDescriptions = <LogType, String>{
    LogType.add: 'Add a new feature to the changelog',
    LogType.fix: 'Add a new bug fix to the changelog',
    LogType.change: 'Add a new change to the changelog',
    LogType.deprecate: 'Add a new deprecation to the changelog',
    LogType.remove: 'Add a new removal to the changelog',
    LogType.security: 'Add a new security fix to the changelog',
  };

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
