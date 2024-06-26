import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cider/src/cli/command/bump_command.dart';
import 'package:cider/src/cli/command/describe_command.dart';
import 'package:cider/src/cli/command/list_command.dart';
import 'package:cider/src/cli/command/log_command.dart';
import 'package:cider/src/cli/command/preamble_command.dart';
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
    [
      BumpCommand(console),
      DescribeCommand(console),
      ListCommand(console),
      LogCommand(console),
      PreambleCommand(console),
      ReleaseCommand(console),
      UnyankCommand(console),
      VersionCommand(console),
      YankCommand(console),
    ].forEach(addCommand);
  }

  final Console console;

  @override
  Future<int> run(Iterable<String> args) =>
      ErrorInterceptor(console).run(() => super.run(args));

  @override
  void printUsage() => console.out.writeln(usage);
}
