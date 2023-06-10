import 'package:cider/diff.dart';
import 'package:cider/src/tag.dart';

class Config {
  Config(
      {String diffTemplate = '',
      String tagTemplate = '',
      this.keepEmptyUnreleased = false})
      : diffTemplate = Diff(diffTemplate),
        tagTemplate = Tag(tagTemplate);

  final Diff diffTemplate;
  final Tag tagTemplate;
  final bool keepEmptyUnreleased;
}
