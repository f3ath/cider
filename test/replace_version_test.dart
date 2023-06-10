import 'package:cider/src/replace_version.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  final one = Version.parse('1.0.0');
  final two = Version.parse('2.0.0');
  group('replaceVersion', () {
    test('replaces old version with new version', () {
      final pubspec = 'name: my_app\nversion: 1.0.0\n';
      final result = replaceVersion(pubspec, one, two);
      expect(result, 'name: my_app\nversion: 2.0.0\n');
    });

    test('throws StateError when duplicate version pattern', () {
      final pubspec = 'name: my_app\nversion: 1.0.0\nversion: 1.0.0\n';
      expect(
        () => replaceVersion(pubspec, one, two),
        throwsStateError,
      );
    });

    test('throws StateError when failed to replace version', () {
      final pubspec = 'name: my_app\nversion: 2.0.0\n';
      expect(
        () => replaceVersion(pubspec, one, two),
        throwsStateError,
      );
    });
  });
}
