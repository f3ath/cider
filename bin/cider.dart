import 'dart:io';

import 'package:cider/cider.dart';


Future<void> main(List<String> args) async {
  exitCode = await CiderCli(Cider(), Printer()).run(args) ?? 0;
}
