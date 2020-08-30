library cider;

export 'package:cider/src/console/console.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:cider/src/web_support_stub.dart';
export 'package:cider/src/console/console_application.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:cider/src/web_support_stub.dart';
export 'package:cider/src/console/exit_code.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:cider/src/web_support_stub.dart';
