import 'package:cider/src/template/diff.dart';
import 'package:cider/src/template/tag.dart';

class Config {
  Config(
      {String diffTemplate = '',
      String tagTemplate = '',
      this.tagPrefix = '',
      this.keepEmptyUnreleased = false,
      this.changelogNewline = true})
      : diffTemplate = Diff(diffTemplate),
        tagTemplate = Tag(tagTemplate);

  final Diff diffTemplate;
  final Tag tagTemplate;
  final bool keepEmptyUnreleased;
  final bool changelogNewline;
  final String tagPrefix;
}
