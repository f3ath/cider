import 'dart:io';

import 'package:cider/cider.dart';

void main(List<String> args) =>
    Cider().run(args).then((code) => exitCode = code);
