import 'package:cider/src/template/template.dart';

final class Version extends Template {
  const Version(super.template);

  String render(Object version) =>
      template.replaceAll('%version%', version.toString());
}
