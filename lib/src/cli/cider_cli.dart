import 'package:args/command_runner.dart';
import 'package:cider/src/cider.dart';
import 'package:cider/src/cli/command/bump_command.dart';
import 'package:cider/src/cli/command/describe_command.dart';
import 'package:cider/src/cli/command/log_command.dart';
import 'package:cider/src/cli/command/release_command.dart';
import 'package:cider/src/cli/command/unyank_command.dart';
import 'package:cider/src/cli/command/version_command.dart';
import 'package:cider/src/cli/command/yank_command.dart';
import 'package:cider/src/cli/printer.dart';

class CiderCli extends CommandRunner<int> {
  CiderCli(Cider cider, Printer printer)
      : super('cider', 'Dart package maintenance tools') {
    argParser.addOption('project-root');
    addCommand(VersionCommand(cider, printer));
    addCommand(BumpCommand(cider, printer));
    addCommand(LogCommand(cider, printer));
    addCommand(DescribeCommand(cider, printer));
    addCommand(ReleaseCommand(cider, printer));
    addCommand(YankCommand(cider, printer));
    addCommand(UnyankCommand(cider, printer));
  }
}
