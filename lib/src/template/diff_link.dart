import 'package:cider/src/template/template.dart';

final class DiffLink extends Template {
  const DiffLink(super.template);

  String render(Object from, Object to) => template
      .replaceAll('%from%', from.toString())
      .replaceAll('%to%', to.toString());
}
