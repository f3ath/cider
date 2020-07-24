import 'dart:io';

import 'package:cider/cider.dart';

void main(List<String> args) async => exit(
    (await ConsoleApplication('cider').run(args)) ?? ExitCode.missingArgument);
