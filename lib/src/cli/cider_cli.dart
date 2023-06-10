import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cider/src/cli/command/bump_command.dart';
import 'package:cider/src/cli/command/describe_command.dart';
import 'package:cider/src/cli/command/list_command.dart';
import 'package:cider/src/cli/command/log_command.dart';
import 'package:cider/src/cli/command/release_command.dart';
import 'package:cider/src/cli/command/unyank_command.dart';
import 'package:cider/src/cli/command/version_command.dart';
import 'package:cider/src/cli/command/yank_command.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/cli/error_interceptor.dart';

class CiderCli extends CommandRunner<int> {
  CiderCli({this.console = const Console()})
      : super('cider', 'Dart package maintenance tools') {
    argParser.addOption('project-root');
    addCommand(BumpCommand(console));
    addCommand(DescribeCommand(console));
    addCommand(ListCommand(console));
    addCommand(LogCommand(console));
    addCommand(ReleaseCommand(console));
    addCommand(UnyankCommand(console));
    addCommand(VersionCommand(console));
    addCommand(YankCommand(console));
  }

  final Console console;

  @override
  Future<int> run(Iterable<String> args) =>
      ErrorInterceptor(console).run(() => super.run(args));
}
