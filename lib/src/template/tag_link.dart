import 'package:cider/src/template/template.dart';

final class TagLink extends Template {
  const TagLink(super.template);

  String render(Object version) =>
      template.replaceAll('%tag%', version.toString());
}
