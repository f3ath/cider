import 'package:cider/src/console/command/application_command.dart';
import 'package:cider/src/console/console.dart';
import 'package:cider/src/console/exit_code.dart';
import 'package:pub_semver/pub_semver.dart';

class SetCommand extends ApplicationCommand {
  SetCommand(this._console);

  final Console _console;

  @override
  final description = 'Setting given version explicitly';

  @override
  final name = 'set';

  @override
  final aliases = ['switch', 'change'];

  @override
  int run() {
    try {
      if (argResults.rest.isEmpty) {
        throw UnsupportedError('Version must be specified');
      } else if (argResults.rest.length > 1) {
        throw UnsupportedError('Too many arguments passed');
      } else {
        Version version;
        try {
          version = Version.parse(argResults.rest.single);
        } on dynamic catch (_) {
          throw UnsupportedError('Can\'t parse version');
        }
        _console.log(createApp().set(version));
      }
    } on UnsupportedError catch (e) {
      _console.error(e?.message ?? 'An unsupported error occurred');
      return ExitCode.usageException;
    } on dynamic catch (e) {
      _console.error(e.toString());
      return ExitCode.applicationError;
    }
    return ExitCode.ok;
  }
}
