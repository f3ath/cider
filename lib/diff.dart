import 'package:cider/src/template.dart';

final class Diff extends Template {
  const Diff(super.template);

  String render(Object from, Object to) => template
      .replaceAll('%from%', from.toString())
      .replaceAll('%to%', to.toString());
}
