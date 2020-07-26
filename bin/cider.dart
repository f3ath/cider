import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cider/cider.dart';

void main(List<String> args) async {
  int code;
  try {
    code = await ConsoleApplication('cider').run(args);
  } on UsageException catch (e) {
    // This avoids trace dumping
    print(e);
  }
  exit(code ?? ExitCode.usageException);
}
