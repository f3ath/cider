import 'dart:io';

import 'package:cider/src/cider.dart';
import 'package:cider/src/cli/channel.dart';
import 'package:cider/src/cli/cider_cli.dart';
import 'package:cider/src/cli/console.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:test/test.dart';

void main() {
  late Directory temp;
  final cider = Cider();
  final out = BufferChannel();
  final err = BufferChannel();
  final cli = CiderCli(cider, console: Console(out: out, err: err));

  Future<int> run(List<String> args) =>
      cli.run(['--project-root=${temp.absolute.path}', ...args]);

  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    await Directory('test/template').list().forEach((element) async {
      if (element is File) {
        await element.copy(path.join(temp.path, path.basename(element.path)));
      }
    });
    out.buffer.clear();
    err.buffer.clear();
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  group('Smoke', () {
    test('Can read the project version', () async {
      final actual = (await Process.run(
              Platform.executable, ['bin/cider.dart', 'version']))
          .stdout as String;
      final expected = Pubspec.parse(await File('pubspec.yaml').readAsString())
          .version!
          .toString();
      expect(actual.trim(), equals(expected));
    });
  });

  test('Can read the project version', () async {
    await cli.run(['version']);
    final expected = Pubspec.parse(await File('pubspec.yaml').readAsString())
        .version!
        .toString();
    expect(out.buffer.toString().trim(), equals(expected));
  });

  test('Full release cycle', () async {
    final code = await run(['log', 'add', 'Initial release']);
    expect(code, 0);
    await run(['describe']);
    final step1 = '''
## Unreleased
### Added
- Initial release
''';
    expect(out.buffer.toString(), step1);
    await run(['version', '1.0.0']);
    out.buffer.clear();
    await run(['release', '--date=2020-01-02']);
    final step2 = '''
## [1.0.0] - 2020-01-02
### Added
- Initial release

[1.0.0]: https://github.com/example/project/releases/tag/1.0.0
''';
    print(err.buffer);
    expect(out.buffer.toString(), step2);
    out.buffer.clear();
    await run(['log', 'change', 'New turbo V6 engine installed']);
    await run(['log', 'fix', 'Wheels falling off sporadically']);
    await run(['describe']);
    final step3 = '''
## [Unreleased]
### Changed
- New turbo V6 engine installed

### Fixed
- Wheels falling off sporadically

[Unreleased]: https://github.com/example/project/compare/1.0.0...HEAD
''';
    expect(out.buffer.toString(), step3);
    await run(['bump', 'minor']);
    out.buffer.clear();
    await run(['release', '--date=2021-02-03']);
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
    await run(['yank', '1.1.0']);
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
    await run(['unyank', '1.1.0']);
    expect(out.buffer.toString(), step4);
    expect(err.buffer.toString(), isEmpty);
  });

  group('Version', () {
    test('get', () async {
      final code = await run(['version']);
      expect(code, 0);
      expect(out.buffer.toString().trim(), '0.0.5-alpha+42');
      expect(err.buffer.toString(), isEmpty);
    });

    test('set', () async {
      final code = await run(['version', '1.0.0']);
      expect(code, 0);
      expect(out.buffer.toString().trim(), '1.0.0');
      out.buffer.clear();
      await run(['version']);
      expect(out.buffer.toString().trim(), '1.0.0');
      expect(err.buffer.toString(), isEmpty);
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
          final code = await run(args);
          expect(code, 0);
          expect(err.buffer.toString(), isEmpty);
          out.buffer.clear();
          await run(['version']);
          expect(out.buffer.toString().trim(), expected);
        });
      });
      test('version must increase', () async {
        final code = await run(['bump', 'build', '--keep-build']);
        expect(code, 65);
        expect(err.buffer.toString().trim(),
            'The next version must be higher than the current one.');
      });
      test('version part must be specified', () async {
        final code = await run(['bump']);
        expect(code, 65);
        expect(err.buffer.toString().trim(), 'Version part must be specified');
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
