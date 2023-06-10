import 'dart:io';

import 'package:cider/cider.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

import 'src/testing.dart';

void main() {
  late Directory temp;
  late Cider cider;
  late MockStdout out, err;
  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    await Directory('test/template').list().forEach((element) {
      if (element is File) {
        element.copy(join(temp.path, basename(element.path)));
      }
    });
    out = MockStdout();
    err = MockStdout();
    cider = Cider(root: temp);
    cider.provide<Stdout>((_) => out);
    cider.provide<Stdout>((_) => err, name: 'stderr');
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('Full release cycle', () async {
    final code = await cider.run(['log', 'add', 'Initial release']);
    expect(code, 0);
    await cider.run(['describe']);
    final step1 = '''
## Unreleased
### Added
- Initial release
''';
    expect(out.buffer.toString(), step1);
    await cider.run(['version', '1.0.0']);
    out.buffer.clear();
    await cider.run(['release', '--date=2020-01-02']);
    final step2 = '''
## [1.0.0] - 2020-01-02
### Added
- Initial release

[1.0.0]: https://github.com/example/project/releases/tag/1.0.0
''';
    expect(out.buffer.toString(), step2);
    out.buffer.clear();
    await cider.run(['log', 'change', 'New turbo V6 engine installed']);
    await cider.run(['log', 'fix', 'Wheels falling off sporadically']);
    await cider.run(['describe']);
    final step3 = '''
## [Unreleased]
### Changed
- New turbo V6 engine installed

### Fixed
- Wheels falling off sporadically

[Unreleased]: https://github.com/example/project/compare/1.0.0...HEAD
''';
    expect(out.buffer.toString(), step3);
    await cider.run(['bump', 'minor']);
    out.buffer.clear();
    await cider.run(['release', '--date=2021-02-03']);
    final step4 = '''
## [1.1.0] - 2021-02-03
### Changed
- New turbo V6 engine installed

### Fixed
- Wheels falling off sporadically

[1.1.0]: https://github.com/example/project/compare/1.0.0...1.1.0
''';
    expect(out.buffer.toString(), step4);
    out.buffer.clear();
    await cider.run(['yank', '1.1.0']);
    final step5 = '''
## [1.1.0] - 2021-02-03 \\[YANKED\\]
### Changed
- New turbo V6 engine installed

### Fixed
- Wheels falling off sporadically

[1.1.0]: https://github.com/example/project/compare/1.0.0...1.1.0
''';
    expect(out.buffer.toString(), step5);
    out.buffer.clear();
    await cider.run(['unyank', '1.1.0']);
    expect(out.buffer.toString(), step4);
  });

  group('Version', () {
    test('get', () async {
      final code = await cider.run(['version']);
      expect(code, 0);
      expect(out.buffer.toString().trim(), '0.0.5-alpha+42');
    });

    test('set', () async {
      final code = await cider.run(['version', '1.0.0']);
      expect(code, 0);
      expect(out.buffer.toString().trim(), '1.0.0');
      out.buffer.clear();
      await cider.run(['version']);
      expect(out.buffer.toString().trim(), '1.0.0');
    });

    group('bump', () {
      <List<String>, String>{
        ['bump', 'breaking']: '0.1.0',
        ['bump', 'breaking', '--keep-build']: '0.1.0+42',
        ['bump', 'breaking', '--bump-build']: '0.1.0+43',
        ['bump', 'breaking', '--build=foo']: '0.1.0+foo',
        ['bump', 'breaking', '--pre=beta']: '0.1.0-beta',
        ['bump', 'breaking', '--pre=beta', '--build=foo']: '0.1.0-beta+foo',
        ['bump', 'major']: '1.0.0',
        ['bump', 'major', '--keep-build']: '1.0.0+42',
        ['bump', 'major', '--bump-build']: '1.0.0+43',
        ['bump', 'major', '--build=foo']: '1.0.0+foo',
        ['bump', 'major', '--pre=beta']: '1.0.0-beta',
        ['bump', 'minor']: '0.1.0',
        ['bump', 'minor', '--keep-build']: '0.1.0+42',
        ['bump', 'minor', '--bump-build']: '0.1.0+43',
        ['bump', 'minor', '--build=foo']: '0.1.0+foo',
        ['bump', 'minor', '--pre=beta']: '0.1.0-beta',
        ['bump', 'patch']: '0.0.5',
        ['bump', 'patch', '--keep-build']: '0.0.5+42',
        ['bump', 'patch', '--bump-build']: '0.0.5+43',
        ['bump', 'patch', '--build=foo']: '0.0.5+foo',
        ['bump', 'patch', '--pre=beta']: '0.0.5-beta',
        ['bump', 'build']: '0.0.5-alpha+43',
        ['bump', 'build', '--pre=beta']: '0.0.5-beta+43',
        ['bump', 'pre']: '0.0.5-alpha.1',
        ['bump', 'pre', '--keep-build']: '0.0.5-alpha.1+42',
        ['bump', 'pre', '--bump-build']: '0.0.5-alpha.1+43',
        ['bump', 'pre', '--build=foo']: '0.0.5-alpha.1+foo',
        ['bump', 'pre', '--pre=beta']: '0.0.5-beta',
        ['bump', 'release']: '0.0.5',
        ['bump', 'release', '--keep-build']: '0.0.5+42',
      }.forEach((args, expected) {
        test('${args.join(' ')} => $expected', () async {
          final code = await cider.run(args);
          expect(code, 0);
          out.buffer.clear();
          await cider.run(['version']);
          expect(out.buffer.toString().trim(), expected);
        });
      });
    });
  });

  group('Find Root', () {
    test('valid root', () async {
      final code = await cider.run(['version']);
      expect(code, Cider.exitOK);
    });

    test('invalid root', () async {
      Directory fsRoot = Directory.current;

      while (!FileSystemEntity.identicalSync(fsRoot.path, fsRoot.parent.path)) {
        fsRoot = fsRoot.parent;
      }

      Cider ciderAtRoot = Cider(root: fsRoot);
      ciderAtRoot.provide<Stdout>((_) => out);
      ciderAtRoot.provide<Stdout>((_) => err, name: 'stderr');
      final code = await ciderAtRoot.run(['version']);
      expect(code, Cider.exitException);
      expect(err.buffer.toString(), contains("Can not find project root"));
    });
  });
}
