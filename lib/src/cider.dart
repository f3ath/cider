import 'package:cider/src/changelog_service.dart';
import 'package:cider/src/pubspec_service.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:rfc_6901/rfc_6901.dart';
import 'package:version_manipulation/mutations.dart';

/// The core application.
class Cider {
  /// Reads the project version from pubspec.yaml.
  Future<Version> getVersion(Context context) => _pubspec(context).getVersion();

  /// Writes the project version to pubspec.yaml.
  Future<void> setVersion(Context context, String version) =>
      _pubspec(context).setVersion(Version.parse(version));

  Future<String> bumpVersion(Context context, VersionMutation mutation,
          {bool keepBuild = false,
          bool bumpBuild = false,
          String build = '',
          String pre = ''}) async =>
      (await _pubspec(context).mutateVersion(mutation,
              keepBuild: keepBuild,
              bumpBuild: bumpBuild,
              build: build,
              pre: pre))
          .toString();

  /// Adds a new entry to the `Unreleased` section.
  /// Type is one of `a`, `c`, `d`, `f`, `r`, `s`.
  Future<void> addUnreleased(
      Context context, String type, String description) async {
    await (await _changelog(context)).addUnreleased(type, description);
  }

  /// Returns a markdown description of the given [version] or the `Unreleased`
  /// section.
  Future<String> describe(Context context, String? version,
          {bool onlyBody = false}) async =>
      (await _changelog(context)).describe(version, onlyBody: onlyBody);

  /// Releases the `Unreleased` section.
  /// Returns the description of the created release.
  Future<String> release(Context context, DateTime date,
          {Version? version}) async =>
      (await _changelog(context))
          .release(date, version ?? await _pubspec(context).getVersion());

  Future<String> yank(Context context, String version) async =>
      (await _changelog(context)).yank(version);

  Future<String> unyank(Context context, String version) async =>
      (await _changelog(context)).unyank(version);

  /// Lists all versions in the changelog.
  /// If [includeYanked] is true, yanked version will be included.
  /// if [includeUnreleased] is true and the "Unreleased" section is not empty,
  /// the "Unreleased" section will be prepended to the listing.
  Future<List<String>> getAllVersions(Context context,
          {bool includeYanked = false, bool includeUnreleased = false}) async =>
      (await _changelog(context)).getAllVersions(
          includeUnreleased: includeUnreleased, includeYanked: includeYanked);

  Future<ChangelogService> _changelog(Context context) async {
    final ps = _pubspec(context);
    final config = await ps.getValue('/cider', orElse: () => {});
    final diffTemplate = JsonPointer('/link_template/diff')
        .read(config, orElse: () => '')
        .toString();
    final tagTemplate = JsonPointer('/link_template/tag')
        .read(config, orElse: () => '')
        .toString();
    final keepEmptyUnreleased = JsonPointer('/keep_empty_unreleased')
        .read(config, orElse: () => false) as bool;
    return ChangelogService(context.projectRoot,
        diffTemplate: diffTemplate,
        tagTemplate: tagTemplate,
        keepEmptyUnreleased: keepEmptyUnreleased);
  }

  PubspecService _pubspec(Context context) =>
      PubspecService(context.projectRoot);
}

class Context {
  Context(this.projectRoot);

  final String projectRoot;
}
