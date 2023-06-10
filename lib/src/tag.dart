import 'package:cider/src/template.dart';

final class Tag extends Template {
  const Tag(super.template);

  String render(Object version) =>
      template.replaceAll('%tag%', version.toString());
}
