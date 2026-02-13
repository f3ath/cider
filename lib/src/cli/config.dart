import 'package:cider/src/template/diff_link.dart';
import 'package:cider/src/template/tag_link.dart';
import 'package:cider/src/template/version.dart';
import 'package:rfc_6901/rfc_6901.dart';

class Config {
  Config({
    String? diffTemplate,
    String? tagTemplate,
    String? versionTemplate,
    bool? keepEmptyUnreleased,
    bool? changelogNewline,
  })  : diffTemplate = DiffLink(diffTemplate ?? ''),
        tagTemplate = TagLink(tagTemplate ?? ''),
        versionTemplate = Version(versionTemplate ?? '%version%'),
        keepEmptyUnreleased = keepEmptyUnreleased ?? false,
        changelogNewline = changelogNewline ?? true;

  static Config fromPubspec(Map yaml) => Config(
        diffTemplate:
            yaml.read<String?>('/cider/link_template/diff', orElse: () => null),
        tagTemplate:
            yaml.read<String?>('/cider/link_template/tag', orElse: () => null),
        versionTemplate: yaml.read<String?>('/cider/link_template/version',
            orElse: () => null),
        keepEmptyUnreleased: yaml.read<bool?>('/cider/keep_empty_unreleased',
            orElse: () => null),
        changelogNewline:
            yaml.read<bool?>('/cider/changelog_new_line', orElse: () => null),
      );

  final DiffLink diffTemplate;
  final TagLink tagTemplate;
  final Version versionTemplate;
  final bool keepEmptyUnreleased;
  final bool changelogNewline;
}

extension on Map {
  T read<T>(String pointer, {T Function()? orElse}) =>
      JsonPointer(pointer).read(this, orElse: orElse) as T;
}
