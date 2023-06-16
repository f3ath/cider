import 'package:cider/src/diff.dart';
import 'package:cider/src/tag.dart';

class Config {
  Config(
      {String diffTemplate = '',
      String tagTemplate = '',
      this.keepEmptyUnreleased = false,
      this.changelogNewline = true})
      : diffTemplate = Diff(diffTemplate),
        tagTemplate = Tag(tagTemplate);

  final Diff diffTemplate;
  final Tag tagTemplate;
  final bool keepEmptyUnreleased;
  final bool changelogNewline;
}
