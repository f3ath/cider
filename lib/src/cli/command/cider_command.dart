import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cider/src/cider.dart';
import 'package:cider/src/cli/find_project_root.dart';
import 'package:cider/src/cli/printer.dart';

abstract class CiderCommand extends Command<int> {
  CiderCommand(this.cider, this.printer);

  final Cider cider;
  final Printer printer;

  Context get context => Context(globalResults!['project-root'] ??
      findProjectRoot(Directory.current).absolute.path);
}
