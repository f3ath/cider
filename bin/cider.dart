import 'dart:io';

import 'package:cider/cider.dart';

Future<void> main(List<String> args) async {
  exitCode = await Cider().run(args);
}
