import 'dart:io';

import 'package:path/path.dart';

File changelogFile(String projectRoot) =>
    File(join(projectRoot, 'CHANGELOG.md'));
