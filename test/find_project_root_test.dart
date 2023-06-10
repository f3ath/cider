import 'dart:io';

import 'package:cider/src/cli/find_project_root.dart';
import 'package:test/test.dart';

void main() {
  group('find_project_root', () {
    bool expectCurrent(Directory dir) => FileSystemEntity.identicalSync(
        dir.absolute.path, Directory.current.path);
    test('from the project root', () {
      expectCurrent(findProjectRoot(Directory.current));
    });
    test('from the test directory', () {
      expectCurrent(findProjectRoot(Directory('test')));
    });
  });
}
