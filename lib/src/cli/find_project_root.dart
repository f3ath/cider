import 'dart:io';

import 'package:path/path.dart';

/// Finds the project root by locating 'pubspec.yaml'.
/// Starts from [dir] and makes its way up to the system root folder.
/// Throws a [StateError] if 'pubspec.yaml' can not be located.
Future<Directory> findProjectRoot(Directory dir) async {
  if (await File(join(dir.path, 'pubspec.yaml')).exists()) return dir;
  if (await dir.isRoot()) throw StateError('Can not find project root');
  return await findProjectRoot(dir.parent);
}

extension _DirectoryExt on Directory {
  Future<bool> isRoot() =>
      FileSystemEntity.identical(this.absolute.path, parent.absolute.path);
}
