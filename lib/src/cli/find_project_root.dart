import 'dart:io';

import 'package:path/path.dart';

/// Finds the project root by locating 'pubspec.yaml'.
/// Starts from [dir] and makes its way up to the system root folder.
/// Throws a [StateError] if 'pubspec.yaml' can not be located.
Directory findProjectRoot(Directory dir) {
  if (File(join(dir.path, 'pubspec.yaml')).existsSync()) return dir;
  if (dir.isRoot) throw StateError('Can not find project root');
  return findProjectRoot(dir.parent);
}

extension _DirectoryExt on Directory {
  bool get isRoot =>
      FileSystemEntity.identicalSync(this.absolute.path, parent.absolute.path);
}
