import 'package:pub_semver/pub_semver.dart';

/// Replaces the version in the [pubspec] from [oldVersion] to [newVersion]
/// while leaving the rest of it intact.
/// We have to operate with raw strings since users were complaining
/// about YAML writers screwing up their formatting and comments.
String replaceVersion(String pubspec, Version oldVersion, Version newVersion) {
  final regex = RegExp(r'^version:\s+(\d+\.\d+\.\d+.*)$', multiLine: true);
  var processed = false;
  return pubspec.replaceAllMapped(regex, (match) {
    if (processed) throw StateError('Duplicate version pattern');
    if (match.group(1) == oldVersion.toString()) {
      processed = true;
      return 'version: $newVersion';
    }
    throw StateError('Failed to replace version');
  });
}
