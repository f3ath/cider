import 'package:cider/src/template/diff.dart';
import 'package:cider/src/template/tag.dart';
import 'package:cider/src/template/version.dart';

class Config {
  Config({
    String diffTemplate = '',
    String tagTemplate = '',
    String versionTemplate = '',
    this.keepEmptyUnreleased = false,
    this.changelogNewline = true,
  })  : diffTemplate = Diff(diffTemplate),
        tagTemplate = Tag(tagTemplate),
        versionTemplate = Version(versionTemplate);

  final Diff diffTemplate;
  final Tag tagTemplate;
  final Version versionTemplate;
  final bool keepEmptyUnreleased;
  final bool changelogNewline;
}
