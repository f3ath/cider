import 'dart:io';

import 'package:path/path.dart';

File pubspecFile(String projectRoot) => File(join(projectRoot, 'pubspec.yaml'));
