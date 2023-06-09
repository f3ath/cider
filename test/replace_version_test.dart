import 'package:cider/src/replace_version.dart';
import 'package:test/test.dart';

void main() {
  group('replaceVersion', () {
    test('replaces old version with new version', () {
      final pubspec = 'name: my_app\nversion: 1.0.0\n';
      final result = replaceVersion(pubspec, '1.0.0', '2.0.0');
      expect(result, 'name: my_app\nversion: 2.0.0\n');
    });

    test('throws StateError when duplicate version pattern', () {
      final pubspec = 'name: my_app\nversion: 1.0.0\nversion: 1.0.0\n';
      expect(
        () => replaceVersion(pubspec, '1.0.0', '2.0.0'),
        throwsA(isA<StateError>()),
      );
    });

    test('throws StateError when failed to replace version', () {
      final pubspec = 'name: my_app\nversion: 2.0.0\n';
      expect(
        () => replaceVersion(pubspec, '1.0.0', '2.0.0'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
