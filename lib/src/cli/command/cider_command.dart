import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cider/src/cider.dart';
import 'package:cider/src/cli/console.dart';
import 'package:cider/src/cli/find_project_root.dart';

abstract class CiderCommand extends Command<int> {
  CiderCommand(this.cider, this.printer);

  final Cider cider;
  final Console printer;

  Context get context => Context(globalResults!['project-root'] ??
      findProjectRoot(Directory.current).absolute.path);
}
