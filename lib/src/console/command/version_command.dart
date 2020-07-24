import 'package:cider/cider.dart';
import 'package:cider/src/console/command/application_command.dart';
import 'package:cider/src/console/console.dart';

class VersionCommand extends ApplicationCommand {
  VersionCommand(this._console);

  final Console _console;

  @override
  final String description = 'Prints your project version';

  @override
  final String name = 'version';

  @override
  final aliases = <String>['ver'];

  @override
  int run() {
    _console.log(createApp().readVersion());
    return ExitCode.ok;
  }
}
